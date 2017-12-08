#!/bin/bash

set -e
# set -v

function fail() {
    echo "Error: $1"
    exit 1
}

test -n "$PLUGIN_SOURCE_IMAGE" || fail "source_image must be set"
test -n "$PLUGIN_SOURCE_TAG" || fail "source_tag must be set"
test -n "$PLUGIN_TARGET_TAG" || PLUGIN_TARGET_TAG="$PLUGIN_SOURCE_TAG.squash"
test -n "$PLUGIN_TARGET_IMAGE" || PLUGIN_TARGET_IMAGE="$PLUGIN_SOURCE_IMAGE"

SOURCE="$PLUGIN_SOURCE_IMAGE:$PLUGIN_SOURCE_TAG"
TARGET="$PLUGIN_TARGET_IMAGE:$PLUGIN_TARGET_TAG"

test "$SOURCE" == "$TARGET" && fail "cowardly refusing to squash $SOURCE to itself"

echo "Squashing $SOURCE to $TARGET"

docker login -p $DOCKER_PASSWORD -u $DOCKER_USERNAME $DOCKER_REGISTRY

docker pull $SOURCE

# echo "source image layers"
# docker history $PLUGIN_SOURCE

echo "--"
docker-squash -t $TARGET $SOURCE

# echo "target image layers"
# docker history $PLUGIN_TARGET

echo "pushing result to $TARGET"
docker push $TARGET
