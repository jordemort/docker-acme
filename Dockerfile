FROM alpine:3 AS untar

ADD https://github.com/acmesh-official/acme.sh/archive/master.tar.gz /usr/src/acme.sh-master.tar.gz
WORKDIR /usr/src
RUN tar -xvf acme.sh-master.tar.gz

FROM alpine:3

RUN apk update -f && \
    apk --no-cache add -f \
      bind-tools \
      coreutils \
      curl \
      docker-cli \
      dumb-init \
      oath-toolkit-oathtool \
      openssh-client \
      openssl \
      socat \
      tar \
      tzdata && \
    rm -rf /var/cache/apk/*

ARG ACME_UID=60443
ARG ACME_GID=60443

RUN addgroup -g ${ACME_UID} acme && \
    adduser -u ${ACME_GID} -S -s /bin/sh -G acme acme && \
    mkdir /data && \
    chown acme:acme /data

COPY --chown=acme:acme --from=untar /usr/src/acme.sh-master/ /usr/src/acme.sh-master/

USER acme
WORKDIR /usr/src/acme.sh-master

RUN ./acme.sh --install --config-home /data && \
    rm -rf acme.sh-master && \
    cp /data/account.conf /home/acme/default.account.conf

WORKDIR /home/acme

COPY acme-entrypoint.sh /usr/sbin/acme-entrypoint.sh

ENV LE_WORKING_DIR=/home/acme/.acme.sh \
    LE_CONFIG_HOME=/data \
    PATH=/home/acme/.acme.sh:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

VOLUME ["/data"]
ENTRYPOINT ["/usr/bin/dumb-init", "/usr/sbin/acme-entrypoint.sh"]
