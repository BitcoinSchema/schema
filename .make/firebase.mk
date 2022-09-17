
firebase-param-app-id: ## Returns the location of the app_id parameter in SSM
	@$(MAKE) firebase-param-location app=$(app) stage=$(stage) param=app_id

firebase-param-sender-id: ## Returns the location of the sender_id parameter in SSM
	@$(MAKE) firebase-param-location app=$(app) stage=$(stage) param=sender_id

firebase-param-project: ## Returns the location of the project-id parameter in SSM
	@$(MAKE) firebase-param-location app=$(app) stage=$(stage) param=project

firebase-param-location: ## Creates a parameter location (for Firebase details in SSM)
	@test $(app)
	@test $(stage)
	@test $(param)
	@echo "/$(app)/$(stage)/firebase/$(param)"

firebase-save-project: ## Saves the firebase project information for use by CloudFormation
	@test $(APPLICATION_NAME)
	@test $(APPLICATION_STAGE_NAME)
	@test $(project)
	@test $(sender_id)
	@test $(app_id)
	@$(MAKE) save-param param_name="$(shell $(MAKE) firebase-param-project app=$(APPLICATION_NAME) stage=$(APPLICATION_STAGE_NAME))" param_value=$(project)
	@$(MAKE) save-param param_name="$(shell $(MAKE) firebase-param-sender-id app=$(APPLICATION_NAME) stage=$(APPLICATION_STAGE_NAME))" param_value=$(sender_id)
	@$(MAKE) save-param param_name="$(shell $(MAKE) firebase-param-app-id app=$(APPLICATION_NAME) stage=$(APPLICATION_STAGE_NAME))" param_value=$(app_id)

firebase-deploy-simple: ## Deploys to firebase with limited flags
	@test "$(project)"
	@test "$(token)"
	@firebase deploy --project $(project) --token $(token)

firebase-update: ## Update the firebase tools
	@npm i -g firebase-tools

firebase-set-env: ## Set an environment variable in a firebase project
	@test "$(key)"
	@test "$(value)"
	@firebase functions:config:set $(key)="$(value)"

firebase-get-env: ## Gets the current environment variables in the associated project
	@firebase functions:config:get
