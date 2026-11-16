# iMX9 OSM yocto-bsp-repo Manifests 11/2026

## Download yocto-bsp-repo [REMOTE: eGF Github]
repo init -u https://github.com/elettronicagf/manifests.git -b iMX9-OSM-6.6.y-scarthgap -m imx9-osm-6.6.y.xml

repo sync


## First initialization of YOCTO environment (for i.MX93)
MACHINE=imx93-jfn0937-aa06aa1-usd DISTRO=mas-imx-xwayland source mas-setup-release.sh -b build

## Next YOCTO initialization
source setup-environment build
