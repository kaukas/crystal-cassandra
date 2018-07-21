HERE := $(shell pwd)

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
	brew unlink $(CPP_DRIVER_NAME)
	brew link $(CPP_DRIVER_NAME)
.PHONY: build-cppdriver


LIBCASS_TMPL := $(HERE)/src/cassandra/libcass.cr.tmpl
LIBCASS_SRC := $(HERE)/src/cassandra/libcass.cr

gen-binding:
	LLVM_CONFIG=/usr/local/opt/llvm/bin/llvm-config \
		crystal lib/crystal_lib/src/main.cr -- $(LIBCASS_TMPL) | \
		grep -v -E 'type ([A-Za-z]+) = \1' \
		> $(LIBCASS_SRC)
.PHONY: gen-binding


CASS_DOCKER_NAME := crystal-cassandra-dbapi-test
CASS_DOCKER_VERSION := 3

start-cassandra:
	docker run \
		--name $(CASS_DOCKER_NAME) \
		--publish 9042:9042 \
		--rm \
		--detach \
		cassandra:$(CASS_DOCKER_VERSION)

stop-cassandra:
	docker stop $(CASS_DOCKER_NAME)
.PHONY: cassandra
