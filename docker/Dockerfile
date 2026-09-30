FROM php:8.4-fpm

# 1️⃣ Dépendances système nécessaires à GD et extensions PHP
RUN apt update \
    && apt install -y \
        git g++ zip \
        libicu-dev \
        libzip-dev \
        libpq-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
    \
    # 2️⃣ Configuration + compilation de GD (OBLIGATOIRE)
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    \
    # 3️⃣ Compilation des extensions PHP
    && docker-php-ext-install \
        intl \
        opcache \
        pdo \
        pdo_pgsql \
        pgsql \
        zip \
        gd \
    \
    # 4️⃣ Extensions PECL
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    \
    # 5️⃣ Nettoyage
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# 6️⃣ Xdebug compatible PHP 8.4
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode = coverage" > /usr/local/etc/php/conf.d/zz-xdebug-mode.ini

# 7️⃣ Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY php/php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html
