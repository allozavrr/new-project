APP=${shell basename $(shell git remote get-url origin)}
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=myregistry.com

# Список підтримуваних архітектур
ARCHITECTURES = linux arm darwin windows

.PHONY: format get lint test build clean $(ARCHITECTURES) docker-build docker-push image

format:
	go fmt ./...

get:
	go get ./...

lint:
	golint ./...

test:
	go test -v ./...

build:
	CGD_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o main ./...

# Збірка для кожної архітектури
$(ARCHITECTURES):
	@$(MAKE) TARGETOS=$@ build

# Очищення
clean:
	rm -rf main

# Docker build та push для кожної архітектури
docker-build:
	@$(MAKE) $(foreach arch,$(ARCHITECTURES),docker-build-$(arch))

docker-push:
	@$(MAKE) $(foreach arch,$(ARCHITECTURES),docker-push-$(arch))

docker-build-%:
	docker build . --platform $*/amd64 -t ${REGISTRY}/${APP}:${VERSION}-$*

docker-push-%:
	docker push ${REGISTRY}/${APP}:${VERSION}-$*

# Створення Docker-образу
image: build
	docker build . -t ${REGISTRY}/${APP}:${VERSION}

# Збирання, тестування, очищення та Docker build та push для всіх архітектур
all: build test clean docker-build docker-push image
