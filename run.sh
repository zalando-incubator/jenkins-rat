#!/usr/bin/env bash
set -euo pipefail
IFS=$'\t\n'
#set -x

PLUGINS_DIR="${JENKINS_HOME}/plugins/"

set +e
files=($PLUGINS_DIR/openam-oauth.*pi)
OAUTH_PLUGIN_VERSION=$(./extract-from-manifest.sh "$files" Implementation-Version)
files=($PLUGINS_DIR/cloud-kraken-plugin.*pi)
KRAKEN_PLUGIN_VERSION=$(./extract-from-manifest.sh "$files" Implementation-Version)
ENV_VARS=$(env | grep -E "^OAUTH2_ACCESS_TOKEN_URL=")
JENKINS_URL=${HUDSON_URL:-}
set -e

DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

JSON=$(echo "{}" | jq ".timestamp=\"$DATE\"" \
    | jq ".oauth2_plugin_version=\"$OAUTH_PLUGIN_VERSION\"" \
    | jq ".kraken_plugin_version=\"$KRAKEN_PLUGIN_VERSION\"" \
    | jq ".env_vars=\"$ENV_VARS\"" \
    | jq ".jenkins_url=\"$JENKINS_URL\"")

./send-hipchat-notification.sh "$JSON"
