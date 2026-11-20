include .env

.DEFAULT_GOAL := help

.PHONY: tag
tag: ## Update NGINX_TAG in .env file
	@sed -i -E "s/^NGINX_TAG\=(.*)/#NGINX_TAG=\1/" .env
	@NGINX_TAG_COMPUTED=$(BASE_NGINX_TAG)-dev-$(shell date +'%s') && \
		echo "NGINX_TAG=$$NGINX_TAG_COMPUTED" >> .env && \
		echo $$NGINX_TAG_COMPUTED

.PHONY: build
build: ## Build image
	DOCKER_BUILDKIT=1 docker image build -t ghcr.io/statuscue/nginx:$(NGINX_TAG) .

.PHONY: push
push: ## Push image to the registry
	docker image push ghcr.io/statuscue/nginx:$(NGINX_TAG)

.PHONY: help
help: ## Print this help
	@grep -E '(^[0-9a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
		| sed -e 's/^.*Makefile://g' \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' \
		| sed -e 's/\[32m##/[33m/'

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
