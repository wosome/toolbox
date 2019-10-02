#!/bin/bash

SERVICE="$1"

export DIR_ROOT="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )")"
export DIR_ROOT_SERVICE="$DIR_ROOT/service"
export DIR_SERVICE="$DIR_ROOT_SERVICE/$SERVICE"

export BIN="$DIR_ROOT/bin"


SERVICE_ENV="$DIR_SERVICE/setup.env"

export $(grep -v '^#' "$SERVICE_ENV" | xargs -d '\n')

sh "$DIR_SERVICE/setup.sh"
