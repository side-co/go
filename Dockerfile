FROM golang:1.21.13-bookworm

WORKDIR /

ENV CC=clang-14
ENV GOLANGCI_LINT_VERSION=v1.54.1

# This will force go build to use the vendor folder
ENV GOFLAGS=-mod=vendor

RUN apt-get update \
    && apt-get upgrade -y

# Install required packages packages
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    ${CC} \
    curl

# Install golintci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin ${GOLANGCI_LINT_VERSION}

EXPOSE 2000/udp

CMD ["bash"]
