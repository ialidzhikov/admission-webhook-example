FROM golang:1.14 AS builder

WORKDIR /go/src/github.com/ialidzhikov/admission-webhook-example
COPY . .

RUN go mod vendor && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on \
  go install -mod=vendor ./...



FROM alpine:latest

COPY --from=builder /go/bin/admission-webhook-example /admission-webhook-example

ENTRYPOINT ["./admission-webhook-example"]
