HERE := $(shell pwd)

DOC_DIR := ../crystal-cassandra-docs/latest

docs:
	rm -r $(DOC_DIR)
	mkdir -p $(DOC_DIR)
	crystal docs --output=$(DOC_DIR)
PHONY: docs

CPP_DRIVER_VERSION = $(shell grep libcassandra shard.yml | cut -d ':' -f 2 | xargs)
CPP_DRIVER_DIR := /tmp/cpp-driver-$(CPP_DRIVER_VERSION)
CPP_DRIVER_NAME := cassandra-cpp-driver
BUILD_DIR := $(CPP_DRIVER_DIR)/build
CMAKE_PARAM = $(shell cd $(CPP_DRIVER_DIR) && brew diy --name=$(CPP_DRIVER_NAME) --version=$(CPP_DRIVER_VERSION))

/tmp/cpp-driver-$(CPP_DRIVER_VERSION).tar.gz:
	curl -JL -o /tmp/cpp-driver-$(CPP_DRIVER_VERSION).tar.gz \
		'https://github.com/datastax/cpp-driver/archive/$(CPP_DRIVER_VERSION).tar.gz'

$(CPP_DRIVER_DIR): /tmp/cpp-driver-$(CPP_DRIVER_VERSION).tar.gz
	cd /tmp && \
		tar xzf cpp-driver-$(CPP_DRIVER_VERSION).tar.gz

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
		grep -v -E 'type ([A-Za-z0-9]+) = \1' | \
		grep -v -E 'alias ([A-Za-z0-9]+) = \1' \
		> $(LIBCASS_SRC)
.PHONY: gen-binding


CASS_DOCKER_NAME := crystal-cassandra-dbapi-test

start-cassandra:
	docker build --tag custom-cassandra spec/docker
	docker run \
		--name $(CASS_DOCKER_NAME) \
		--publish 9042:9042 \
		--rm \
		--detach \
		custom-cassandra
.PHONY: start-cassandra

stop-cassandra:
	docker stop $(CASS_DOCKER_NAME)
.PHONY: stop-cassandra
