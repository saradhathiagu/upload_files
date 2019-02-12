#! /bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function buildCloudPortalBackend()
{
    cd $BASEDIR/6_Cloud_Web_Portal_Routing_Method/uav-solar-panel/uav-solar-panel/backend
    bash build.sh buildbase
    bash build.sh build
}

function buildCloudPortalFrontend()
{
    cd $BASEDIR/6_Cloud_Web_Portal_Routing_Method/uav-solar-panel/uav-solar-panel/frontend
    bash build.sh buildbase
    bash build.sh build
}

#buildCloudPortalBackend
#buildCloudPortalFrontend
#https://www.mapbox.com/mapbox-gl-js/example/simple-map/

function build6thModule(){
	cd $BASEDIR/6_Cloud_Web_Portal_Routing_Method/uav-solar-panel/uav-solar-panel/
	export PYTHONPATH=$(pwd)/backend/prototype
	export IMG_ROOT=/usr/src/app/data
	export GSD_IR=0.0375
	export MONGO_HOST=localhost
        export BRAND=/spi/sungrow
	cd backend/prototype/spi_app
	python3 -m spi_app
}

build6thModule
