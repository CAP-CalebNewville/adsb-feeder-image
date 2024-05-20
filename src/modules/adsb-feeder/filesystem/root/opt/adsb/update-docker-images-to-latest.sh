#!/bin/bash
#
# update the docker images to the latest "latest-build-xxx" instead of the pinned versions

NOW=$(date -Iseconds)
cd /opt/adsb || { echo "can't cd to /opt/adsb"; exit 1; }
cp docker.image.versions "docker.image.versions.${NOW}"
cd /opt/adsb/config || { echo "can't cd to /opt/adsb/config"; exit 1; }
cp .env "env.${NOW}"

for container_line in $(grep "_CONTAINER=" /opt/adsb/config/.env); do
	image=$(echo $container_line | cut -d= -f2 | cut -d: -f1)
	(echo "$image" | {
		IFS='/' read -r x user container
		if [[ $user == "sdr-enthusiasts" ]] ; then
			latestbuild=$(curl -shttps://fredclausen.com/imageapi//api/v1/images/byname/${container}/recommended | jq '.images[]|.tag')
			sed -i "s|${image}|ghcr.io/${user}/${container}:${latestbuild}|" /opt/adsb/config/.env
			sed -i "s|${image}.*|ghcr.io/${user}/${container}:${latestbuild}|" /opt/adsb/docker.image.versions
			echo "ghcr.io/sdr-enthusiasts/$container:$latestbuild"
		fi
	})
done
