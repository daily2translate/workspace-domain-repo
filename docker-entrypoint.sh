#!/bin/bash
set -e

# Configure Apache to listen on Render's PORT (default to 80 if not set)
export APACHE_PORT=${PORT:-80}

# Update Apache ports configuration
sed -i "s/Listen 80/Listen ${APACHE_PORT}/g" /etc/apache2/ports.conf
sed -i "s/:80/:${APACHE_PORT}/g" /etc/apache2/sites-available/000-default.conf

# Wait for database to be ready
echo "Waiting for database..."
until php -r "new PDO('pgsql:host=${WORDPRESS_DB_HOST};port=5432;dbname=${WORDPRESS_DB_NAME}', '${WORDPRESS_DB_USER}', '${WORDPRESS_DB_PASSWORD}');" 2>/dev/null; do
    echo "Database is unavailable - sleeping"
    sleep 2
done
echo "Database is ready!"

# Set up wp-config.php if it doesn't exist
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php for PostgreSQL..."

    # Copy sample config
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

    # Update database settings
    sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${WORDPRESS_DB_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${WORDPRESS_DB_HOST}/" /var/www/html/wp-config.php

    # Add PG4WP configuration before "That's all, stop editing!"
    sed -i "/That's all, stop editing/i\\
define('DB_TYPE', 'pgsql');\\
define('PG4WP_ROOT', ABSPATH . 'wp-content/plugins/pg4wp/');" /var/www/html/wp-config.php

    # Generate unique salts
    SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
    printf '%s\n' "g/put your unique phrase here/d" a "$SALT" . w | ed -s /var/www/html/wp-config.php
fi

# Install PG4WP plugin at runtime
if [ ! -d /var/www/html/wp-content/plugins/pg4wp ]; then
    echo "Installing PG4WP plugin..."
    cd /tmp
    git clone --depth 1 --branch v3 https://github.com/PostgreSQL-For-Wordpress/postgresql-for-wordpress.git pg4wp-temp
    mv pg4wp-temp /var/www/html/wp-content/plugins/pg4wp
    cd /
fi

# Copy PG4WP db.php to wp-content
if [ -f /var/www/html/wp-content/plugins/pg4wp/db.php ]; then
    cp /var/www/html/wp-content/plugins/pg4wp/db.php /var/www/html/wp-content/db.php
    echo "PG4WP db.php installed"
fi

# Execute the original WordPress entrypoint
exec docker-entrypoint.sh "$@"
