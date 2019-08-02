FROM php:7.3-fpm-alpine as base

RUN apk update && apk upgrade && apk add --no-cache \
    curl-dev \
    git \
    nginx \
    supervisor \
    unzip \
    yarn \
    zip \
    && rm -rf /tmp/* /var/cache/apk/*

RUN docker-php-ext-install \
    ctype \
    curl \
    iconv \
    json \
    opcache

ENV COMPOSER_ALLOW_SUPERUSER 1
RUN php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');" \
    && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm /tmp/composer-setup.php \
    && composer global require hirak/prestissimo

COPY ./.docker/services/app/etc/nginx/conf.d/base.conf /etc/nginx/conf.d/default.conf
COPY ./.docker/services/app/etc/php/conf.d/base.ini    /usr/local/etc/php/conf.d/base.ini
COPY ./.docker/services/app/etc/supervisor.d/base.ini  /etc/supervisor.d/base.ini



FROM base as develop

RUN apk add --no-cache \
    $PHPIZE_DEPS \
    && rm -rf /tmp/* /var/cache/apk/*

RUN pear update-channels && pecl install -o -f \
    xdebug

RUN docker-php-ext-enable \
    xdebug

COPY ./.docker/services/app/etc/php/conf.d/develop.ini   /usr/local/etc/php/conf.d/develop.ini
COPY ./.docker/services/app/etc/supervisor.d/develop.ini /etc/supervisor.d/develop.ini

WORKDIR /var/www/app

EXPOSE 80 9000 8080

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]



FROM base as build

COPY ./.docker/services/app/etc/php/conf.d/production.ini /usr/local/etc/php/conf.d/production.ini

WORKDIR /var/www/app

COPY ./composer.json ./composer.lock ./
COPY ./package.json ./yarn.lock ./

RUN composer install --no-dev --no-scripts
RUN yarn install

COPY ./ ./

RUN composer auto-scripts --no-dev
RUN yarn encore production



FROM base as production

COPY ./.docker/services/app/etc/php/conf.d/production.ini /usr/local/etc/php/conf.d/production.ini

WORKDIR /var/www/app

COPY --from=build /var/www/app ./

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
