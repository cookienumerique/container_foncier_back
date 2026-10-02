#!/usr/bin/env bash
# Déploie le back ou le front de Foncier sur la preprod, depuis le Mac.
#
# Usage : deploy/deploy.sh back|front <branche|tag|sha>
#   ex.  deploy/deploy.sh back 1.2.0
#
# Étapes : fetch → export propre de la version → build (Docker) → rsync dans
# releases/<horodatage>_<ref>_<sha> → bascule atomique du lien current →
# contrôle de santé → retour arrière automatique si le contrôle échoue.
#
# Variables (surcharges possibles) : SSH_HOST, REMOTE_ROOT, BACK_REPO, FRONT_REPO, KEEP
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"   # /var/www/epa/foncier en local

SSH_HOST="${SSH_HOST:-production}"
REMOTE_ROOT="${REMOTE_ROOT:-/var/www/epa/foncier}"
BACK_REPO="${BACK_REPO:-$ROOT/foncier_back}"
FRONT_REPO="${FRONT_REPO:-$ROOT/foncier_front}"
FRONT_ENV="$HERE/env/front.preprod.env"
KEEP="${KEEP:-5}"

TARGET="${1:-}"
REF="${2:-}"
case "$TARGET" in
    back)  REPO="$BACK_REPO";  APP_DIR="$REMOTE_ROOT/api-foncier" ;;
    front) REPO="$FRONT_REPO"; APP_DIR="$REMOTE_ROOT/front-foncier" ;;
    *) sed -n '2,12p' "$0"; exit 1 ;;
esac
[[ -n "$REF" ]] || { echo "✘ Précise une branche, un tag ou un sha." >&2; exit 1; }

step() { printf '\n\033[1;34m▶ %s\033[0m\n' "$*"; }
fail() { printf '\033[1;31m✘ %s\033[0m\n' "$*" >&2; exit 1; }

# ───────────── 1. Résolution de la version ─────────────
step "Récupération de $REF depuis la forge"
git -C "$REPO" fetch --tags --prune origin
if git -C "$REPO" rev-parse -q --verify "origin/$REF^{commit}" >/dev/null; then
    SHA=$(git -C "$REPO" rev-parse "origin/$REF^{commit}")
else
    SHA=$(git -C "$REPO" rev-parse -q --verify "$REF^{commit}") || fail "Référence introuvable : $REF"
fi
SHORT=${SHA:0:7}
RELEASE="$(date +%Y%m%d-%H%M%S)_${REF//\//-}_$SHORT"
echo "  $TARGET $REF → $SHORT ($(git -C "$REPO" log -1 --format='%s' "$SHA"))"

ssh "$SSH_HOST" true || fail "Connexion SSH impossible vers $SSH_HOST"

# ───────────── 2. Export propre (jamais le dossier de travail) ─────────────
BUILD="$(mktemp -d)"
trap 'rm -rf "$BUILD"' EXIT
git -C "$REPO" archive "$SHA" | tar -x -C "$BUILD"

# ───────────── 3. Build ─────────────
if [[ "$TARGET" == "back" ]]; then
    step "Build du back (composer dans l'image PHP de preprod)"
    docker build -q -t foncier-api:build --build-arg XDEBUG=false --build-arg PHP_INI=php.preprod.ini "$HERE/../docker" >/dev/null
    docker run --rm -v "$BUILD":/app -w /app -v foncier-composer-cache:/tmp/composer -e COMPOSER_HOME=/tmp/composer \
        foncier-api:build composer install --no-dev --no-scripts --optimize-autoloader --no-interaction --no-progress
    rm -rf "$BUILD/tests" "$BUILD/var" "$BUILD/config/.env"
    # Liens vers les fichiers partagés (même chemin sur l'hôte et dans le conteneur)
    ln -s "$APP_DIR/shared/config/.env" "$BUILD/config/.env"
    ln -s "$APP_DIR/shared/var" "$BUILD/var"
    VERSION_FILE="$BUILD/public/version.json"
else
    step "Build du front (node 18 sous Docker)"
    [[ -f "$FRONT_ENV" ]] || fail "Fichier manquant : $FRONT_ENV (voir front.preprod.env.dist)"
    cp "$FRONT_ENV" "$BUILD/.env.production.local"
    docker run --rm -v "$BUILD":/app -w /app -v foncier-yarn-cache:/usr/local/share/.cache/yarn \
        node:18.17.1 sh -c "yarn install --frozen-lockfile --non-interactive && yarn build"
    # Seul le résultat du build est publié ; config.js est fourni par le serveur.
    mv "$BUILD/build" "$BUILD.out" && rm -rf "$BUILD" && mv "$BUILD.out" "$BUILD"
    rm -f "$BUILD/config.js"
    ln -s "$APP_DIR/shared/config.js" "$BUILD/config.js"
    VERSION_FILE="$BUILD/version.json"
fi

printf '{"app":"%s","ref":"%s","sha":"%s","release":"%s","deployed_at":"%s","by":"%s"}\n' \
    "$TARGET" "$REF" "$SHA" "$RELEASE" "$(date -u +%FT%TZ)" "$(git config user.email || whoami)" > "$VERSION_FILE"

# ───────────── 4. Envoi ─────────────
step "Envoi de $RELEASE"
# Lisible par nginx et php-fpm (www-data) ; mktemp crée le dossier en 700.
chmod -R a+rX "$BUILD"
LINK_DEST=$(ssh "$SSH_HOST" "test -d '$APP_DIR/current' && echo --link-dest='$APP_DIR/current/'" || true)
rsync -az --delete $LINK_DEST "$BUILD/" "$SSH_HOST:$APP_DIR/releases/$RELEASE/"

# ───────────── 5. Bascule, contrôle, retour arrière ─────────────
step "Bascule et contrôle"
ssh "$SSH_HOST" bash -s -- "$TARGET" "$APP_DIR" "$RELEASE" "$KEEP" "$REMOTE_ROOT" <<'REMOTE'
set -euo pipefail
TARGET=$1 APP_DIR=$2 RELEASE=$3 KEEP=$4 REMOTE_ROOT=$5
cd "$APP_DIR"

# Garde-fous sur la config partagée
if [[ "$TARGET" == "back" ]]; then
    [[ -f shared/config/.env ]] || { echo "✘ shared/config/.env manquant"; rm -rf "releases/$RELEASE"; exit 1; }
    grep -qE '^SERVER_CAS="?https?://' shared/config/.env \
        || { echo "✘ SERVER_CAS vide : l'API serait ouverte à tous en admin. Déploiement annulé."; rm -rf "releases/$RELEASE"; exit 1; }
else
    [[ -f shared/config.js ]] || { echo "✘ shared/config.js manquant"; rm -rf "releases/$RELEASE"; exit 1; }
fi

PREVIOUS=$(readlink current 2>/dev/null || true)

switch_to() {
    ln -sfn "$1" current.tmp && mv -Tf current.tmp current
    if [[ "$TARGET" == "back" ]]; then
        # Vide le cache Slim et recharge php-fpm (opcache) pour la nouvelle version
        docker exec api_foncier sh -c 'rm -rf "$1"/cache/*; kill -USR2 1' sh "$APP_DIR/shared/var" || true
    fi
}

healthy() {
    if [[ "$TARGET" == "back" ]]; then
        for _ in 1 2 3 4 5; do
            code=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3110/get-server-cas || true)
            [[ "$code" == "200" ]] && return 0
            sleep 2
        done
        echo "  /get-server-cas a répondu $code"
        return 1
    else
        [[ -s current/index.html && -s current/version.json ]]
    fi
}

switch_to "releases/$RELEASE"
if healthy; then
    echo "✔ $TARGET en ligne : $RELEASE"
    echo "$(date '+%F %T') $TARGET $RELEASE OK" >> "$REMOTE_ROOT/DEPLOYS.log"
else
    echo "✘ Contrôle de santé en échec."
    if [[ -n "$PREVIOUS" ]]; then
        switch_to "$PREVIOUS"
        echo "↩ Retour à $PREVIOUS"
    fi
    echo "$(date '+%F %T') $TARGET $RELEASE ECHEC (retour à ${PREVIOUS:-rien})" >> "$REMOTE_ROOT/DEPLOYS.log"
    exit 1
fi

# Ménage : on garde les $KEEP dernières versions
ls -1 releases | sort | head -n -"$KEEP" | while read -r old; do
    [[ "releases/$old" == "$(readlink current)" ]] || rm -rf "releases/$old"
done
REMOTE
