#!/usr/bin/env bash
# Initialise la base foncier dans le conteneur Postgres : extensions, schéma,
# référentiels, puis (par défaut) le jeu de données fictif.
#
# Usage :
#   ./init-db.sh                          base vide uniquement
#   ./init-db.sh --reset                  supprime le schéma foncier et recrée tout
#   ./init-db.sh --no-seed                schéma + référentiels, sans données fictives
#   ./init-db.sh --admin a@x.fr,b@y.fr    ajoute ces emails en administrateurs
#                                         (sur une base déjà installée : seulement les admins)
#
# Les emails --admin doivent être ceux renvoyés par le CAS : à la connexion,
# l'API retrouve l'utilisateur par son email et il obtient le profil ADM.
#
# Variable : PG_CONTAINER (défaut : postgres_foncier)
set -euo pipefail

CONTAINER="${PG_CONTAINER:-postgres_foncier}"
SQL_DIR="$(cd "$(dirname "$0")" && pwd)/sql"
RESET=false
SEED=true
ADMINS=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --reset) RESET=true ;;
        --no-seed) SEED=false ;;
        --admin) ADMINS="${2:?--admin attend des emails séparés par des virgules}"; shift ;;
        -h|--help) sed -n '2,15p' "$0"; exit 0 ;;
        *) echo "Option inconnue : $1" >&2; exit 1 ;;
    esac
    shift
done

psql_c() {
    docker exec -i -e PGOPTIONS="-c client_min_messages=warning" "$CONTAINER" sh -c 'exec psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 -q "$@"' psql "$@"
}

docker inspect -f '{{.State.Running}}' "$CONTAINER" 2>/dev/null | grep -q true \
    || { echo "✘ Le conteneur $CONTAINER ne tourne pas." >&2; exit 1; }

DB_NAME=$(docker exec "$CONTAINER" sh -c 'echo "$POSTGRES_DB"')
HAS_SCHEMA=$(psql_c -Atc "SELECT count(*) FROM pg_namespace WHERE nspname = 'foncier'" < /dev/null)

INSTALL=true
if [[ "$HAS_SCHEMA" == "1" ]] && ! $RESET && [[ -n "$ADMINS" ]]; then
    INSTALL=false
elif [[ "$HAS_SCHEMA" == "1" ]]; then
    if ! $RESET; then
        echo "✘ Le schéma foncier existe déjà dans $DB_NAME. Relance avec --reset pour tout recréer." >&2
        exit 1
    fi
    read -r -p "⚠ Toutes les données du schéma foncier de « $DB_NAME » seront supprimées. Tape le nom de la base pour confirmer : " CONFIRM
    [[ "$CONFIRM" == "$DB_NAME" ]] || { echo "Annulé."; exit 1; }
    psql_c -c "DROP SCHEMA foncier CASCADE" < /dev/null
fi

if $INSTALL; then
    FILES=("$SQL_DIR/00-extensions.sql" "$SQL_DIR/01-schema.sql" "$SQL_DIR/02-referentiel.sql")
    $SEED && FILES+=("$SQL_DIR/03-seed-fictif.sql")

    # Tout passe dans une seule transaction : en cas d'erreur, la base reste vide.
    cat "${FILES[@]}" | psql_c --single-transaction > /dev/null
    if $SEED; then
        echo "✔ Schéma, référentiels et données fictives installés."
    else
        echo "✔ Schéma et référentiels installés (sans données)."
    fi
fi

for email in ${ADMINS//,/ }; do
    psql_c --single-transaction -v "email=$email" <<'SQL'
SET search_path = foncier;
INSERT INTO utilisateur (s_nom, s_email, dt_creation)
SELECT split_part(:'email', '@', 1), :'email', date_trunc('second', now())::timestamp
WHERE NOT EXISTS (SELECT 1 FROM utilisateur WHERE s_email = :'email');

INSERT INTO authentification (fk_utilisateur, s_login, b_is_admin)
SELECT u.pk_utilisateur, split_part(:'email', '@', 1), true
FROM utilisateur u
WHERE u.s_email = :'email'
  AND NOT EXISTS (SELECT 1 FROM authentification a WHERE a.fk_utilisateur = u.pk_utilisateur);

UPDATE authentification
SET b_is_admin = true,
    fk_liste_profil = (SELECT pk_liste FROM liste WHERE s_groupe = 'user.profil' AND s_clef = 'ADM')
WHERE fk_utilisateur = (SELECT pk_utilisateur FROM utilisateur WHERE s_email = :'email');
SQL
    echo "✔ Administrateur : $email"
done
