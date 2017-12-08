TAG ?= latest
IMAGE ?= $(shell basename `pwd`)

build:
	docker build -t $(IMAGE):$(TAG) .
