# Use PHP 8.1
FROM php:8.1-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy Laravel project files
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html

# Generate APP_KEY
RUN php artisan key:generate --ansi

# Clear Laravel cache
RUN php artisan config:clear \
    && php artisan route:clear \
    && php artisan cache:clear

# Start PHP-FPM
CMD ["php-fpm"]
