FROM golang:1.22.1 as builder

WORKDIR /app
COPY . .
RUN make 

FROM scratch
WORKDIR /
COPY --from=builder /app/main .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./main"]