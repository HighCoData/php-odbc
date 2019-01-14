FROM php:latest

RUN apt-get update -yqq && \
    apt-get install git libcurl4-gnutls-dev libzip-dev libicu-dev libmcrypt-dev libvpx-dev libjpeg-dev libpng-dev libxpm-dev zlib1g-dev libfreetype6-dev libxml2-dev libexpat1-dev libbz2-dev libgmp3-dev libldap2-dev unixodbc-dev libpq-dev libsqlite3-dev libaspell-dev libsnmp-dev libpcre3-dev libtidy-dev odbcinst odbcinst1debian2 libodbc1 unixodbc-dev wget curl software-properties-common zip unzip sudo gnupg -yqq
RUN docker-php-source extract;
RUN mv /usr/src/php/ext/odbc/config.m4 /usr/src/php/ext/odbc/orig.m4
COPY patch.m4 /usr/src/php/ext/odbc/config.m4
RUN cat /usr/src/php/ext/odbc/orig.m4 >> /usr/src/php/ext/odbc/config.m4
RUN docker-php-ext-configure odbc --with-unixODBC=shared,/usr && \
    docker-php-ext-install odbc && \
    docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr && \
    docker-php-ext-install pdo_odbc && \
    docker-php-ext-enable pdo_odbc && \
    docker-php-source delete
RUN docker-php-ext-install pcntl mbstring pdo_mysql curl json intl gd xml zip bz2 opcache


