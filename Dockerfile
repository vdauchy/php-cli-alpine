ARG version
ARG arch

FROM php:${version}-cli-alpine

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
    && ssh-keyscan gitlab.com >> /etc/ssh/ssh_known_hosts

ENV PHP_APP_ROOT=/usr/src
WORKDIR ${PHP_APP_ROOT}