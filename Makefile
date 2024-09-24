.ONESHELL:
.SHELL := /usr/bin/env bash
.SHELLFLAGS := -ec
.PHONY: help update

# check for uncommitted changes before proceeding
ifneq ($(filter help,$(MAKECMDGOALS)),)
  # Skip git status check for help target
else ifneq ($(shell git status --porcelain),)
  $(error You have uncommitted changes, please commit or stash them before running this command)
endif

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

update: ## Update configuration with latest upstream changes
	git br bak_$(shell date +%F) origin/master; \
	git pull --all; \
	git diff upstream/main main; \
	git rebase upstream/main main; \
	git rebase main master

