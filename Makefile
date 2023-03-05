.PHONY: build

DOCKER_IMAGE_NAME = test-dotnet-app-public
DOCKER_REGISTRY = docker.io
DOCKER_REPO = nikoogle
DOCKER_TAG = latest
DOCKER_PLATFORMS = linux/arm64
DOCKER_TARGET = runtime

init-www:
	git submodule add https://github.com/yemiwebby/docker-dotnet-api.git www

build:
	docker buildx build \
		--platform $(DOCKER_PLATFORMS) \
		--build-arg DOCKER_REGISTRY=$(DOCKER_REGISTRY) \
		--build-arg DOCKER_REPO=$(DOCKER_REPO) \
		--secret id=newrelic_license_key,env=NR_LICENSE_KEY \
		-t $(DOCKER_REGISTRY)/$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_TAG) \
		--target serve \
		. --no-cache \
		--push

up:
	docker compose up
down: 
	docker compose down --remove-orphans

extract:
	docker extract 

combo: build down up

# Variables
TEST_RUNNER=k6 run
BASE_FOLDER=yy-IaC/tests
BASE_INTEGRATION_FOLDER=integration
BASE_LOAD_FOLDER=stress
ENDPOINT_TO_BE_TESTED=api/weather
LOAD_TEST_SCRIPT=load-test.js
SOAK_TEST_SCRIPT=soak-test.js
INTEGRATION_TEST_SCRIPT=integration-test.js

# Targets
load-test:
	$(TEST_RUNNER) $(BASE_FOLDER)/$(BASE_LOAD_FOLDER)/$(ENDPOINT_TO_BE_TESTED)/$(LOAD_TEST_SCRIPT)

soak-test:
	$(TEST_RUNNER) $(BASE_FOLDER)/$(BASE_LOAD_FOLDER)/$(ENDPOINT_TO_BE_TESTED)/$(SOAK_TEST_SCRIPT)

integration-test:
	$(TEST_RUNNER) $(BASE_FOLDER)/$(BASE_INTEGRATION_FOLDER)/$(ENDPOINT_TO_BE_TESTED)/$(INTEGRATION_TEST_SCRIPT)


#Kompose the docker-compose.yml file to Kubernetes

kompose: 
	-kompose convert -f docker-compose.yml -c
	-rm -rf yy-IaC/helm/*
	-mv docker-compose yy-IaC/helm && rm -rf docker-compose

#Deploy to k3d
deploy:
	helm install --create-namespace -n test-app yy-IaC/helm/docker-compose --generate-name
destroy:
	kubectl delete ns test-app