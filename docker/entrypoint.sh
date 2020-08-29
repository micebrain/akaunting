#!/bin/sh

cd /var/www/akaunting
php artisan migrate --no-interaction

[[ "0${APP_HOSTNAME}" == "0"]] && APP_HOSTNAME="localhost"
sed "s/%APP_HOSTNAME%/${APP_HOSTNAME}/" /tmp/akaunting.conf > /etc/nginx/conf.d/akaunting.conf
# exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
exec "$@"
