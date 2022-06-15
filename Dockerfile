FROM golang:1.18.1-stretch

WORKDIR /

ENV CC=clang-6.0
# Used by golangci-lint to determine which Go versions to run the linters on
ENV GOVERSION=1.18.1
ENV GOLANGCI_LINT_VERSION=v1.45.2
ENV GO_SWAGGER_VERSION=0.23.0

# This will force go build to use the vendor folder
ENV GOFLAGS=-mod=vendor

RUN \
    # Add apt key for LLVM repository
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    # Add LLVM apt repository
    && echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-6.0 main" | tee -a /etc/apt/sources.list \
    && echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-6.0 main" | tee -a /etc/apt/sources.list \
    # Update packages
    && apt-get update \
    # Upgrade packages
    && apt-get upgrade -y \
    # Install required packages packages
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    clang-6.0 \
    # Install go-swagger packages (--allow-unauthenticated for swagger only)
    && curl -o /usr/local/bin/swagger -L'#' https://github.com/go-swagger/go-swagger/releases/download/v${GO_SWAGGER_VERSION}/swagger_$(echo `uname`|tr '[:upper:]' '[:lower:]')_amd64
    && chmod +x /usr/local/bin/swagger \
    # Install dep
    && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
    # Install golintci-lint
    && curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | bash -s -- -b $GOPATH/bin ${GOLANGCI_LINT_VERSION} \
    # Clean up install of dep and golangci-lint
    && rm -rf /tmp/* \
    # Clean up APT when done.
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 2000/udp

CMD ["bash"]
