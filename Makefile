# Common makefile commands & variables between projects
include .make/common.mk

# Common aws commands & variables between projects
include .make/aws.mk

# Common firebase commands & variables between projects
include .make/firebase.mk

## Stage or environment for the application
ifndef APPLICATION_STAGE_NAME
	override APPLICATION_STAGE_NAME="production"
endif

## Tags for the application in AWS
ifndef AWS_TAGS
	override AWS_TAGS="Stage=$(APPLICATION_STAGE_NAME) Product=bitcoinschema"
endif

## Default S3 bucket (already exists) to store distribution files
ifndef APPLICATION_BUCKET
	override APPLICATION_BUCKET="cloudformation-distribution-raw-files"
endif

## Application name (the name of the application, lowercase, no spaces)
ifndef APPLICATION_NAME
	override APPLICATION_NAME="bitcoinschema"
endif

## Cloud formation stack name (combines the app name with the stage for unique stacks)
ifndef APPLICATION_STACK_NAME
	override APPLICATION_STACK_NAME=$(subst _,-,"$(APPLICATION_NAME)-$(APPLICATION_STAGE_NAME)")
endif

## Application feature name (if it's a feature branch of a stage) (feature="some-feature")
ifdef APPLICATION_FEATURE_NAME
	override APPLICATION_STACK_NAME=$(subst _,-,"$(APPLICATION_NAME)-$(APPLICATION_STAGE_NAME)-$(APPLICATION_FEATURE_NAME)")
endif

## S3 prefix to store the distribution files
ifndef APPLICATION_BUCKET_PREFIX
	override APPLICATION_BUCKET_PREFIX=$(APPLICATION_STACK_NAME)
endif

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

deploy: ## Build, prepare and deploy
	@$(MAKE) package
	@sam deploy \
        --template-file $(TEMPLATE_PACKAGED) \
        --stack-name $(APPLICATION_STACK_NAME)  \
        --region $(AWS_REGION) \
        --parameter-overrides ApplicationName=$(APPLICATION_NAME) \
        ApplicationStackName=$(APPLICATION_STACK_NAME) \
        ApplicationStageName=$(APPLICATION_STAGE_NAME) \
        ApplicationBucket=$(APPLICATION_BUCKET) \
        RepoOwner=$(REPO_OWNER) \
        RepoName=$(REPO_NAME) \
        RepoBranch=$(REPO_BRANCH) \
        FirebaseProject="$(shell $(MAKE) firebase-param-project \
        		app=$(APPLICATION_NAME) \
        		stage=$(APPLICATION_STAGE_NAME))" \
        FirebaseAppId="$(shell $(MAKE) firebase-param-app-id \
				app=$(APPLICATION_NAME) \
				stage=$(APPLICATION_STAGE_NAME))" \
        FirebaseSenderId="$(shell $(MAKE) firebase-param-sender-id \
				app=$(APPLICATION_NAME) \
				stage=$(APPLICATION_STAGE_NAME))" \
        EncryptionKeyId="$(shell $(MAKE) env-key-location \
				app=$(APPLICATION_NAME) \
				stage=$(APPLICATION_STAGE_NAME))" \
        --capabilities $(IAM_CAPABILITIES) \
        --tags $(AWS_TAGS) \
        --no-fail-on-empty-changeset \
        --no-confirm-changeset

install: ## Installs the dependencies for the package
	@npm install

lint: ## Runs the standard-js lint tool
	@npm run lint

outdated: ## Checks for outdated packages via npm
	@npm outdated

save-secrets: ## Helper for saving sensitive credentials to Secrets Manager
	@# Example: make save-secrets github_token=12345... firebase_token=12345... firebase_api_key=12345... kms_key_id=b329... stage=<stage>
	@test "$(firebase_token)"
	@test $(firebase_api_key)
	@test $(github_token)
	@test $(kms_key_id)

	@$(eval firebase_api_key_encrypted := $(shell $(MAKE) encrypt kms_key_id=$(kms_key_id) encrypt_value="$(firebase_api_key)"))
	@$(eval firebase_token_encrypted := $(shell $(MAKE) encrypt kms_key_id=$(kms_key_id) encrypt_value="$(firebase_token)"))
	@$(eval secret_value := $(shell echo '{' \
		'\"github_personal_token\":\"$(github_token)\"' \
		',\"firebase_token_encrypted\":\"$(firebase_token_encrypted)\"' \
		',\"firebase_api_key_encrypted\":\"$(firebase_api_key_encrypted)\"' \
		'}'))

	@$(eval existing_secret := $(shell aws secretsmanager describe-secret --secret-id "$(APPLICATION_STAGE_NAME)/$(APPLICATION_NAME)" --output text))
	@if [ '$(existing_secret)' = "" ]; then\
		echo "Creating a new secret..."; \
		$(MAKE) create-secret \
			name="$(APPLICATION_STAGE_NAME)/$(APPLICATION_NAME)" \
			description="Sensitive credentials for $(APPLICATION_NAME):$(APPLICATION_STAGE_NAME)" \
			secret_value='$(secret_value)' \
			kms_key_id=$(kms_key_id);  \
	else\
		echo "Updating an existing secret..."; \
		$(MAKE) update-secret \
            name="$(APPLICATION_STAGE_NAME)/$(APPLICATION_NAME)" \
        	secret_value='$(secret_value)'; \
	fi

start: ## Start the documentation site
	@npm run start

test: ## Runs all tests
	@npm run test
