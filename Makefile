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
run:
	docker run -p8010:8010 --network host kroki-wireviz:latest
demo-svg:
	curl http://localhost:8010/svg -X POST --data-binary "@tests/input_example1.yaml"
demo-png:
	curl http://localhost:8010/png -X POST --data-binary "@tests/input_example1.yaml" --output -
tool-version:
	grep $(TOOL) .tool-versions | cut -d' ' -f2-
test-container:
	container-structure-test test --image $(image):$(tag) --config spec/*.yml
test:
	poetry run task test
dev-run:
	poetry run task dev
dev-install:
	poetry install
pylint:
	poetry run task lint
format:
	poetry run task format
