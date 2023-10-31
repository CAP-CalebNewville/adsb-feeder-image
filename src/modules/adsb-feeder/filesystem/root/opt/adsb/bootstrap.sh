#!/bin/bash

# while the user is getting ready, let's try to pull the ultrafeeder docker
# container in the background -- that way startup will feel quicker

# this needs to run as root
if [ $(id -u) != "0" ] ; then
	echo "this command requires superuser privileges - please run as sudo bash $0"
	exit 1
fi

mkdir -p /opt/adsb/config
cd /opt/adsb/config
if [ ! -f .env ] ; then
	cp /opt/adsb/docker.image.versions .env
	echo "_ADSBIM_BASE_VERSION=$(cat /opt/adsb/adsb.im.version)" >> .env
	echo "_ADSBIM_CONTAINER_VERSION=$(cat /opt/adsb/adsb.im.version)" >> .env
fi
bash /opt/adsb/docker-pull.sh &

# get the local IP address
IP=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')

# slightly different approach in the rare cases where the first one fails
[[ -z "$IP" ]] && IP=$(ip route get 8.8.8.8 | sed -nr 's/^.* src ([0-9.]*).*/\1/p;q')

# this gets stopped and disabled by the setup app
while true; do
    curl "https://my.adsb.im/adsb-feeder.html?lip=${IP}" > /dev/null 2>&1
    sleep 60
done &
