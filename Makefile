mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

image := kroki-wireviz
tag := latest

output := dist/$(tag)

all: build save save-wire size test dive

build:
	docker build \
		-t $(image):$(tag) \
		--build-arg PYTHON_VERSION=$$(bin/get-tool-version python) \
		--build-arg POETRY_VERSION=$$(bin/get-tool-version poetry) \
		-f Dockerfile \
		.
buildv:
	docker build \
		-t $(image):$(tag) \
		--build-arg PYTHON_VERSION=$$(bin/get-tool-version python) \
		--build-arg POETRY_VERSION=$$(bin/get-tool-version poetry) \
		-f Dockerfile \
		--progress plain \
		.
tool-version:
	grep $(TOOL) .tool-versions | cut -d' ' -f2-
test:
	container-structure-test test --image $(image):$(tag) --config spec/*.yml
