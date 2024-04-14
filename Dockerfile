FROM quay.io/projectquay/golang:1.20 as builder
WORKDIR /go/src/app
COPY . .
RUN make build_linux_amd64

FROM quay.io/projectquay/golang:1.20
RUN apt-get update && apt-get install -y golang-go

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/new-project .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./new-project", "start"]