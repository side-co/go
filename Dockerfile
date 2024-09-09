FROM golang:1.20.14-bookworm

WORKDIR /

ENV CC=clang-14
ENV GOLANGCI_LINT_VERSION=v1.51.2
ENV GO_SWAGGER_VERSION=0.23.0

# This will force go build to use the vendor folder
ENV GOFLAGS=-mod=vendor

RUN apt-get update \
    && apt-get upgrade -y

# Install required packages packages
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    ${CC} \
    curl

# Install go-swagger packages (--allow-unauthenticated for swagger only)
RUN curl -o /usr/local/bin/swagger -L'#' https://github.com/go-swagger/go-swagger/releases/download/v${GO_SWAGGER_VERSION}/swagger_$(echo `uname`|tr '[:upper:]' '[:lower:]')_amd64 \
    && chmod +x /usr/local/bin/swagger

# Install golintci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin ${GOLANGCI_LINT_VERSION}

EXPOSE 2000/udp

CMD ["bash"]
