# Use the official PHP image
FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY . .

# Set permissions for storage and bootstrap/cache
RUN chown -R www-data:www-data /var/www/html
#RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
#    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Create and set permissions for the log file
#RUN touch /var/www/html/storage/logs/laravel.log \
#    && chown www-data:www-data /var/www/html/storage/logs/laravel.log \
#    && chmod 664 /var/www/html/storage/logs/laravel.log

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Generate the application key
RUN php artisan key:generate

RUN php artisan config:clear \
    && php artisan route:clear \
    && php artisan view:clear

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]


# Install system dependencies
#RUN apt-get update && apt-get install -y \
#        zip \
#        unzip \
#        git \
#        curl \
#        libpng-dev \
#        libonig-dev \
#        libxml2-dev \
#        && docker-php-ext-install \
#        pdo_mysql \
#        mbstring \
#        exif \
#        pcntl \
#        bcmath \
#        gd
#
## Install Composer
#COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer
#
#
#
## Set permissions
#RUN #chown -R www-data:www-data /var/www/html
#
#RUN mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views storage/logs bootstrap/cache \
#    && chown -R www-data:www-data storage bootstrap/cache \
#    && chmod -R 775 storage bootstrap/cache
#
#RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
#    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
#
#
#
#RUN composer install --no-dev --optimize-autoloader

