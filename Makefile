# This makefile is intended to enable Terraform repositories.
# We've had some success with using it manually and with Jenkins.
#
# We mainly run with it from Linux. If you want to see if support
# other OSes send a PR :D

-include .config.mk

# Shared variables across targets
CONTENT_DIR = content
OUTPUT_DIR = public
THEMES_DIR = themes
DOCKER_WORKDIR = /workdir
CONTAINER_ENGINE ?= podman
CE_RUN = $(CONTAINER_ENGINE) run -i --rm -w $(DOCKER_WORKDIR) -v $(PWD):$(DOCKER_WORKDIR):Z
ZOLA_COMMAND := $(CE_RUN) j1mc/docker-zola:latest

export

.PHONY:help
.SILENT:help
help:   ## Show this help, includes list of all actions.
	@awk 'BEGIN {FS = ":.*?## "}; /^.+: .*?## / && !/awk/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' ${MAKEFILE_LIST}

.PHONY:clean
clean: ## Cleanup the local checkout
	-rm -f *~ $(OUTPUT_DIR)

.PHONY:.check-env-publish
.check-env-publish:
	@test $${TARGET_SYSTEM?WARN: Undefined TARGET_SYSTEM required to define scp target for publishing}
	@test $${TARGET_DIR?WARN: Undefined TARGET_DIR required to define scp target for publishing}

.PHONY:lint
lint: ## Run markdown lint on the whole decisions directory
	$(CE_RUN) tmknom/markdownlint --config=.markdownlint.json --ignore=$(THEMES_DIR) .

.PHONY:test
test: lint ## Standard entry point for running tests.

.PHONY:format
format: ## Run markdown lint on the whole decisions directory
	$(CE_RUN) tmknom/prettier --parser=markdown --write='**/*.md' $(CONTENT_DIR)

.PHONY:update-themes
update-themes:  ## Update all themes loaded as git submodules
	git submodule update --init --recursive

.PHONY:build
build: ## Run markdown lint on the whole decisions directory
	$(ZOLA_COMMAND) build

.PHONY:publish
publish: .check-env-publish build  ## Send the files to hosting provider
	scp -pr $(OUTPUT_DIR)/* $(TARGET_SYSTEM):$(TARGET_DIR)/
