#!/usr/bin/env sh

set -x

MEM=${PHP_MEM:=512M}

sed -i 's/memory_limit.*$/memory_limit = '$MEM'/g' /etc/php/8.0/fpm/php.ini

mkdir /run/php
php-fpm8.0 --nodaemonize

