Changes since v2.2.2 include:
- reduce some verbosity / log export fix ipv6
- make sure we don't have disk based swap around when using swap on zram due to race condition
- cache adsb.im status query
- don't run nightly apt update, this runs with the nightly OS update when enabled
- nightly adsb.im update: only run the updater if new version is available
- stage2 add microfeeder: honor bandwidth reduce checkbox
- fix dietpi OS update
- OS update consistency button / nightly
- message / position rate status page changes / fix for micro / nano feeders
- move swap on zram script to its own service
- fixup stage2 combined stats (broken in beta.7)
- added position / message rate to non-stage2 setups status page
- fix missing log for docker compose up
- inform users of docker compose up failure and offer retry button
- only notify of ipv6 issues when docker compose fails
- add ipv6 issue to support info page and log upload
- multioutline: hopefully user invisble changes under the hood
- update DietPi images to be 9.8 based
- update Raspberry Raspbian base image to 2024-10-22 image
- fix nightly updates to actually be nightly instead of hourly
- aggregator status: various tweaks / polishing
- aggregator status: autorefresh fix
- fix collectd messages when running in VM (missing temp sensor)
- don't check IPv6 addresses with non-global scope
- automatically refresh the aggregator status on feeder home page
- several stylistic changes and better explanations for feeder home page and backup page
- hide some of the feeder homepage connectivity matrix legends by default
- add note about SkyAware map not working by default
- add improved alert for non-working ipv6
- change heywhatsthat outline to non-dashed to improve map performance when zoomed in
- fix esoteric error during key request process
- Piaware: reduce memory footprint - this disables the Piaware map (but then... we have the much better tar1090 map)
- update Piaware container: watchdog added for very rare TLS piaware hang; show location in FA map; faster startup of data flow in container
- fix timezone configuration for dietpi app installs
- aggregator status check: report if container down / recently started
- consistently allow spaces in sitenames (spaces replaced with underscore for MLAT name)
- radarbox: update station number when share key changes / up container version
- eliminate some minor writes from radarvirtuel, adsbhub, radar1090uk containers

> [!NOTE]
> Based on the available usage information, I have significantly reduced the number of images provided here. If there's one that you need for a different SBC which is supported either by Armbian or DietPi, please post a request on the [Zulip server](https://adsblol.zulipchat.com/#narrow/stream/391168-adsb-feeder-image)

> [!WARNING]
> Images can take more than 5 minutes before the web interface is available. Please be patient.

> [!NOTE]
> Currently the Odroid image and the default LePotato images do NOT support WiFi. For the default Raspberry Pi image (but not the new Raspbian image for LePotato), WiFi can be configured with the Pi Imager when you write the image to SD-card, DietPi based images do support WiFi, but they require editing two files on the DOS partition included with the image BEFORE the first boot. Please look at the [adsb.im FAQ](https://adsb.im/faq) for details.
> Alternatively, if there is no network connection detected, all WiFi enabled images will create a hotspot named `adsb.im-feeder`. You can then connect to that hotspot and set up SSID/password of the access point you want the feeder to connect to.

For Raspberry Pis there are multiple images available. For most users the Raspbian based `adsb-im-raspberrypi64-pi-2-3-4-5-v....img.xz` is likely the best choice, but there are also two DietPi based images available for those who prefer that.



