#!/usr/bin/env sh

set -x

MEM=${PHP_MEM:=512M}

sed -i 's/memory_limit.*$/memory_limit = '$MEM'/g' /etc/php/7.4/fpm/php.ini

mkdir /run/php
php-fpm7.4 --nodaemonize

