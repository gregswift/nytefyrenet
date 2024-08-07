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
CONTAINER_WORKDIR = /workdir
CONTAINER_ENGINE ?= podman
CE_RUN = $(CONTAINER_ENGINE) run -i --rm -w $(CONTAINER_WORKDIR) -v $(PWD):$(CONTAINER_WORKDIR)
ZOLA_COMMAND := $(CE_RUN) ghcr.io/getzola/zola:v0.19.1

TARGET_PORT := $(if $(TARGET_PORT),$(TARGET_PORT),22)

export

.PHONY:help
.SILENT:help
help:   ## Show this help, includes list of all actions.
	@awk 'BEGIN {FS = ":.*?## "}; /^.+: .*?## / && !/awk/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' ${MAKEFILE_LIST}

.PHONY:debug-%
debug-%: ## Debug a variable by calling `make debug-VARIABLE`
	@echo $(*) = $($(*))

.PHONY:clean
clean: ## Cleanup the local checkout
	-rm -rf *~ $(OUTPUT_DIR)

.PHONY:.check-env-publish
.check-env-publish:
	@test $${TARGET_SYSTEM?WARN: Undefined TARGET_SYSTEM required to define scp target for publishing}
	@test $${TARGET_DIR?WARN: Undefined TARGET_DIR required to define scp target for publishing}

.PHONY:lint
lint: ## Run markdown lint on the whole directory, excluding themes
	$(CE_RUN) docker.io/tmknom/markdownlint --config=.markdownlint.json --ignore=$(THEMES_DIR) .

.PHONY:test
test: ## Standard entry point for running tests.
	@echo "No tests configured"

.PHONY:check
check: lint test ## Standard entry point for running tests.

.PHONY:format
format: ## Autoformat markdown in content directory
	$(CE_RUN) docker.io/tmknom/prettier --parser=markdown --write='**/*.md' $(CONTENT_DIR)

.PHONY:update-themes
update-themes:  ## Update all themes loaded as git submodules
	git submodule update --init --recursive

.PHONY:build
build: ## Build content for publishing
	$(ZOLA_COMMAND) build

.PHONY:serve
serve: ## Run a local instance of the site for debugging
	$(ZOLA_COMMAND) serve

.PHONY:publish
publish: .check-env-publish build  ## Send the files to hosting provider using scp
	rsync -e 'ssh -o StrictHostKeyChecking=accept-new -p $(TARGET_PORT)' -atvz $(OUTPUT_DIR)/* $(TARGET_SYSTEM):$(TARGET_DIR)/
