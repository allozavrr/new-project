FROM golang:1.20 as builder
RUN apt-get update && apt-get install -y make

WORKDIR /app
COPY . .
RUN make

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./main"]