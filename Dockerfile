# Base image
FROM php:7.4-apache

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libxml2-dev \
        libicu-dev \
        libxslt-dev \
        libmcrypt-dev \
        zip \
        unzip \
        apache2

RUN docker-php-ext-install zip gd soap intl xsl opcache

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Remove default Apache configuration file
RUN rm /etc/apache2/sites-enabled/000-default.conf

# Copy Apache configuration file
COPY apache.conf /etc/apache2/sites-enabled/

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Copy application code
COPY . /var/www/html

# Copy environment files
# COPY .env.deploy /var/www/html/.env

# Set permissions for storage and bootstrap directories
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Install application dependencies
RUN composer install

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
