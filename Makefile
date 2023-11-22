SHELL      := bash
PYTHON     := python3
PIP 	   := pip3

.DEFAULT_GOAL := help

.PHONY: setup
setup: ## Install dependencies
	$(PIP) install hatch

.PHONY: run
run: ## Run the App (run `make setup` first)
	hatch run app

.PHONY: build
build: ## Build the App (run `make setup` first) and creates the distributable wheel file in /dist
	hatch build

.PHONY: test
test: ## Run tests
	hatch run test:pytest

.PHONY: clean
clean: ## Remove all files produced by `make`
	rm -rf dist

.PHONY: lint
lint: ## Lint python files
	hatch run lint:check

.PHONY: lint-fix
lint-fix: ## Fix linting errors
	hatch run lint:fix

.PHONY: version
version: ## Show current app version
	@grep -oE '^Version = "([^"]+)"' app.toml | cut -d '"' -f 2 | tr -d '[:space:]'

.PHONY: help
help: ## List all make tasks
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
