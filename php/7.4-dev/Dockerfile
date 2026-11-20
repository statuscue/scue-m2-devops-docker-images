FROM php:7.4.26-fpm-alpine

LABEL org.opencontainers.image.description "php image for dev environment."

ARG UID=1000
ARG GID=1000

RUN \
    set -eux && \
    # Delete existing user/group if uid/gid occupied.
    existing_group=$(getent group "${GID}" | cut -d: -f1) && \
    if [[ -n "${existing_group}" ]]; then delgroup "${existing_group}"; fi && \
    existing_user=$(getent passwd "${UID}" | cut -d: -f1) && \
    if [[ -n "${existing_user}" ]]; then deluser "${existing_user}"; fi && \
    apk add --update --no-cache shadow && \
    addgroup -g "${GID}" scue && \
    adduser -u "${UID}" -D -s /bin/bash -G scue scue && \
    sed -i '/^scue/s/!/*/' /etc/shadow

RUN \
    set -eux && \
    apk add --no-cache \
        bash \
        curl \
        freetype \
        git \
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
        xdebug-3.0.3 && \
    docker-php-ext-enable \
        amqp \
        imagick \
        redis \
        xdebug && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-configure gd --with-webp --with-freetype --with-jpeg && \
    docker-php-ext-install "-j${NPROC}" gd && \
    apk del --purge --no-network .scue-php-build-deps && \
    pecl clear-cache && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/lib/apt/lists

# Create some extra directories for DevTools like xdebug, etc.
ENV FILES_DIR="/mnt/files"
RUN \
    set -eux && \
    install -o scue -g scue -d \
        "${FILES_DIR}" \
        "${FILES_DIR}/xdebug" && \
    chmod -R 775 "${FILES_DIR}"

# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
RUN \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    cp -R /root/.composer /home/scue/.composer && \
    chown -R scue:scue /home/scue/.composer && \
    rm -rf /root/.composer

# Install netz98/n98-magerun2
# https://github.com/netz98/n98-magerun2
RUN \
    curl -sS https://files.magerun.net/n98-magerun2.phar --output /usr/local/bin/n98-magerun2 && \
    chmod +x /usr/local/bin/n98-magerun2

# Install Pestle
# https://github.com/astorm/pestle
RUN \
    curl -sSL http://pestle.pulsestorm.net/pestle.phar --output /usr/local/bin/pestle && \
    chmod +x /usr/local/bin/pestle

# Install modman
# https://github.com/colinmollenhour/modman
RUN \
    curl -sSL https://raw.githubusercontent.com/colinmollenhour/modman/master/modman --output /usr/local/bin/modman && \
    chmod +x /usr/local/bin/modman

# Override config files
COPY ./etc/php.ini /usr/local/etc/php/php.ini
COPY ./etc/www.conf /usr/local/etc/php-fpm.d/www.conf

# Change permissions of php config files
# to be able to edit them via the docker-entrypoint.sh
RUN chown -R scue:scue \
        /usr/local/etc/php/conf.d \
        /usr/local/etc/php-fpm.d

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

USER scue
WORKDIR /var/www/html
EXPOSE 9000
CMD ["php-fpm"]
