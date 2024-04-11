# Базовий образ, який містить Go та менеджер пакетів apk
FROM golang:1.20-buster as builder

# Встановіть make у обрамленні
RUN apk update && apk add --no-cache make

WORKDIR /app
COPY . .
# Виконайте make без image, оскільки ми вже будемо виконувати цю команду за допомогою Makefile
RUN make

# Створіть мінімальний образ Docker
FROM alpine:latest

WORKDIR /root/
# Скопіюйте скомпільований бінарний файл з попереднього рівня
COPY --from=builder /app/main .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./main"]
