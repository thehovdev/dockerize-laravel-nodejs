FROM php:7.0-apache
WORKDIR /var/www/html
COPY . /var/www/html
COPY ./vhost.conf /etc/apache2/sites-available/000-default.conf
RUN apt-get update && apt-get install -y \ 
libxml2-dev libc-client-dev libzip-dev \ 
zlib1g-dev libkrb5-dev libc-client-dev libkrb5-dev ca-certificates
RUN apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN printf "\n" | pecl install imagick
RUN docker-php-ext-install mysqli pdo_mysql soap zip gd exif \ 
&& docker-php-ext-enable imagick mysqli pdo_mysql soap zip \
&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl && apt-get clean
RUN a2enmod rewrite && service apache2 restart
RUN curl -S https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install && composer dump-autoload
EXPOSE 80 443