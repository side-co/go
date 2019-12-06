FROM golang:1.13.5-stretch

WORKDIR /

ENV CC=clang-6.0
ENV GOLANGCI_LINT_VERSION=v1.21.0
ENV GO_SWAGGER_VERSION=0.21.0

# This will force go build to use the vendor folder
ENV GOFLAGS=-mod=vendor

RUN \
    # Add apt key for LLVM repository
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    # Add LLVM apt repository
    && echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-6.0 main" | tee -a /etc/apt/sources.list \
    && echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-6.0 main" | tee -a /etc/apt/sources.list \
    # Add go-swagger apt repository
    && echo "deb http://dl.bintray.com/go-swagger/goswagger-debian ubuntu main" | tee -a /etc/apt/sources.list \
    # Update packages
    && apt-get update \
    # Upgrade packages
    && apt-get upgrade -y \
    # Install required packages packages
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    clang-6.0 \
    # Install go-swagger packages (--allow-unauthenticated for swagger only)
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
    swagger=${GO_SWAGGER_VERSION} \
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
