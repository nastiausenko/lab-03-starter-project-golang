FROM golang:1.22.0-alpine AS builder

WORKDIR /app

COPY go.mod .
COPY go.sum .
COPY main.go .
RUN go mod download
COPY cmd cmd
COPY lib lib
COPY templates templates
RUN go build -o build/fizzbuzz

FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=builder /app/templates templates
COPY --from=builder /app/build/fizzbuzz /fizzbuzz

CMD ["/fizzbuzz", "serve"]
