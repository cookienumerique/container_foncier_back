#!/usr/bin/env bash
# Remplace le schéma foncier par un dump de prod (format custom de pg_dump).
#
# Usage :
#   PG_CONTAINER=container_postgres ./restore-prod-dump.sh ~/Downloads/20260319_foncier.sql
#
# Étapes :
#   1. sauvegarde la base actuelle à côté du dump (backup_<base>_<date>.dump) ;
#   2. supprime le schéma foncier et restaure le dump, sans propriétaires ni droits ;
#   3. ajoute ce qui manque au dump (sql/prod-dump-complements.sql) : fonctions et
#      triggers de foncier.bien, vues vides à la place des vues qui lisent les schémas SIG ;
#   4. passe les scripts des versions de foncier_back (db/scripts/X.Y.Z/*.sql), dans l'ordre.
#
# pg_restore est lancé sur le Mac : celui du conteneur est souvent trop ancien
# pour lire un dump fait avec un pg_dump plus récent.
#
# Variables : PG_CONTAINER (défaut : postgres_foncier),
#             FONCIER_BACK (défaut : le dépôt foncier_back voisin)
set -euo pipefail

CONTAINER="${PG_CONTAINER:-postgres_foncier}"
DB_DIR="$(cd "$(dirname "$0")" && pwd)"
FONCIER_BACK="${FONCIER_BACK:-$DB_DIR/../../../foncier_back}"
DUMP="${1:-}"

[[ "$DUMP" == "-h" || "$DUMP" == "--help" ]] && { sed -n '2,18p' "$0"; exit 0; }
[[ -f "$DUMP" ]] || { echo "✘ Dump introuvable : ${DUMP:-<aucun>}. Usage : $0 <dump>" >&2; exit 1; }
command -v pg_restore > /dev/null || { echo "✘ pg_restore absent du Mac (brew install postgresql)." >&2; exit 1; }
pg_restore -l "$DUMP" > /dev/null || { echo "✘ $DUMP n'est pas un dump au format custom." >&2; exit 1; }
[[ -d "$FONCIER_BACK/db/scripts" ]] || { echo "✘ foncier_back introuvable : $FONCIER_BACK" >&2; exit 1; }

psql_c() {
    docker exec -i -e PGOPTIONS="-c client_min_messages=warning" "$CONTAINER" sh -c 'exec psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -q "$@"' psql "$@"
}

docker inspect -f '{{.State.Running}}' "$CONTAINER" 2>/dev/null | grep -q true \
    || { echo "✘ Le conteneur $CONTAINER ne tourne pas." >&2; exit 1; }

DB_NAME=$(docker exec "$CONTAINER" sh -c 'echo "$POSTGRES_DB"')
read -r -p "⚠ Le schéma foncier de « $DB_NAME » ($CONTAINER) sera remplacé par le dump. Tape le nom de la base pour confirmer : " CONFIRM
[[ "$CONFIRM" == "$DB_NAME" ]] || { echo "Annulé."; exit 1; }

BACKUP="$(dirname "$DUMP")/backup_${DB_NAME}_$(date +%Y%m%d_%H%M%S).dump"
docker exec "$CONTAINER" sh -c 'exec pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Fc' > "$BACKUP"
echo "✔ Base actuelle sauvegardée : $BACKUP"

psql_c -v ON_ERROR_STOP=1 -c "DROP SCHEMA IF EXISTS foncier CASCADE" -c "CREATE SCHEMA foncier" < /dev/null

# Pas d'arrêt sur erreur : les objets qui dépendent des schémas SIG échouent,
# ils sont remplacés juste après. \restrict (pg_restore 18) est inconnu des psql plus anciens.
LOG=$(mktemp)
pg_restore --no-owner --no-acl -f - "$DUMP" \
    | grep -vE '^SET transaction_timeout|^\\(un)?restrict' \
    | psql_c > /dev/null 2> "$LOG" || true
echo "✔ Dump restauré. Objets non créés (attendus : schémas SIG absents, fonctions des triggers) :"
grep ERROR "$LOG" | sort | uniq -c | sed 's/^/    /' || true
rm -f "$LOG"

psql_c -v ON_ERROR_STOP=1 --single-transaction < "$DB_DIR/sql/prod-dump-complements.sql" > /dev/null
echo "✔ Fonctions, triggers et vues SIG vides ajoutés."

VERSIONS=$(find "$FONCIER_BACK/db/scripts" -mindepth 1 -maxdepth 1 -type d | xargs -n1 basename \
    | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V || true)
for version in $VERSIONS; do
    for f in "$FONCIER_BACK/db/scripts/$version"/*.sql; do
        psql_c -v ON_ERROR_STOP=1 < "$f" > /dev/null
        echo "✔ Script $version/$(basename "$f")"
    done
done

psql_c -v ON_ERROR_STOP=1 -At < /dev/null -c "
SELECT format('✔ %s biens, %s dossiers, %s utilisateurs.',
    (SELECT count(*) FROM foncier.bien),
    (SELECT count(*) FROM foncier.dossier),
    (SELECT count(*) FROM foncier.utilisateur))"
