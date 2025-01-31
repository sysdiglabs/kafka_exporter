FROM golang:1.20.4 as builder
ARG TARGETARCH
ARG BIN_DIR=.build/linux-${TARGETARCH}/

WORKDIR /go/src/github.com/danielqsj/kafka_exporter
COPY . .
RUN go mod download
RUN make build
RUN cp kafka_exporter /bin/kafka_exporter

FROM scratch as scratch
COPY --from=builder /bin/kafka_exporter /bin/kafka_exporter
EXPOSE     9308
ENTRYPOINT [ "/bin/kafka_exporter" ]

FROM quay.io/sysdig/sysdig-mini-ubi9:1.2.0 as ubi
COPY --from=builder /bin/kafka_exporter /bin/kafka_exporter
EXPOSE     9308
ENTRYPOINT [ "/bin/kafka_exporter" ]
