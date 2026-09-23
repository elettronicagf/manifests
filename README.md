# iMX9 OSM yocto-bsp-repo Manifests 09/2026


## Download yocto-bsp-repo [LOCAL: PD compiling server]
repo init -u /home/repo-shared/manifests/yocto-manifests.git -b iMX9-OSM-6.6.y -m imx9-osm-6.6.y-local.xml 
 
repo sync


## Download yocto-bsp-repo [REMOTE: eGF Gitlab]
repo init -u git@gitrepo.egf.it:egf/egf-pd/repo-shared/manifests/yocto-manifests.git -b iMX9-OSM-6.6.y -m imx9-osm-6.6.y-remote.xml 
 
repo sync


## First initialization of YOCTO environment from local repo
BASEURL=remote MACHINE=imx93-jfn0937-aa06aa0-usd DISTRO=mas-imx-xwayland source mas-setup-release.sh -b build

## First initialization of YOCTO environment from remote repo
BASEURL=local MACHINE=imx93-jfn0937-aa06aa0-usd DISTRO=mas-imx-xwayland source mas-setup-release.sh -b build

## Next YOCTO initialization
source setup-environment build
