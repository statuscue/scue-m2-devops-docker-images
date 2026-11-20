FROM php:7.4.26-fpm-alpine

LABEL org.opencontainers.image.description "php image for staging environment."

ARG UID
ARG GID

RUN \
    set -eux && \
    # Delete existing user/group if uid/gid occupied.
    existing_group=$(getent group "${GID}" | cut -d: -f1) && \
    if [[ -n "${existing_group}" ]]; then delgroup "${existing_group}"; fi && \
    existing_user=$(getent passwd "${UID}" | cut -d: -f1) && \
    if [[ -n "${existing_user}" ]]; then deluser "${existing_user}"; fi && \
    apk add --update --no-cache shadow && \
    addgroup -g "${GID}" deploy && \
    adduser -u "${UID}" -D -s /bin/bash -G deploy deploy && \
    sed -i '/^deploy/s/!/*/' /etc/shadow
RUN \
    set -eux && \
    apk add --no-cache \
        bash \
        freetype \
        gmp \
        gzip \
        icu-libs \
        imagemagick\
        jpegoptim \
        libbz2 \
        libjpeg-turbo \
        libjpeg-turbo-utils \
        libltdl \
        libpng \
        libwebp \
        libxml2 \
        libxslt \
        libzip \
        make \
        patch \
        pngquant \
        rabbitmq-c \
        wget \
        zip \
        unzip \ 
    && \
    apk add --no-cache --virtual .scue-php-build-deps \
        autoconf \
        cmake \
        build-base \
        bzip2-dev \
        freetype-dev \
        gmp-dev \
        icu-dev \
        imagemagick-dev \
        jpeg-dev \
        libgcrypt-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libtool \
        libwebp-dev \
        libxslt-dev \
        libzip-dev \
        pcre-dev \
        rabbitmq-c-dev && \
    docker-php-ext-install \
        bcmath \
        exif \
        intl \
        opcache \
        pdo_mysql \
        soap \
        sockets \
        xsl \
        zip && \
    pecl install \
        amqp-1.10.2 \
        imagick-3.4.4 \
        redis-4.3.0 && \
    docker-php-ext-enable \
        amqp \
        imagick \
        redis && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-configure gd --with-webp --with-freetype --with-jpeg && \
    docker-php-ext-install "-j${NPROC}" gd && \
    apk del --purge --no-network .scue-php-build-deps && \
    pecl clear-cache && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/lib/apt/lists
COPY ./etc/php.ini /usr/local/etc/php/php.ini
COPY ./etc/www.conf /usr/local/etc/php-fpm.d/www.conf
WORKDIR /var/www/html
EXPOSE 9000
USER deploy
CMD ["php-fpm"]
