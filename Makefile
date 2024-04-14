APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=allozavrr
# Extract the latest tag and sanitize it to be a valid Docker tag
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64
GO_CMD=go
LD_FLAGS=-X "https://github.com/allozavrr/new-project/tgbot.appVersion=${VERSION}"

.PHONY: format get lint test build clean linux arm macOS windows image push

format:
	${GO_CMD} fmt -s -w ./

get:
	${GO_CMD} get

lint:
	${GO_CMD} lint

test:
	${GO_CMD} test -v

build:
	CGD_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} ${GO_CMD} build -v -o new-project

linux:
	CGD_ENABLED=0 GOOS=linux GOARCH=amd64 ${GO_CMD} build -v -o new-project -ldflags "${LD_FLAGS}"

arm:
	CGD_ENABLED=0 GOOS=windows GOARCH=arm ${GO_CMD} build -v -o new-project -ldflags "${LD_FLAGS}"

macOS:
	CGD_ENABLED=0 GOOS=darwin GOARCH=amd64 ${GO_CMD} build -v -o new-project -ldflags "${LD_FLAGS}"

windows:
	CGD_ENABLED=0 GOOS=windows GOARCH=${TARGETARCH} ${GO_CMD} build -v -o new-project -ldflags "${LD_FLAGS}"

image: build
	docker build . --platform ${TARGETOS}/${TARGETARCH} -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	docker rmi ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}
