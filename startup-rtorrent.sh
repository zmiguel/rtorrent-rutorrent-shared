#!/usr/bin/env sh

set -x

# set rtorrent user and group id
RT_UID=${USR_ID:=1000}
RT_GID=${GRP_ID:=1000}

# update uids and gids
groupadd -g $RT_GID rtorrent
useradd -u $RT_UID -g $RT_GID -d /home/rtorrent -m -s /bin/bash rtorrent

# arrange dirs and configs
mkdir -p /config/rut/.session 
mkdir -p /config/rut/watch
mkdir -p /config/log/rut
if [ ! -e /config/rut/.rtorrent.rc ]; then
    cp /root/.rtorrent.rc /config/rut/
fi
ln -s /config/rut/.rtorrent.rc /home/rtorrent/
chown -R rtorrent:rtorrent /config/rut
chown -R rtorrent:rtorrent /home/rtorrent
chown -R rtorrent:rtorrent /config/log/rut

rm -f /config/rut/.session/rtorrent.lock

# run
su --login --command="TERM=xterm rtorrent" rtorrent 

