FROM golang:1.12 as builder

ENV PA_EXPORTER_VERSION="0.1.0"

WORKDIR /go/src/github.com/FXinnovation/poweradmin_exporter

RUN git clone https://github.com/FXinnovation/poweradmin_exporter.git . &&\
    git checkout ${PA_EXPORTER_VERSION} &&\
    make build

FROM ubuntu:18.04

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ENV CA_CERTIFICATES_VERSION="20180409" \
    PA_EXPORTER_VERSION="0.1.0" \
    PA_EXPORTER_SERVER="http://pa.example.com" \
    PA_EXPORTER_API_KEY="SOMEAPIKEY" \
    CONFD_BACKEND_FILE="/data/configuration.yaml" \
    CONFD_VERSION="0.16.0"

COPY --from=builder /go/src/github.com/FXinnovation/poweradmin_exporter/poweradmin_exporter /poweradmin_exporter

ADD ./resources /resources

RUN /resources/build && rm -rf /resources

USER pae

EXPOSE 9876

WORKDIR /opt/pae

VOLUME /data

ENTRYPOINT [ "/entrypoint" ]

LABEL "maintainer"="cloudsquad@fxinnovation.com" \
      "org.label-schema.name"="poweradmin-exporter" \
      "org.label-schema.base-image.name"="docker.io/library/ubuntu" \
      "org.label-schema.base-image.version"="18.04" \
      "org.label-schema.description"="poweradmin-exporter in a container" \
      "org.label-schema.url"="https://github.com/FXinnovation/poweradmin_exporter" \
      "org.label-schema.vcs-url"="https://github.com/FXinnovation/poweradmin_exporter" \
      "org.label-schema.vendor"="FXinnovation" \
      "org.label-schema.schema-version"="1.0.0-rc.1" \
      "org.label-schema.applications.poweradmin_exporter.version"="$PA_EXPORTER_VERSION" \
      "org.label-schema.applications.ca-certificates.version"="$CA_CERTIFICATES_VERSION" \
      "org.label-schema.applications.confd.version"="$CONFD_VERSION" \
      "org.label-schema.vcs-ref"=$VCS_REF \
      "org.label-schema.version"=$VERSION \
      "org.label-schema.build-date"=$BUILD_DATE \
      "org.label-schema.usage"="Please see README.md"
