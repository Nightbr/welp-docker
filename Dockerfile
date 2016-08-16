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

# Install php extensions
# install xdebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.var_display_max_data=2048" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.var_display_max_depth=128" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.max_nesting_level=200" >> /usr/local/etc/php/conf.d/xdebug.ini \
# install other extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd intl zip mysqli mcrypt mbstring
# Configure timezone
RUN touch /usr/local/etc/php/conf.d/timezone.ini
RUN echo "date.timezone = Europe/Paris;" >> /usr/local/etc/php/conf.d/timezone.ini
# Memory Limit
RUN echo "memory_limit=2G;" >> /usr/local/etc/php/conf.d/memory-limit.ini
# node legacy fix
RUN ln -s /usr/bin/nodejs /usr/bin/node
# Install composer
RUN curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
