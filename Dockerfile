FROM php:5.6-apache

RUN apt-get update -yqq && apt-get install -y -qq sqlite3 libsqlite3-dev\
    libmcrypt-dev \
    curl \
    zlib1g-dev \
    nodejs \
    npm \
    git \
    libmemcached-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng12-dev


RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd intl zip mysqli mcrypt
RUN curl -L http://pecl.php.net/get/memcache-3.0.8.tgz >> /usr/src/php/ext/memcache.tgz
RUN tar -xf /usr/src/php/ext/memcache.tgz -C /usr/src/php/ext/
RUN rm /usr/src/php/ext/memcache.tgz
RUN docker-php-ext-install memcache-3.0.8
RUN touch /usr/local/etc/php/conf.d/timezone.ini
RUN echo "date.timezone = Europe/Paris;" >> /usr/local/etc/php/conf.d/timezone.ini
RUN ln -s /usr/bin/nodejs /usr/bin/node
# Install composer
RUN curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
