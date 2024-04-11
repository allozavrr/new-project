FROM quay.io/projectquay/golang:1.20 as builder

WORKDIR /app
COPY . .

FROM scratch
WORKDIR /
COPY --from=builder /app/main .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./main"]