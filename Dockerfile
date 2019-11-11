FROM alpine

ENV HELM_VERSION="v2.8.2"
ENV KUBECTL_VERSION="v1.9.3"

RUN \
    apk add --update ca-certificates && \
    apk add -t deps curl && \
    apk add bash

RUN \
    curl -Lo /tmp/helm.tar.gz \
    https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -xvf /tmp/helm.tar.gz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/local/bin && \
    rm -rf /tmp/*

RUN \
    curl -Lo /usr/local/bin/kubectl \
    https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    apk del --purge deps && \
    rm /var/cache/apk/*

RUN helm plugin install https://github.com/futuresimple/helm-secrets
RUN helm plugin install https://github.com/hypnoglow/helm-s3.git

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]