# 使用官方 PHP 8.1 Apache 镜像（满足 PHP >= 8.0 要求）
FROM php:8.1-apache

# 安装常见的 PHP 扩展（数据库、图像处理、压缩包等）
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        zip \
        unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli zip

# 开启 Apache 伪静态模块（完美兼容自带的 .htaccess 文件）
RUN a2enmod rewrite

# 将项目代码复制到网站根目录
COPY . /var/www/html/

# 设置正确的目录权限
RUN chown -R www-data:www-data /var/www/html/
