#! /usr/bin/env sh
set -eux

docker build \
  --build-arg=BASE_IMAGE=${DOCKER_BASE_IMAGE} \
  --build-arg=PORTS=8000 \
  --file ${DOCKERFILE} \
  --no-cache \
  --tag=${PROJECT}:realworld-node-express \
  --target=production \
  ${REPO_DIR}
