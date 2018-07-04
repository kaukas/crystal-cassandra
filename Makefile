CPP_DRIVER_DIR := /tmp/cpp-driver-master
CPP_DRIVER_NAME := cassandra-cpp-driver
BUILD_DIR := $(CPP_DRIVER_DIR)/build
CPP_DRIVER_VERSION = $(shell head -n 1 $(CPP_DRIVER_DIR)/CHANGELOG.md)
CMAKE_PARAM = $(shell cd $(CPP_DRIVER_DIR) && brew diy --name=$(CPP_DRIVER_NAME) --version=$(CPP_DRIVER_VERSION))

/tmp/cpp-driver-master.zip:
	curl -JL -o /tmp/cpp-driver-master.zip \
		'https://github.com/datastax/cpp-driver/archive/master.zip'

$(CPP_DRIVER_DIR): /tmp/cpp-driver-master.zip
	cd /tmp && \
		unzip cpp-driver-master.zip

build-cppdriver: $(CPP_DRIVER_DIR)
	rm -rf $(BUILD_DIR)
	mkdir $(BUILD_DIR)
	cd $(BUILD_DIR) && \
		cmake $(CMAKE_PARAM) .. && \
		make all install
	brew link $(CPP_DRIVER_NAME)
.PHONY: build-cppdriver

HERE := $(shell pwd)
LIBCASS_TMPL := $(HERE)/src/cassandra/libcass.cr.tmpl
LIBCASS_SRC := $(HERE)/src/cassandra/libcass.cr

gen-binding:
	cd lib/crystal_lib && \
		$(CRYSTAL24) src/main.cr -- $(LIBCASS_TMPL) | \
		grep -v -E 'type ([A-Za-z]+) = \1' | \
		sed 's/__DIR__/#{__DIR__}/' \
		> $(LIBCASS_SRC)
.PHONY: gen-binding
