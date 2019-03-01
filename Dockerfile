FROM php:7.2.14-fpm-alpine

LABEL maintainer="Ildar Asanov <i.asanov@corp.mail.ru>"

RUN apk update
RUN apk add icu-dev
RUN apk add --update freetype-dev libpng-dev libjpeg-turbo-dev libxml2-dev autoconf g++ imagemagick-dev libtool make  libmemcached-dev
RUN apk add git
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN apk add yarn
RUN apk add npm

RUN apk add --no-cache bash
RUN apk add --no-cache openssh
RUN pecl install imagick
RUN docker-php-ext-enable imagick

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=/usr/local/bin && \
        echo "alias composer='composer'" >> /root/.bashrc && \
        composer

RUN pecl install igbinary
RUN docker-php-ext-enable igbinary
RUN pecl install lzf
RUN docker-php-ext-enable lzf
RUN yes "yes" | pecl install redis
RUN docker-php-ext-enable redis
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-install soap
RUN pecl install memcached && docker-php-ext-enable memcached
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN docker-php-ext-install soap
RUN docker-php-ext-install sockets
RUN docker-php-ext-install gd

# Install rdkafka
RUN git clone https://github.com/edenhill/librdkafka

WORKDIR librdkafka
RUN ./configure
RUN make
RUN make install
RUN pecl install rdkafka && docker-php-ext-enable rdkafka
RUN cd ../ && rm -rf librdkaf

RUN apk del autoconf g++ libtool make
WORKDIR /app
