APP=${shell basename $(shell git remote get-url origin)}
REGISTRY=doctortosya
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64
GO_CMD=go
LD_FLAGS=-X=https://github.com/allozavrr/new-project/main.appVersion=${VERSION}

.PHONY: format get lint test build clean Linux arm macOS Windows image push

format:
    ${GO_CMD} fmt -s -w ./

get:
    ${GO_CMD} get

lint:
    ${GO_CMD} lint

test:
    ${GO_CMD} test -v

build:
    CGD_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} ${GO_CMD} build -v -o main

Linux:
    CGD_ENABLED=0 GOOS=linux GOARCH=amd64 ${GO_CMD} build -v -o main -ldflags "${LD_FLAGS}"

arm:
    CGD_ENABLED=0 GOOS=windows GOARCH=arm ${GO_CMD} build -v -o main -ldflags "${LD_FLAGS}"

macOS:
    CGD_ENABLED=0 GOOS=darwin GOARCH=amd64 ${GO_CMD} build -v -o main -ldflags "${LD_FLAGS}"

Windows:
    CGD_ENABLED=0 GOOS=windows GOARCH=${TARGETARCH} ${GO_CMD} build -v -o main -ldflags "${LD_FLAGS}"

image:
    docker build . --platform ${TARGETOS}/${TARGETARCH} -t ${REGISTRY}/${APP}:${VERSION}

push:
    docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
    rm -rf main
