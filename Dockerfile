FROM alpine

LABEL maintainer Cole McKnight <cbmckni@clemson.edu>

RUN apk --update add bash git less openssh curl && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

# install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl
RUN chmod u+x kubectl && mv kubectl /bin/kubectl
