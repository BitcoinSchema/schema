# Common makefile commands & variables between projects
include .make/common.mk

## Set the distribution folder
ifndef DISTRIBUTIONS_DIR
	override DISTRIBUTIONS_DIR=./release
endif

## Not defined? Use default repo name which is the application
ifeq ($(REPO_NAME),)
	REPO_NAME="schema"
endif

## Not defined? Use default repo owner
ifeq ($(REPO_OWNER),)
	REPO_OWNER="BitcoinSchema"
endif

## Default branch
ifndef REPO_BRANCH
	override REPO_BRANCH="master"
endif

.PHONY: clean release test

audit: ## Checks for vulnerabilities in dependencies
	@npm audit

build: ## Builds the package for web distribution
	@npm run build

clean: ## Remove previous builds and any test cache data
	@npm run clean
	@if [ -d $(DISTRIBUTIONS_DIR) ]; then rm -r $(DISTRIBUTIONS_DIR); fi
	@if [ -d build ]; then rm -r build; fi
	@if [ -d build_cache ]; then rm -r build_cache; fi
	@if [ -d node_modules ]; then rm -r node_modules; fi

install: ## Installs the dependencies for the package
	@npm install

lint: ## Runs the standard-js lint tool
	@npm run lint

outdated: ## Checks for outdated packages via npm
	@npm outdated

release:: ## Deploy to npm
	@npm run deploy

start: ## Start the documentation site
	@npm run start

test: ## Runs all tests
	@npm run test
