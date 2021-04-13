FROM nginx:1.19.10-alpine

RUN \
    apk upgrade --no-cache && \
    apk add --no-cache --update \
    musl build-base python3 python3-dev py3-pip libffi libffi-dev openssl openssl-dev tzdata

RUN \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN \
    pip3 install --upgrade pip

RUN \
    source $HOME/.cargo/env && \
    pip3 --no-cache-dir install \
    certbot certbot-dns-cloudflare

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD script/entrypoint.sh /entrypoint.sh
ADD script/le.sh /le.sh

RUN \
    rm /etc/nginx/conf.d/default.conf && \
    chmod +x /entrypoint.sh && \
    chmod +x /le.sh

CMD ["/entrypoint.sh"]
