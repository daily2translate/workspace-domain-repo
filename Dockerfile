FROM wordpress:latest

# Install additional PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Set up WordPress
ENV WORDPRESS_DB_HOST=${DATABASE_URL}
ENV WORDPRESS_DB_USER=wordpress
ENV WORDPRESS_DB_PASSWORD=wordpress
ENV WORDPRESS_DB_NAME=wordpress

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
