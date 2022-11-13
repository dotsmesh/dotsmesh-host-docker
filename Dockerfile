FROM alpine:latest

LABEL maintainer="Dots Mesh team <team@dotsmesh.com>"

RUN apk --no-cache add \
    curl \
    nginx \
    php81 \
    php81-fpm \
    php81-gmp \
    php81-zip \
    php81-opcache \
    php81-gd \
    php81-curl \
    php81-mbstring \
    php81-openssl \
    php81-pecl-memcached \
    certbot

RUN adduser php-fpm-user -D -H -u 2000
RUN addgroup php-fpm-group -g 2001
RUN adduser php-fpm-user php-fpm-group

COPY ./php.ini /etc/php81/php.ini
COPY ./php-fpm.conf /etc/php81/php-fpm.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./nginx-vhost-80.conf /nginx-vhost-80.conf
COPY ./nginx-vhost-443.conf /nginx-vhost-443.conf
COPY ./nginx-default-certificate.crt /nginx-default-certificate.crt
COPY ./nginx-default-certificate.key /nginx-default-certificate.key
COPY ./nginx-check-certificate.php /nginx-check-certificate.php
COPY ./nginx-generate-certificate.php /nginx-generate-certificate.php

COPY ./init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 80
EXPOSE 443

CMD ["/init.sh"]