# php-cli-alpine

Simple PHP CLI images to be able to do Open Source projects without thinking about extensions.
    
    - Alpine based.
    - Automatically build with latest patches.
    - Composer installed.
    - Dedicated image tags '[version]-pcov/xdebug/memprof' for development purpose.
    - Extensions in the Dockerfile (imagick, intl, opcache, redis, ...).
    - PHP 7.3, 7.4, 8.0, 8.1, 8.2, ...
    - Tools integrated: bash, git and openssh-client.

Docker images pushed to: https://hub.docker.com/r/vdauchy/php-cli-alpine