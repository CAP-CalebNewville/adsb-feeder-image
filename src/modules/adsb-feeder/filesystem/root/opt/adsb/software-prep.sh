#!/bin/bash

# while the user is getting ready, let's try to pull the ultrafeeder docker
# container in the background -- that way startup will feel quicker
cd /opt/adsb/config
if [ ! -f .env ] ; then
	cp /opt/adsb/docker.image.versions .env
	echo "_ADSBIM_BASE_VERSION=$(cat /opt/adsb/adsb.im.version)" >> .env
	echo "_ADSBIM_CONTAINER_VERSION=$(cat /opt/adsb/adsb.im.version)" >> .env
	echo "_ADSBIM_STATE_WEBPORT=1090" >> .env
fi
if [ ! -f /opt/adsb/feeder-image.name ] ; then
	echo "ADSB Feeder app" > /opt/adsb/feeder-image-name
fi
bash docker-pull.sh &

# this version does not enable the my.adsb.im trick as it will be running on
# a different port