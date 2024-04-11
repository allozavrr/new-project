FROM quay.io/projectquay/golang:1.20 as builder
# Використовуємо базовий образ Go
FROM golang:1.20 as builder

# Встановлюємо необхідні пакети для створення
RUN apk add --no-cache bash

WORKDIR /app
COPY . .

# Будуємо вашу програму
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -o main

# Використовуємо базовий образ без файлової системи
FROM scratch

# Копіюємо скомпільований бінарний файл у пустий образ
COPY --from=builder /app/main .

# Задаємо точку входу для вашої програми
ENTRYPOINT ["./main"]