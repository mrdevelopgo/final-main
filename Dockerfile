# Этап сборки
FROM golang:1.21 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o tracker .

# Итоговый образ
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/tracker .
# Если приложение слушает порт, раскомментируйте и укажите нужный порт:
# EXPOSE 8080
CMD ["./tracker"]