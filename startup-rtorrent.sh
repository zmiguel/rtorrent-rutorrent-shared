#!/usr/bin/env sh

set -x

# set rtorrent user and group id
RT_UID=${USR_ID:=1000}
RT_GID=${GRP_ID:=1000}

# update uids and gids
groupadd -g $RT_GID rtorrent
useradd -u $RT_UID -g $RT_GID -d /home/rtorrent -m -s /bin/bash rtorrent

# arrange dirs and configs
mkdir -p /rtorrent/.session 
mkdir -p /rtorrent/watch
mkdir -p /rtorrent/log
if [ ! -e /rtorrent/.rtorrent.rc ]; then
    cp /root/.rtorrent.rc /rtorrent/
fi
ln -s /rtorrent/.rtorrent.rc /home/rtorrent/
chown -R rtorrent:rtorrent /rtorrent
chown -R rtorrent:rtorrent /home/rtorrent
chown -R rtorrent:rtorrent /rtorrent/log

rm -f /rtorrent/session/rtorrent.lock

# run
su --login --command="TERM=xterm rtorrent" rtorrent 

