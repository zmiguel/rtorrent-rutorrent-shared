#!/usr/bin/env sh

set -x

# set rtorrent user and group id
RT_UID=${USR_ID:=1000}
RT_GID=${GRP_ID:=1000}

# update uids and gids
groupadd -g $RT_GID rtorrent
useradd -u $RT_UID -g $RT_GID -d /home/rtorrent -m -s /bin/bash rtorrent

# arrange dirs and configs
mkdir -p /config/rt/.session 
mkdir -p /config/rt/watch
mkdir -p /config/log/rt
if [ ! -e /config/rt/.rtorrent.rc ]; then
    cp /root/.rtorrent.rc /config/rt/
fi
ln -s /config/rt/.rtorrent.rc /home/rtorrent/
chown -R rtorrent:rtorrent /config/rt
chown -R rtorrent:rtorrent /home/rtorrent
chown -R rtorrent:rtorrent /config/log/rt

rm -f /config/rt/.session/rtorrent.lock

# run
su --login --command="TERM=xterm rtorrent" rtorrent 

