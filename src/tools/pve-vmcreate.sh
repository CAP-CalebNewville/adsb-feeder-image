#!/bin/bash

IMG=$(ls adsb-feeder*.img)
SIZE="16G"
POOL="local-lvm:0"
while (( $# ))
do
        case $1 in
                '-i') shift; IMG=$1;;
                '-s') shift; SIZE=$1;;
		'-p') shift; POOL=$1;;
                *) echo "Invalid argument \"$1\", aborting..."; exit 1;;
        esac
        shift
done

# pick a free number for the VM and prepare the directory for it
VMID=$(pvesh get /cluster/nextid)
mkdir -p /data/images/$VMID

# create a random mac address
MAC=$(printf '1A:67:30:%02X:%02X:%02X\n' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256])

# mv the image into place and make sure it's the right size
fallocate -l $SIZE adsb-feeder.img
dd if=$IMG of=adsb-feeder.img bs=16M conv=notrunc

qm create $VMID \
   -cores 2 \
   -description "ADSB Feeder image https://adsb.im/home" \
   -memory 1024 \
   -name adsb-feeder \
   -ostype l26 \
   -sata0 ${POOL},import-from=$PWD/adsb-feeder.img \
   -boot order=sata0 \

