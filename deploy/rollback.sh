#!/usr/bin/env bash
# Revient à la version précédente du back ou du front sur la preprod.
# Usage : deploy/rollback.sh back|front [release]   (sans release : la version d'avant)
set -euo pipefail

SSH_HOST="${SSH_HOST:-production}"
REMOTE_ROOT="${REMOTE_ROOT:-/var/www/epa/foncier}"

case "${1:-}" in
    back)  APP_DIR="$REMOTE_ROOT/api-foncier" ;;
    front) APP_DIR="$REMOTE_ROOT/front-foncier" ;;
    *) sed -n '2,3p' "$0"; exit 1 ;;
esac

ssh "$SSH_HOST" bash -s -- "$1" "$APP_DIR" "${2:-}" "$REMOTE_ROOT" <<'REMOTE'
set -euo pipefail
TARGET=$1 APP_DIR=$2 WANTED=$3 REMOTE_ROOT=$4
cd "$APP_DIR"
CURRENT=$(basename "$(readlink current)")

if [[ -n "$WANTED" ]]; then
    TO="$WANTED"
else
    TO=$(ls -1 releases | sort | grep -B1 -x "$CURRENT" | head -n 1)
fi
[[ -n "$TO" && "$TO" != "$CURRENT" && -d "releases/$TO" ]] || {
    echo "✘ Aucune version précédente. Versions disponibles :"; ls -1 releases; exit 1; }

ln -sfn "releases/$TO" current.tmp && mv -Tf current.tmp current
if [[ "$TARGET" == "back" ]]; then
    docker exec api_foncier sh -c 'rm -rf "$1"/cache/*; kill -USR2 1' sh "$APP_DIR/shared/var" || true
fi
echo "$(date '+%F %T') $TARGET ROLLBACK $CURRENT → $TO" >> "$REMOTE_ROOT/DEPLOYS.log"
echo "↩ $TARGET : $CURRENT → $TO"
REMOTE
