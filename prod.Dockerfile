# Use the official PHP image with FPM
FROM php:8.1-fpm

# Install system dependencies and utilities
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev procps net-tools nano \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy project source code into the container
COPY . .

RUN composer install --no-dev --optimize-autoloader

# Set permissions for the current directory
RUN chown -R www-data:www-data /var/www/html

# Generate the application key
RUN php artisan key:generate --ansi

# Clean config, route, cache
RUN php artisan config:clear \
    && php artisan route:clear \
    && php artisan cache:clear

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose the PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
