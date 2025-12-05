# justfile - clean, maintainable, readable
# Usage:
#   just init_all        Initialize all submodules
#   just load_env        Load environment variables
#   just init_nemu       Initialize only nemu

default_branch := "ics2025"
base_url := "git@github.com:yuioto"

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
init_sub_core name envvar:
	if [ ! -d "{{name}}" ]; then \
		echo "Adding submodule {{name}}..."; \
		git submodule add -b {{default_branch}} {{base_url}}/{{name}}.git {{name}}; \
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
	@just init_sub_core nemu NEMU_HOME

init_am:
	@just init_sub_core abstract-machine AM_HOME

init_navy:
	@just init_sub_core navy-apps NAVY_HOME

init_nanos:
	@just init_sub_core nanos-lite NANOS_HOME

init_amk:
	@just init_sub_core am-kernels AMK_HOME

# --------------------------
# Initialize all submodules
# --------------------------
init_all:
	@just init_nemu
	@just init_am
	@just init_navy
	@just init_nanos
	@just init_amk
	@echo "All submodules initialized. Run 'just load_env' to load environment variables."

# --------------------------
# Load environment variables
# --------------------------
load_env PROJECT_DIR=".": 
	@if [ -d "{{PROJECT_DIR}}/.env" ]; then \
		for f in "{{PROJECT_DIR}}/.env"/*.sh; do \
			[ -f "$$f" ] && echo "Sourcing $$f" && . $$f; \
		done; \
	else \
		echo ".env folder not found in {{PROJECT_DIR}}. Run 'just init_all' first."; \
	fi
