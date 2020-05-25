SHELL = /bin/sh

GIT ?= git
RM ?= rm -f

PROJECT ?= stackuno-node

REPO_URL ?=
REPO_DIR ?= src
REPO_BRANCH_NAME ?= master

DOCKERFILE ?= ../../Dockerfile
DOCKER_BASE_IMAGE ?= node:13.13.0-stretch-slim

TEST_ARGS = \
	DOCKERFILE=${DOCKERFILE} \
	DOCKER_BASE_IMAGE=${DOCKER_BASE_IMAGE} \
	PROJECT=${PROJECT} \
	REPO_DIR=${REPO_DIR}

all: src test.sh
	${TEST_ARGS} ./test.sh

${REPO_DIR}:
	${GIT} clone -b ${REPO_BRANCH_NAME} --depth 1 ${REPO_URL} ${REPO_DIR}

clean:
	${RM} -r ${REPO_DIR}

.PHONY:
	all clean
