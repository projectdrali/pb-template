FROM alpine:latest AS certs
RUN apk --update add ca-certificates

FROM golang:1.23 AS builder
WORKDIR /pb
COPY go.mod go.sum ./
COPY ./migrations/ ./migrations/
COPY cmd/ ./
RUN CGO_ENABLED=0 go build -o pb


FROM scratch
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /pb/pb /pb
EXPOSE 8080
CMD ["/pb","serve","--http=0.0.0.0:8080"]