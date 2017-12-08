TAG ?= latest
IMAGE ?= $(shell basename `pwd`)

build:
	docker build -t $(IMAGE):$(TAG) .

test: build
	echo "$(DOCKER_USERNAME)"
	@test -n "$(DOCKER_USERNAME)" || (echo "DOCKER_USERNAME must be set"; exit 1)
	@test -n "$(DOCKER_PASSWORD)" || (echo "DOCKER_PASSWORD must be set"; exit 1)
	@test -n "$(DOCKER_REGISTRY)" || (echo "DOCKER_REGISTRY must be set"; exit 1)
	@test -n "$(PLUGIN_SOURCE_IMAGE)" || (echo "PLUGIN_SOURCE_IMAGE must be set"; exit 1)
	@test -n "$(PLUGIN_SOURCE_TAG)" || (echo "PLUGIN_SOURCE_TAG must be set"; exit 1)
	docker run \
		-e DOCKER_USERNAME=$(DOCKER_USERNAME) \
		-e DOCKER_PASSWORD=$(DOCKER_PASSWORD) \
		-e DOCKER_REGISTRY=$(DOCKER_REGISTRY) \
		-e PLUGIN_SOURCE_IMAGE=$(PLUGIN_SOURCE_IMAGE) \
		-e PLUGIN_SOURCE_TAG=$(PLUGIN_SOURCE_TAG) \
		-e PLUGIN_TARGET_IMAGE=$(PLUGIN_TARGET_IMAGE) \
		-e PLUGIN_TARGET_TAG=$(PLUGIN_TARGET_TAG) \
		-v /var/run/docker.sock:/var/run/docker.sock \
		$(IMAGE):$(TAG)
