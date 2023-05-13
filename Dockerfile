# Menggunakan gambar resmi PHP dengan versi yang diinginkan
FROM php:7.4-apache

# Memperbarui daftar paket dan menginstal dependensi yang diperlukan
RUN apt-get update && \
    apt-get install -y \
    libzip-dev \
    unzip \
    && docker-php-ext-install zip

# Menyalin kode aplikasi ke dalam direktori kerja di dalam container
COPY . /var/www/html

# Mengatur direktori kerja
WORKDIR /var/www/html

# Menjalankan perintah composer install untuk menginstal dependensi
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Menjalankan perintah-perintah yang Anda berikan
RUN php artisan make:migration create_products_table --create=products
RUN php artisan migrate
RUN php artisan make:controller ProductController --resource --model=Product

# Mengatur port yang akan digunakan oleh aplikasi Laravel
EXPOSE 8000

# Menjalankan server Apache saat container dijalankan
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
