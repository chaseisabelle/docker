ARG GOLANG=1.21
ARG ALPINE=3.18


FROM golang:${GOLANG}-alpine${ALPINE} AS protoc-builder

WORKDIR /workdir

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest && \
    go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest && \
    go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest && \
    go install github.com/srikrsna/protoc-gen-gotag@latest

FROM alpine:${ALPINE} AS protoc

RUN apk add --no-cache protobuf

COPY --from=protoc-builder /go/bin/* /usr/local/bin/

ENTRYPOINT ["protoc"]

CMD ["--help"]


FROM golang:${GOLANG}-alpine${ALPINE} AS sqlboiler-builder

RUN go install github.com/volatiletech/sqlboiler/v4@latest && \
    go install github.com/volatiletech/sqlboiler/v4/drivers/sqlboiler-psql@latest && \
    go install github.com/volatiletech/sqlboiler/v4/drivers/sqlboiler-mysql@latest && \
    go install github.com/volatiletech/sqlboiler/v4/drivers/sqlboiler-sqlite3@latest

FROM alpine:${ALPINE} AS sqlboiler

COPY --from=sqlboiler-builder /go/bin/* /usr/local/bin/

ENTRYPOINT ["sqlboiler"]

CMD ["--help"]


FROM golang:${GOLANG}-alpine${ALPINE} AS oapi-builder

RUN go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest

FROM alpine:${ALPINE} AS oapi

COPY --from=oapi-builder /go/bin/* /usr/local/bin/

ENTRYPOINT ["oapi-codegen"]

CMD ["--help"]


FROM eclipse-temurin AS swagger

WORKDIR /workdir

RUN apt-get update -y && \
    apt-get install -y wget && \
    wget https://repo1.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/3.0.49/swagger-codegen-cli-3.0.49.jar -O /swagger-codegen-cli.jar

ENTRYPOINT ["java", "-jar", "/swagger-codegen-cli.jar"]

CMD ["--help"]
