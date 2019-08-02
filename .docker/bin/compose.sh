#!/usr/bin/env bash

. ./.docker/bin/config.sh

declare -x COMPOSE_FILE="./.docker/docker-compose.yml"

if [[ 'prod' != "${PROJECT_ENV}" ]]; then
  COMPOSE_FILE="${COMPOSE_FILE}:./.docker/docker-compose.${PROJECT_ENV}.yml"
fi

declare -x COMPOSE_PROJECT_NAME="${PROJECT_NAMESPACE}_${PROJECT_ENV}"

docker-compose "$@"
