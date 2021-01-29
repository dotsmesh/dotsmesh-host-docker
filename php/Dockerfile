FROM php:8.0-fpm-alpine

LABEL maintainer="Dots Mesh team <team@dotsmesh.com>"

RUN apk --no-cache add \
        git \
        libzip-dev \
        libpng-dev \
        libwebp-dev \
        libmemcached-dev \
        freetype-dev \
        jpeg-dev \
        libjpeg-turbo-dev \
        gmp-dev \
    && git clone https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
    && docker-php-ext-configure gd --with-webp --with-jpeg --with-freetype \
    && docker-php-ext-install gd opcache zip memcached gmp \
    && rm -Rf /usr/src/php/ext/memcached \
    && apk del git \
    && rm -Rf /usr/local/etc/php/php.ini-development \
    && rm -Rf /usr/local/etc/php/php.ini-production \
    && rm -Rf /usr/local/etc/php/phar* \
    && rm -Rf /usr/src/php* \
    && rm -Rf /usr/local/bin/phpdbg \
    && mv /usr/local/lib/php/extensions/no-debug-non-zts-20200930 /usr/local/etc/extensions \
    && rm -Rf /usr/local/lib/php \
    && rm -Rf /usr/local/include/php \
    && rm -Rf /usr/local/etc/php/conf.d/*

COPY ./php.ini /usr/local/etc/php/php.ini
COPY ./php-fpm.conf /usr/local/etc/php-fpm.conf