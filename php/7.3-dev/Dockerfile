FROM php:7.3.22-fpm-alpine

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

ENV FILES_DIR="/mnt/files"
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
        redis-4.3.0 \
        xdebug-2.9.6 && \
    docker-php-ext-enable \
        amqp \
        imagick \
        redis \
        xdebug && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-configure gd \
        --with-gd \
        --with-webp-dir \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install "-j${NPROC}" gd && \
    install -o scue -g scue -d \
        "${FILES_DIR}" \
        "${FILES_DIR}/xdebug" \
        "${FILES_DIR}/xdebug/traces" \
        "${FILES_DIR}/xdebug/profiler" && \
    chmod -R 775 "${FILES_DIR}" && \
    apk del --purge .scue-php-build-deps && \
    pecl clear-cache && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/lib/apt/lists

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
RUN \
    composer global require "hirak/prestissimo" --no-suggest --optimize-autoloader --classmap-authoritative && \
    cp -R /root/.composer /home/scue/.composer && \
    chown -R scue:scue /home/scue/.composer && \
    rm -rf /root/.composer

# Install netz98/n98-magerun2
# https://github.com/netz98/n98-magerun2
RUN \
    curl -sS https://files.magerun.net/n98-magerun2.phar --output /usr/local/bin/n98-magerun2 && \
    chmod +x /usr/local/bin/n98-magerun2

COPY ./etc/php.ini /usr/local/etc/php/php.ini
COPY ./etc/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker-entrypoint.sh /

# Change permissions of php config files
# to be able to edit them via the docker-entrypoint.sh
RUN \
    set -xe && \
    chown -R scue:scue \
        /usr/local/etc/php/conf.d \
        /usr/local/etc/php-fpm.d

RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

USER scue
WORKDIR /var/www/html
EXPOSE 9000

CMD ["php-fpm"]
