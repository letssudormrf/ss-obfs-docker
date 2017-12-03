FROM alpine

LABEL maintainer="letssudormrf"

#GIT
ENV SS_GIT_PATH="https://github.com/shadowsocks/shadowsocks-libev" \
    OBFS_GIT_PATH="https://github.com/shadowsocks/simple-obfs"

#Download applications
RUN set -ex \
    && if [ $(wget -qO- ipinfo.io/country) == CN ]; then echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories ;fi \
    && apk --update add --no-cache libcrypto1.0 \
                                   libev \
                                   libsodium \
                                   mbedtls \
                                   pcre \
                                   c-ares \
    && apk add --no-cache --virtual TMP git \
                                        autoconf \
                                        automake \
                                        make \
                                        build-base \
                                        zlib-dev \
                                        gettext-dev \
                                        asciidoc \
                                        xmlto \
                                        libpcre32 \
                                        libev-dev \
                                        libsodium-dev \
                                        libtool \
                                        linux-headers \
                                        mbedtls-dev \
                                        openssl-dev \
                                        pcre-dev \
                                        c-ares-dev \
                                        g++ \
                                        gcc \

#Compile Shadowsocks + simple-obfs
   && cd /tmp \
   && git clone ${SS_GIT_PATH} \
   && cd ${SS_GIT_PATH##*/} \
   && git submodule update --init --recursive \
   && ./autogen.sh \
   && ./configure --prefix=/usr && make \
   && make install \
   && cd /tmp \
   && git clone ${OBFS_GIT_PATH} \
   && cd ${OBFS_GIT_PATH##*/} \
   && git submodule update --init --recursive \
   && ./autogen.sh \
   && ./configure --prefix=/usr && make \
   && make install \
   && cd \
   && apk del TMP \
   && rm -rf /tmp/* \
   && rm -rf /var/cache/apk/*

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x usr/local/bin/entrypoint.sh

EXPOSE 8443/tcp 8443/udp

CMD ["entrypoint.sh"]
