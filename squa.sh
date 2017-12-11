#!/bin/bash

# set -e
# set -v

dockerd &

# Wait for dockerd to become available
while :; do
    echo "Waiting for dockerd"
    docker info
    if [ $? -eq 0 ]; then
        break
    fi
    sleep 1
done

# Print $1 and exit with code 1
function fail() {
    echo "Error: $1"
    exit 1
}

# Check if required vars are set
test -n "$PLUGIN_SOURCE_IMAGE" || fail "source_image must be set"
test -n "$PLUGIN_SOURCE_TAG" || fail "source_tag must be set"
test -n "$PLUGIN_TARGET_TAG" || PLUGIN_TARGET_TAG="$PLUGIN_SOURCE_TAG.squash"
test -n "$PLUGIN_TARGET_IMAGE" || PLUGIN_TARGET_IMAGE="$PLUGIN_SOURCE_IMAGE"

# Define source and target images based on inputs
SOURCE="$PLUGIN_SOURCE_IMAGE:$PLUGIN_SOURCE_TAG"
TARGET="$PLUGIN_TARGET_IMAGE:$PLUGIN_TARGET_TAG"

# Ensure we don't accidentally overwrite source with target
test "$SOURCE" == "$TARGET" && fail "cowardly refusing to squash $SOURCE to itself"

echo "Squashing $SOURCE to $TARGET"

# Login
docker login -p $DOCKER_PASSWORD -u $DOCKER_USERNAME $DOCKER_REGISTRY

test $? -eq 0 || fail "Docker login failed"

# Pull source
docker pull $SOURCE

test $? -eq 0 || fail "Failed to pull $SOURCE"


echo "--"

# Squash it
docker-squash -t $TARGET $SOURCE

test $? -eq 0 || fail "Failed to squash $SOURCE"

# Push result
echo "Pushing result to $TARGET. This may take some time..."
docker push $TARGET
