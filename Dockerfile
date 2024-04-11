FROM quay.io/projectquay/golang:1.20 as builder

WORKDIR /app
COPY . .

FROM scratch
WORKDIR /
COPY --from=builder /app/main .
ENTRYPOINT ["./main"]