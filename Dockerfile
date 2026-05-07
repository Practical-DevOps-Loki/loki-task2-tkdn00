FROM golang:1.20-alpine AS builder

WORKDIR /app

COPY ./ ./

RUN CGO_ENABLED=0 GOOS=linux go mod download && \
    go build -o webapp .

FROM alpine

ENV PORT=3000 \
    LOG_PATH=/app/log/app.log

WORKDIR /app
COPY --from=builder /app/webapp /app
COPY --from=builder /app/public /app/public

EXPOSE ${PORT}
CMD ["/app/webapp"]