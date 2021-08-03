# This makefile is intended to enable Terraform repositories.
# We've had some success with using it manually and with Jenkins.
#
# We mainly run with it from Linux. If you want to see if support
# other OSes send a PR :D

.PHONY: clean setup lint test format build publish
.SILENT: help

# Shared variables across targets
CONTENT_DIR = content/
DOCKER_WORKDIR = /workdir
DOCKER_RUN = podman run -i --rm -w $(DOCKER_WORKDIR) -v $(PWD):$(DOCKER_WORKDIR):Z
ZOLA_COMMAND := $(DOCKER_RUN) j1mc/docker-zola:latest

help:   ## Show this help, includes list of all actions.
	@awk 'BEGIN {FS = ":.*?## "}; /^.+: .*?## / && !/awk/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' ${MAKEFILE_LIST}

clean: ## Cleanup the local checkout
	-rm -f *~

setup: ## Help make sure everything is available to use the repo

lint: setup ## Run markdown lint on the whole decisions directory
	$(DOCKER_RUN) tmknom/markdownlint --config=.markdownlint.json --ignore=themes .

test: lint ## Standard entry point for running tests.

format: setup ## Run markdown lint on the whole decisions directory
	$(DOCKER_RUN) tmknom/prettier --parser=markdown --write='**/*.md' $(CONTENT_DIR)

build: setup ## Run markdown lint on the whole decisions directory
	$(ZOLA_COMMAND) build

publish: build  ## Send the files to hosting provider
	scp -pr public/* u48059473@nytefyre.net:nytefyrenet4.0/
