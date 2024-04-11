FROM golang:1.22.1 as builder

WORKDIR /home/workdir/
COPY . .
RUN make all  

FROM scratch
WORKDIR /
COPY --from=builder /home/workdir/main ./  # Змінено шлях до скомпільованого бінарного файлу
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./main"]