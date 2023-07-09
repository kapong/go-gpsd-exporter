FROM golang:1.20 as builder

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o /usr/local/bin/go-exporter ./...

CMD ["app"]

FROM alpine

COPY --from=builder /usr/local/bin/go-exporter /usr/local/bin/go-exporter

ENTRYPOINT [ "go-exporter" ]