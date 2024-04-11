FROM golang:1.22.1 as builder

WORKDIR /dir
COPY . .
RUN make image

FROM scratch
WORKDIR /
COPY --from=builder /dir .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./main"]