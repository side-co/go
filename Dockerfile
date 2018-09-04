FROM golang:alpine

WORKDIR /

ENV GOLANGCI_LINT_VERSION=latest

RUN apk update \
    # Update and upgrade alpine packages
    && apk upgrade \
    # Install required packages 
    && apk --no-cache add ca-certificates bash git make \
    # Install required packages to lint go code
    && apk --no-cache add clang gcc libc-dev \
    # Install packages needed for this image to build (cleaned at the end)
    && apk --no-cache add --virtual build-dependencies curl unzip \
    # Install dep
    && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
    # Install golintci-lint
    && curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | bash -s -- -b $GOPATH/bin ${GOLANGCI_LINT_VERSION} \
    && rm -rf /tmp/* \
    # Clean build dependancies
    && apk del --purge -r build-dependencies 

EXPOSE 2000/udp

CMD ["bash"]
