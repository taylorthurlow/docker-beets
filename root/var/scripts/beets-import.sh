#!/usr/bin/env bash

set -e

echo "Invoked beets import script."

echo "Input base64 path: $1"
orig_path=$(echo "$1" | base64 -d)
echo "Decoded base64 path: $orig_path"

stripped=${orig_path#/data/music/}

before_delim="${orig_path%/ready-for-import*}"
after_delim="${orig_path#*ready-for-import/}"

chown -R abc:users "$before_delim"

mv "$orig_path" "/data/music/import/"
destination="/data/music/import/$after_delim"

beet -vv \
    -c "/config/config.yaml" \
    import \
    --quiet \
    --noincremental \
    --move \
    --flat \
    --noresume \
    "$destination"

chown -R abc:users "/data/music"
