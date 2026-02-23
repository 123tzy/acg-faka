FROM php:8.1-apache

# 1. 安装项目所需的 PHP 扩展
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        zip \
        unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli zip

# 2. 开启 Apache 伪静态模块（必须开启，否则前台页面会 404）
RUN a2enmod rewrite

# 3. 将 Apache 监听端口改为 8080（完美适配你的 Zeabur 网络设置）
RUN sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 4. 【关键修复】启用 .htaccess 文件支持
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# 5. 复制源码到网站根目录
COPY . /var/www/html/

# 6. 赋予正确的读写权限
RUN chown -R www-data:www-data /var/www/html/
