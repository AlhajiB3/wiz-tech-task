# Stage 1: Build the binary
FROM golang:1.19 AS build

WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky

# Stage 2: Final container
FROM alpine:3.17.0 as release

WORKDIR /app

# Copy binary and assets
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets

# ✅ Add the required file with your name
RUN echo "Alhaji - Wiz Technical Exercise V4" > /wizexercise.txt

EXPOSE 8080
ENTRYPOINT ["/app/tasky"]