FROM golang:1.21 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN echo "=== Содержимое /app ===" && ls -la /app
RUN echo "=== Версия Go ===" && go version
RUN echo "=== Первые 10 строк go.mod ===" && head -10 go.mod
RUN go env -w GOPROXY=https://proxy.golang.org,direct
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o tracker .

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/tracker .
CMD ["./tracker"]