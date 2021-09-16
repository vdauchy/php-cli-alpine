ARG version
ARG arch

FROM php:${version}-cli-alpine

ENV PHP_PROJECT_ROOT=/usr/project
ENV COMPOSER_CACHE_DIR=/tmp

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions \
        ast \
        bcmath \
        csv \
        exif \
        gd \
        gettext \
        imagick \
        intl \
        opcache \
        pcntl \
        pcov \
        pdo_mysql \
        redis \
        sodium \
        zip \
    && apk add --no-cache \
        bash \
        git \
        openssh-client \
    && ssh-keyscan github.com >> /etc/ssh/ssh_known_hosts \
    && ssh-keyscan gitlab.com >> /etc/ssh/ssh_known_hosts \
    && mkdir "${PHP_PROJECT_ROOT}"

WORKDIR ${PHP_PROJECT_ROOT}
