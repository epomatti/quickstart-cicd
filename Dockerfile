FROM golang:1.20 AS builder
WORKDIR /build
COPY . .

RUN go build -o /build/main

FROM scratch
WORKDIR /app
COPY --from=builder /build/main .
ENTRYPOINT ["/app/main"]
