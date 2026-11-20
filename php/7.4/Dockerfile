FROM php:7.4.11-fpm-alpine

ARG USER_ID=1000
ARG GROUP_ID=1000

# Create user/group if not exists
RUN \
    set -xe && \
    # Delete existing user/group if uid/gid occupied.
    existing_group=$(getent group "${GROUP_ID}" | cut -d: -f1) && \
    if [[ -n "${existing_group}" ]]; then delgroup "${existing_group}"; fi && \
    existing_user=$(getent passwd "${USER_ID}" | cut -d: -f1) && \
    if [[ -n "${existing_user}" ]]; then deluser "${existing_user}"; fi && \
    addgroup -g "${GROUP_ID}" -S scue && \
    adduser -u "${USER_ID}" -D -S -s /bin/bash -G scue scue && \
    adduser scue www-data && \
    sed -i '/^scue/s/!/*/' /etc/shadow

RUN \
    set -xe && \
    apk add --no-cache --virtual .scue-php-run-deps \
        bash \
        curl \
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
        shadow \
        tar \
        unzip \
        wget \
        zip && \
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
    apk del --purge .scue-php-build-deps && \
    pecl clear-cache && \
    rm -rf /var/cache/apk/*

COPY ./etc/php.ini /usr/local/etc/php/php.ini
COPY ./etc/www.conf /usr/local/etc/php-fpm.d/www.conf

USER scue
WORKDIR /var/www/html
EXPOSE 9000

CMD ["php-fpm"]
