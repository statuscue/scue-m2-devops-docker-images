include .php

.DEFAULT_GOAL := help

.PHONY: tag
tag: ## Update PHP_TAG in .php file
	@sed -i -E "s/^PHP_TAG\=(.*)/#PHP_TAG=\1/" .php
	@PHP_TAG_COMPUTED=$(BASE_PHP_TAG)-staging-$(shell date +'%s') && \
		echo "PHP_TAG=$$PHP_TAG_COMPUTED" >> .php && \
		echo $$PHP_TAG_COMPUTED

.PHONY: build
build: ## Build image with Docker Buildkit
	DOCKER_BUILDKIT=1 docker image build -t ghcr.io/statuscue/php:$(PHP_TAG) \
		--build-arg UID=1002 \
		--build-arg GID=1002 \
		./

.PHONY: push
push: ## Push image to registry
	docker push ghcr.io/statuscue/php:$(PHP_TAG)

.PHONY: help
help: ## Print this help
	@grep -E '(^[0-9a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
		| sed -e 's/^.*Makefile://g' \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' \
		| sed -e 's/\[32m##/[33m/'

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
