# ENVIRONMENT
WORK_DIR = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR = $WORK_DIR/build/

script-deploy: prepare
	tar -czf $(BUILD_DIR)/scripts.tar.gz scripts/
	scp $(BUILD_DIR)/scripts.tar.gz root.develserv:/var/www/bodge/files/scripts.tar.gz

prepare:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
