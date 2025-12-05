# justfile - clean, maintainable, readable
# Usage:
#   just init_all        Initialize all submodules
#   just env             Print environment variables (usage: source <(just env))
#   just init_nemu       Initialize only nemu

# default_branch := "ics2025"
base_url := "git@github.com:NJU-ProjectN"

# Default recipe: show all available recipes
default:
	@echo "Available recipes:"
	@just --summary

# --------------------------
# Core function to init a submodule
# --------------------------
# Named parameters:
#   name   - submodule directory
#   envvar - environment variable name
#   branch - git branch to use
init_sub_core name envvar branch:
	if [ ! -d "{{name}}" ]; then \
		echo "Adding submodule {{name}} (branch {{branch}})..."; \
		git submodule add --force -b {{branch}} {{base_url}}/{{name}}.git {{name}}; \
		git submodule update --init --recursive {{name}}; \
	else \
		echo "{{name}} already exists, skipping..."; \
	fi
	mkdir -p .env
	echo "export {{envvar}}=$(realpath {{name}})" > .env/{{name}}.sh
	echo "Environment variable {{envvar}} written to .env/{{name}}.sh"

# --------------------------
# Submodule wrappers
# --------------------------
init_nemu:
	@just init_sub_core nemu NEMU_HOME ics2024

init_am:
	@just init_sub_core abstract-machine AM_HOME ics2024

init_navy:
	@just init_sub_core navy-apps NAVY_HOME ics2024

init_nanos:
	@just init_sub_core nanos-lite NANOS_HOME ics2021

init_amk:
	@just init_sub_core am-kernels AMK_HOME ics2021

# --------------------------
# Initialize all submodules
# --------------------------
init_all:
	@just init_nemu
	@just init_am
	@just init_navy
	@just init_nanos
	@just init_amk
	@echo "All submodules initialized. Run 'source <(just env)' to load environment variables."

# --------------------------
# Output environment variables
# --------------------------
env PROJECT_DIR=".":
	@if [ -d "{{PROJECT_DIR}}/.env" ]; then \
		cat "{{PROJECT_DIR}}/.env"/*.sh 2>/dev/null || echo "# No environment variables found."; \
	else \
		echo "# .env folder not found in {{PROJECT_DIR}}. Run 'just init_all' first."; \
	fi
