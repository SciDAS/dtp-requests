FROM alpine

LABEL maintainer Cole McKnight <cbmckni@clemson.edu>

RUN apk --update add bash git less openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*
