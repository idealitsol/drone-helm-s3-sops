FROM 'dtzar/helm-kubectl'

RUN apk update && apk add bash

RUN apk add \
    python \
    py-pip \
    curl \
    bash \
    git \
    jq \
    zip \
    && \
    pip install --upgrade awscli && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

ENV HELM_HOME /tmp/helm
RUN mkdir -p /tmp/helm
RUN helm init --client-only
RUN helm plugin install https://github.com/futuresimple/helm-secrets
RUN helm plugin install https://github.com/hypnoglow/helm-s3.git

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]

CMD ["--help"]