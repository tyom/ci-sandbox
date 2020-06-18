$(shell touch .env.local)
include .env.local
APP_TAG ?= ci-sandbox-next-app
PORT ?= 3000
DOCKER_BUILDKIT ?= 0

help:		## Show this help
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

build:		## Build Docker image for the app
	DOCKER_BUILDKIT=${DOCKER_BUILDKIT} docker build --tag "$(APP_TAG)" .

run: 		## Run Docker container in the foreground
	docker run \
	--rm \
	--publish "$(PORT):$(PORT)" \
	--env-file .env.local \
	"$(APP_TAG)"

.PHONY: help build run run-detached
