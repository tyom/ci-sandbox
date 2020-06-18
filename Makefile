#$(shell touch .env.local)
#include .env.local
APP_TAG ?= ci-sandbox-next-app
TEST_TAG ?= ci-sandbox-next-test
PORT ?= 3000
DOCKER_BUILDKIT ?= 0

network = container:$(APP_TAG)
docker_process = $(strip $(shell docker ps | grep $(APP_TAG) | wc -l))

help:			## Show this help
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

build-app:		## Build Docker image for the app
	DOCKER_BUILDKIT=${DOCKER_BUILDKIT} docker build --tag "$(APP_TAG)" .

build-test:		## Build Docker image for testing
	DOCKER_BUILDKIT=${DOCKER_BUILDKIT} docker build --tag "$(TEST_TAG)"  -f Dockerfile.test .

build:
	$(MAKE) build-app
	$(MAKE) build-test

run: 			## Run app Docker container in the foreground
	docker run \
	--rm \
	--name "$(APP_TAG)" \
	--publish "$(PORT):$(PORT)" \
	--env-file .env.local \
	"$(APP_TAG)"

run-detached:		## Run app Docker container in the background
run-detached: remove-detached
	@echo "Starting $(APP_TAG) container detached"
	@docker run \
	--detach \
	--name "$(APP_TAG)" \
	--publish "$(PORT):$(PORT)" \
	--env PORT=$(PORT) \
	"$(APP_TAG)" 2>&1 > /dev/null

remove-detached:	## Remove background Docker container
ifeq ($(docker_process), 1)
	@echo "Detached $(APP_TAG) container removed"
	@docker rm -f $(APP_TAG) > /dev/null 2>&1 || true
else
	@#Container not running
endif

test: run-detached	## Run tests Docker container in the foreground
	docker run \
	-it \
	--rm \
	--network container:$(APP_TAG) \
	"$(TEST_TAG)"

	@$(MAKE) remove-detached

compose:		## Run Docker services using Docker Compose
	@docker-compose up --abort-on-container-exit

.PHONY: help build build-app build-test run run-detached test compose
