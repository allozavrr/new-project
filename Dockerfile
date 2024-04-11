FROM golang:1.20-buster as builder

FROM golang:1.22.1 as builder

WORKDIR /app
COPY . .
RUN make image

FROM scratch
WORKDIR /
COPY --from=builder /app/main .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./main"]