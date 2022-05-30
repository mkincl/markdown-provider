FROM alpine:3.16

RUN apk add --no-cache \
    git=2.36.1-r0 \
    make=4.3-r0

# hadolint ignore=DL3059
RUN apk add --no-cache \
    npm=8.10.0-r0

# hadolint ignore=DL3059
RUN npm install --global \
    markdown-link-check@3.10.2 \
    markdownlint-cli@0.31.1
