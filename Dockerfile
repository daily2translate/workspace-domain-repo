FROM wordpress:latest

# Install additional PHP extensions for PostgreSQL
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && rm -rf /var/lib/apt/lists/*

# Install PG4WP plugin for PostgreSQL support
RUN curl -L https://downloads.wordpress.org/plugin/pg4wp.latest.zip -o /tmp/pg4wp.zip \
    && unzip /tmp/pg4wp.zip -d /usr/src/wordpress/wp-content/plugins/ \
    && rm /tmp/pg4wp.zip

# Set up WordPress environment variables
ENV WORDPRESS_DB_HOST=${WORDPRESS_DB_HOST}
ENV WORDPRESS_DB_USER=${WORDPRESS_DB_USER}
ENV WORDPRESS_DB_PASSWORD=${WORDPRESS_DB_PASSWORD}
ENV WORDPRESS_DB_NAME=${WORDPRESS_DB_NAME}

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
