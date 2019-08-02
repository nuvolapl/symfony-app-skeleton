#!/usr/bin/env bash

. ./.docker/bin/config.sh

echo -n 'Creating docker network... '
docker network inspect "${PROJECT_NETWORK_NAME}" &>/dev/null || docker network create "${PROJECT_NETWORK_NAME}" &>/dev/null
echo 'OK'

./.docker/bin/compose.sh up -d --build

sleep 15

if [[ 'dev' == "${PROJECT_ENV}" && 'prod' == "${NODE_ENV}" ]]; then
  ./.docker/bin/compose.sh exec "${APP_NAME}" yarn run build
fi
