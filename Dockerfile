# Dockerfile

# Базовий образ
FROM quay.io/projectquay/golang:1.20

# Контейнеризація коду
COPY . /app

# Права на виконання для головного файлу
RUN chmod +x /app/main

# Робоча директорія
WORKDIR /app

# Збирання коду
ARG TARGET
RUN GOOS=$TARGET go build -o app

# Запуск контейнера
CMD ["./app/main"]