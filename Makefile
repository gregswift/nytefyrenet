# This makefile is intended to enable Terraform repositories.
# We've had some success with using it manually and with Jenkins.
#
# We mainly run with it from Linux. If you want to see if support
# other OSes send a PR :D

.PHONY: clean setup lint test format build publish
.SILENT: help

# Shared variables across targets
DOCKER_RUN = docker run -i --rm -v

help:   ## Show this help, includes list of all actions.
	@awk 'BEGIN {FS = ":.*?## "}; /^.+: .*?## / && !/awk/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' ${MAKEFILE_LIST}

clean: ## Cleanup the local checkout
	-rm -f *~

setup: ## Help make sure everything is available to use the repo

lint: setup ## Run markdown lint on the whole decisions directory
	${DOCKER_RUN} $(PWD):/work:Z tmknom/markdownlint --config=.markdownlint.json --ignore=themes .

test: lint ## Standard entry point for running tests.

format: setup ## Run markdown lint on the whole decisions directory
	${DOCKER_RUN} $(PWD)/content:/work:Z tmknom/prettier --parser=markdown --write='**/*.md' .

build: setup ## Run markdown lint on the whole decisions directory
	#${DOCKER_RUN} $(PWD):/workdir:Z balthek/zola build
	zola build

publish: build  ## Send the files to hosting provider
	scp -pr public/* u48059473@nytefyre.net:nytefyrenet4.0/
