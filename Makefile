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

# Function to build docker image
define docker_build
	docker build \
		$(1) \
		--build-arg extension=$(2) \
		--build-arg version=$(VERSION) \
		-t $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR)$(3) \
		-t $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH)$(3) \
		.
endef
memprof
# DOCKER TASKS
build: ## Build the image
	$(call docker_build,,,)
	$(call docker_build,,pcov,-pcov)
	$(call docker_build,,xdebug,-xdebug)
	$(call docker_build,,memprof,-memprof)

build-nc: ## Build the image without caching
	$(call docker_build,--no-cache,,)
	$(call docker_build,--no-cache,pcov,-pcov)
	$(call docker_build,--no-cache,xdebug,-xdebug)
	$(call docker_build,--no-cache,memprof,-memprof)

push: ## Push the images
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR)
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH)
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR)-pcov
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH)-pcov
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR)-xdebug
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH)-xdebug
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_MINOR)-memprof
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION_PATCH)-memprof

version: ## Output the current version
	@echo $(VERSION)
