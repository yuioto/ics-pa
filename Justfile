# Justfile - clean, maintainable, readable
# Usage:
#   just init_all        Initialize all submodules
#   just load_env        Load environment variables
#   just init_nemu       Initialize only nemu

default_branch := "ics2025"
base_url := "git@github.com:yuioto"

# --------------------------
# Core function to init a submodule
# --------------------------
# Named parameters:
#   name   - submodule directory
#   envvar - environment variable name
define init_sub_core
	@submodule_name="{{name}}"
	@env_var="{{envvar}}"
	@if [ ! -d "$$submodule_name" ]; then \
		echo "Adding submodule $$submodule_name..."; \
		git submodule add -b {{default_branch}} $(base_url)/$$submodule_name.git $$submodule_name; \
		git submodule update --init --recursive $$submodule_name; \
	else \
		echo "$$submodule_name already exists, skipping..."; \
	fi
	@mkdir -p .env
	@echo "export $$env_var=$$(realpath $$submodule_name)" > .env/$$submodule_name.sh
	@echo "Environment variable $$env_var written to .env/$$submodule_name.sh"
end

# --------------------------
# Submodule wrappers
# --------------------------
init_nemu:
	$(call init_sub_core,name=nemu,envvar=NEMU_HOME)

init_am:
	$(call init_sub_core,name=abstract-machine,envvar=AM_HOME)

init_navy:
	$(call init_sub_core,name=navy-apps,envvar=NAVY_HOME)

init_nanos:
	$(call init_sub_core,name=nanos-lite,envvar=NANOS_HOME)

init_amk:
	$(call init_sub_core,name=am-kernels,envvar=AMK_HOME)

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
