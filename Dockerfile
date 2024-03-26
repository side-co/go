FROM golang:1.22.1-bookworm

WORKDIR /

ENV CC=clang-6.0
ENV GOLANGCI_LINT_VERSION=v1.51.2

RUN \
    # Add apt key for LLVM repository
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    # Add LLVM apt repository
    && echo "deb http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-18 main" | tee -a /etc/apt/sources.list \
    && echo "deb-src http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-18 main" | tee -a /etc/apt/sources.list \
    # Update packages
    && apt-get update \
    # Upgrade packages
    && apt-get upgrade -y \
    # Install required packages packages
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    clang-6.0 \
    # Install golintci-lint
    && curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | bash -s -- -b $GOPATH/bin ${GOLANGCI_LINT_VERSION} \
    # Clean up install of golangci-lint
    && rm -rf /tmp/* \
    # Clean up APT when done.
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 2000/udp

CMD ["bash"]
