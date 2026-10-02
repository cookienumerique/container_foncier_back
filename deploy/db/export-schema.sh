#!/usr/bin/env bash
# Régénère le schéma et les référentiels à partir de la base locale de dev.
# À lancer sur le Mac quand le schéma évolue, puis commiter deploy/db/sql/.
# Usage : ./export-schema.sh [conteneur]   (défaut : container_postgres)
set -euo pipefail

CONTAINER="${1:-container_postgres}"
DIR="$(cd "$(dirname "$0")" && pwd)/sql"

dump() {
    docker exec "$CONTAINER" sh -c 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" --no-owner --no-privileges '"$*"
}

# Schéma seul (tables, vues, fonctions, contraintes), sans données.
dump --schema-only -n foncier > "$DIR/01-schema.sql"

# Référentiels non personnels : listes de valeurs, communes, opérations.
dump --data-only --inserts -t foncier.liste -t foncier.commune -t foncier.operation > "$DIR/02-referentiel.sql"

echo "✔ Schéma et référentiels exportés depuis $CONTAINER vers $DIR"
