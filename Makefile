.ONESHELL:
.SHELL := /usr/bin/env bash
.SHELLFLAGS := -ec
.PHONY: help update upgrade

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
	git diff main upstream/main; \
	git rebase upstream/main main; \
	git rebase main master

upgrade: ## Upgrade nvim to latest version
	@if [ "$$(uname)" = 'Darwin' ]; then \
		printf "This script is not supported on macOS. Please use Homebrew to upgrade Neovim.\n"; \
		exit 0; \
	fi; \
	curl -LO --output-dir /tmp https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage; \
	sudo mv /tmp/nvim-linux-x86_64.appimage /usr/local/bin/nvim.appimage; \
	sudo chmod +x /usr/local/bin/nvim.appimage
