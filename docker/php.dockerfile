ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm-alpine3.17

RUN set -xe; \
    apk add --no-cache \
    bash \
    postgresql-dev

###########################################################################
# MYSQL: Requires mysql-dev
###########################################################################

RUN docker-php-ext-install pdo pdo_mysql

###########################################################################
# Composer
###########################################################################

ARG COMPOSER_VERSION

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');"

RUN mv composer.phar /usr/local/bin/composer

###########################################################################
# Final Setup
###########################################################################

RUN set -xe; php -v | head -n 1 | grep -q "PHP ${PHP_VERSION}."

COPY ./php-config/laravel.ini /usr/local/etc/php/conf.d
COPY ./php-config/php-fpm.conf /usr/local/etc/php-fpm.d/

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["php-fpm"]
