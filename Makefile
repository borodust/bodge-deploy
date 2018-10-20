# ENVIRONMENT
WORK_DIR = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR = $(WORK_DIR)/build/

SHELL_SCRIPTS = $(WORK_DIR)/install.sh $(WORK_DIR)/ccl.sh $(WORK_DIR)/sbcl.sh

deploy: scripts $(SHELL_SCRIPTS)
	scp $(BUILD_DIR)/scripts.tar.gz $(SHELL_SCRIPTS) root.develserv:/var/www/bodge/files/

scripts: prepare
	tar -czf $(BUILD_DIR)/scripts.tar.gz scripts/

prepare:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
