#!/bin/sh

cd /var/www/akaunting
php artisan migrate --no-interaction

# exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
exec "$@"
