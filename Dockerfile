ARG version

FROM php:${version}-cli-alpine

ARG extension=''

ENV PHP_PROJECT_ROOT=/usr/project
ENV COMPOSER_CACHE_DIR=/tmp

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions \
    ast \
    bcmath \
    blackfire \
    csv \
    exif \
    gd \
    gettext \
    imagick \
    intl \
    opcache \
    pcntl \
    pdo_mysql \
    posix \
    redis \
    sockets \
    sodium \
    sysvmsg \
    sysvsem \
    sysvshm \
    zip

RUN install-php-extensions ${extension}

RUN apk add --no-cache \
    bash \
    git \
    openssh-client

RUN curl -A "Docker" -L https://blackfire.io/api/v1/releases/cli/linux/$(uname -m) | tar zxp -C /usr/bin blackfire

RUN ssh-keyscan github.com >> /etc/ssh/ssh_known_hosts && \
    ssh-keyscan gitlab.com >> /etc/ssh/ssh_known_hosts && \
    mkdir "${PHP_PROJECT_ROOT}"

WORKDIR ${PHP_PROJECT_ROOT}
