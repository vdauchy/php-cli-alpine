#!/bin/bash

BASE_VERSION="${BASE_VERSION}"
VERSION_OFFSET="${VERSION_OFFSET:-2}"

# Version selector.
JQ_CMD='map(.ref | split("-")[1] | select((. != null) and (test($version)))) | sort_by(. | split(".") | map(tonumber)) | .[-'$VERSION_OFFSET']'

curl \
  --user $GITHUB_TOKEN:x-oauth-basic \
  --silent "https://api.github.com/repos/php/php-src/git/refs/tags" | \
  docker run --rm -i imega/jq -r --arg version "^${BASE_VERSION}[0-9.]*$" "$JQ_CMD"