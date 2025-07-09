# Bắt đầu từ Ubuntu 22.04
FROM ubuntu:22.04

# Tránh nhập thủ công khi cài đặt
ENV DEBIAN_FRONTEND=noninteractive

# Cập nhật & cài công cụ cần thiết
RUN apt-get update && apt-get install -y \
    nginx software-properties-common curl gnupg2 lsb-release wget unzip tar

# Thêm PPA PHP 8.3
RUN add-apt-repository ppa:ondrej/php && \
    apt-get update

# Cài PHP 8.3 và các extension Moodle cần
RUN apt-get install -y \
    php8.3-fpm \
    php8.3-common \
    php8.3-mbstring \
    php8.3-xmlrpc \
    php8.3-soap \
    php8.3-gd \
    php8.3-xml \
    php8.3-intl \
    php8.3-mysql \
    php8.3-cli \
    php8.3-zip \
    php8.3-curl \
    php8.3-opcache \
    php8.3-readline \
    php8.3-bcmath

# Gỡ Apache nếu tồn tại
RUN apt-get remove -y apache2 || true

# Copy config PHP riêng
COPY moodle.ini /etc/php/8.3/fpm/conf.d/moodle.ini
COPY moodle.ini /etc/php/8.3/cli/conf.d/moodle.ini

# Copy source code Moodle và config
# COPY moodle/ /var/www/html/
# COPY --chown=www-data:www-data moodle/ /var/www/html
# COPY config.php /var/www/html/config.php
COPY --chown=www-data:www-data moodle/ /var/www/html/
COPY --chown=www-data:www-data config.php /var/www/html/config.php

# Tạo thư mục moodledata và các thư mục tạm
RUN mkdir -p /tmp/moodledata \
    /tmp/moodle-cache \
    /tmp/moodle-temp \
    /tmp/moodle-localcache && \
    chown -R www-data:www-data /tmp/moodledata /tmp/moodle-* && \
    chmod -R 777 /tmp/moodledata /tmp/moodle-*

# Copy nginx config
COPY nginx/default.conf /etc/nginx/sites-available/default

# Copy entrypoint và script tạo env
COPY entrypoint.sh /entrypoint.sh
COPY init-env.sh /init-env.sh
RUN chmod +x /entrypoint.sh /init-env.sh

# Mở cổng 8080 (Nginx)
EXPOSE 8080

# CMD: Chạy PHP-FPM, Nginx và gọi entrypoint script
CMD service php8.3-fpm start && \
    service nginx start && \
    /entrypoint.sh
