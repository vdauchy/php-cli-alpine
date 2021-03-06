# import config.
cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))



# grep the version from the mix file
VERSION=$(shell ./version.sh)

VERSION_MAJOR := $(shell echo $(VERSION) | cut -f1 -d.)
VERSION_MINOR := $(shell echo $(VERSION_MAJOR)).$(shell echo $(VERSION) | cut -f2 -d.)
VERSION_PATCH := $(shell echo $(VERSION_MINOR)).$(shell echo $(VERSION) | cut -f3 -d.)

# HELP
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
build: ## Build the image
	docker build \
		--build-arg extension= \
		--build-arg version=$(VERSION) \
		-t $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR) \
		-t $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH) \
		.
	docker build \
		--build-arg extension=pcov \
		--build-arg version=$(VERSION) \
		-t $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR)-pcov \
		-t $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH)-pcov \
		.

build-nc: ## Build the image without caching
	docker build \
		--no-cache \
		--build-arg extension= \
		--build-arg version=$(VERSION) \
		-t $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR) \
		-t $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH) \
		.
		docker build \
    		--no-cache \
    		--build-arg extension=pcov \
    		--build-arg version=$(VERSION) \
    		-t $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR)-pcov \
    		-t $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH)-pcov \
    		.

push: ## Push the images
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR)
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH)
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR)-pcov
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH)-pcov

version: ## Output the current version
	@echo $(VERSION)
