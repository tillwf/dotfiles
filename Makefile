.PHONY: help install check lint

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*##"}; {printf "  make %-10s %s\n", $$1, $$2}'

install: ## Run the full Ansible playbook
	@command -v ansible-playbook >/dev/null || { echo "ansible not found. Install with: sudo apt install ansible" >&2; exit 1; }
	ansible-playbook ansible/main.yml

check: ## Dry-run the Ansible playbook (no changes)
	@command -v ansible-playbook >/dev/null || { echo "ansible not found. Install with: sudo apt install ansible" >&2; exit 1; }
	ansible-playbook ansible/main.yml --check

lint: ## Run shellcheck on all shell scripts
	@command -v shellcheck >/dev/null || { echo "shellcheck not found. Install with: sudo apt install shellcheck" >&2; exit 1; }
	shellcheck scripts/*.sh
