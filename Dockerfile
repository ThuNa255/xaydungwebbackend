FROM php:8.4-cli

WORKDIR /var/www

# Cài đặt các thư viện hệ thống và driver cho MySQL (pdo_mysql)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install zip pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

# Cài đặt Laravel dependencies
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# Cấp quyền cho thư mục
RUN chmod -R 775 storage bootstrap/cache

# Sửa dòng EXPOSE (Railway sẽ tự quản lý, nhưng để $PORT cho chuẩn)
EXPOSE 8080

# Sửa lệnh CMD để nhận biến PORT từ hệ thống
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8080}