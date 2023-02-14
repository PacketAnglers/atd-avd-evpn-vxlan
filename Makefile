###########################################
# Run AVD with various tags               #
# #########################################

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build_dc1
build_dc1: ## Build AVD Configs for DC1
	ansible-playbook playbooks/build_dc1.yml -i sites/dc1/inventory.yml

.PHONY: build_dc2
build_dc2: ## Build AVD Configs for DC2
	ansible-playbook playbooks/build_dc2.yml -i sites/dc2/inventory.yml

.PHONY: deploy_dc1
deploy_dc1: ## Deploy DC1 AVD Configs Through CVP
	ansible-playbook playbooks/deploy_dc1.yml -i sites/dc1/inventory.yml

.PHONY: deploy_dc2
deploy_dc2: ## Deploy DC2 AVD Configs Through CVP
	ansible-playbook playbooks/deploy_dc2.yml -i sites/dc2/inventory.yml

.PHONY: cfg_dc1_dci
cfg_dc1_dci: ## Deploy DC1 DCI configs to non-avd devices
	ansible-playbook playbooks/cfg_dc1_dci.yml -i sites/dc1/inventory.yml

.PHONY: cfg_dc2_dci
cfg_dc2_dci: ## Deploy DC1 DCI configs to non-avd devices
	ansible-playbook playbooks/cfg_dc2_dci.yml -i sites/dc2/inventory.yml