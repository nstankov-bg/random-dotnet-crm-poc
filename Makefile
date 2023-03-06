# Define variables
DOCKER_IMAGE_NAME = test-dotnet-app-public
DOCKER_REGISTRY = docker.io
DOCKER_REPO = nikoogle
DOCKER_TAG = latest
DOCKER_PLATFORMS = linux/arm64
DOCKER_TARGET = runtime

BASE_FOLDER = yy-IaC/tests
BASE_INTEGRATION_FOLDER = integration
BASE_LOAD_FOLDER = stress
ENDPOINT_TO_BE_TESTED = api/weather
LOAD_TEST_SCRIPT = load-test.js
SOAK_TEST_SCRIPT = soak-test.js
INTEGRATION_TEST_SCRIPT = integration-test.js

# Define phony targets
.PHONY: all build combo down extract git-all hosts-entry integration-test kompose load-test portfwd soak-test up

# Define targets
all: combo

utility-www:
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

local-up:
	docker compose up

local-down:
	docker compose down --remove-orphans

local-combo: down build up

test-load:
	$(TEST_RUNNER) $(BASE_FOLDER)/$(BASE_LOAD_FOLDER)/$(ENDPOINT_TO_BE_TESTED)/$(LOAD_TEST_SCRIPT)

test-soak:
	$(TEST_RUNNER) $(BASE_FOLDER)/$(BASE_LOAD_FOLDER)/$(ENDPOINT_TO_BE_TESTED)/$(SOAK_TEST_SCRIPT)

test-integration:
	$(TEST_RUNNER) $(BASE_FOLDER)/$(BASE_INTEGRATION_FOLDER)/$(ENDPOINT_TO_BE_TESTED)/$(INTEGRATION_TEST_SCRIPT)

utility-kompose:
	-kompose convert -f docker-compose.yml -c && rm -rf yy-IaC/helm/* && mv docker-compose yy-IaC/helm

utility-port:
	kubectl expose service app --type=NodePort --name=app --port=80 --target-port=80

utility-hosts:
	sudo sh -c "echo '127.0.0.1 testdotnet.nstankov.com' >> /etc/hosts"

utility-macOS-install-pre-reqs:
	brew tap hashicorp/tap
	brew install kompose
	brew install helm
	brew install k6
	brew install hashicorp/tap/terraform
	brew install hashicorp/tap/packer
	brew install hashicorp/tap/waypoint
	brew install buildkit
	brew install pre-commit
	brew install terraform-docs

git-fast:
	git add . && git commit -m "update" && git push

# Grouped targets
combo: local-combo
portfwd: utility-port
hosts-entry: utility-hosts
kompose: utility-kompose

# Aliases for some targets
up: local-up
down: local-down
extract: build
