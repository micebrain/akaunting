FROM alpine:3.12

ARG AKAUNTING_VERSION=2.0.19

ENV USER=nobody \
    APP_DIR=/var/www/akaunting

RUN apk update && apk --no-cache add php7 php7-fpm php7-mysqli php7-phar \
    php7-xml php7-mbstring php7-bcmath php7-intl php7-session php7-dom php7-ctype\
    php7-gd php7-zlib php7-opcache php7-json php7-curl php7-pdo php7-pdo_mysql \
    php7-tokenizer php7-common php7-fileinfo php7-zip \
    nginx supervisor curl su-exec \
    && rm /etc/nginx/conf.d/default.conf \
    && mkdir -p ${APP_DIR} \
    && mkdir /run/nginx \
    && chown -R ${USER} ${APP_DIR} \
    && chown -R ${USER} /run \
    && chown -R ${USER} /var/lib/nginx \
    && chown -R ${USER} /var/log/nginx \
    && chown -R ${USER} /var/log/php7

RUN cd ${APP_DIR} \
    && wget "https://github.com/akaunting/akaunting/releases/download/${AKAUNTING_VERSION}/Akaunting_${AKAUNTING_VERSION}-Stable.zip" -O /tmp/Akaunting_${AKAUNTING_VERSION}-Stable.zip \
    && unzip /tmp/Akaunting_${AKAUNTING_VERSION}-Stable.zip \
    && chown -R ${USER} ${APP_DIR}

ADD docker/nginx/akaunting.conf /etc/nginx/conf.d/akaunting.conf
ADD docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD docker/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
     
WORKDIR ${APP_DIR}

EXPOSE 9090/tcp 

USER ${USER}

HEALTHCHECK --timeout=20s CMD curl --silent --fail http://127.0.0.1:9090/fpm-ping

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
