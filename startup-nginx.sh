#!/usr/bin/env sh

set -x

chown -R www-data:www-data /var/www/rutorrent
cp /rtorrent/.htpasswd /var/www/rutorrent/
mkdir -p /rtorrent/.rutorrent/torrents
chown -R www-data:www-data /rtorrent/.rutorrent
mkdir -p /rtorrent/.log/nginx
chown www-data:www-data /rtorrent/.log/nginx

rm -f /etc/nginx/sites-enabled/*

rm -rf /etc/nginx/ssl

rm /var/www/rutorrent/.htpasswd


# Basic auth enabled by default
site=rutorrent-basic.nginx

# Check if TLS needed
if [ -e /rtorrent/nginx.key ] && [ -e /rtorrent/nginx.crt ]; then
    mkdir -p /etc/nginx/ssl
    cp /rtorrent/nginx.crt /etc/nginx/ssl/
    cp /rtorrent/nginx.key /etc/nginx/ssl/
    site=rutorrent-tls.nginx
fi

cp /root/$site /etc/nginx/sites-enabled/
[ -n "$NOIPV6" ] && sed -i 's/listen \[::\]:/#/g' /etc/nginx/sites-enabled/$site
[ -n "$WEBROOT" ] && ln -s /var/www/rutorrent /var/www/rutorrent/$WEBROOT

# Check if .htpasswd presents
if [ -e /rtorrent/.htpasswd ]; then
    cp /rtorrent/.htpasswd /var/www/rutorrent/ && chmod 755 /var/www/rutorrent/.htpasswd && chown www-data:www-data /var/www/rutorrent/.htpasswd
else
# disable basic auth
    sed -i 's/auth_basic/#auth_basic/g' /etc/nginx/sites-enabled/$site
fi

nginx -g "daemon off;"

