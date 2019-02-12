#! /bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BASE_IMAGENAME=api:base;
IMAGENAME=solar_panel_2;

function remove()
{
if [ "$(docker ps -aq)" ];then
docker rm $(docker ps -aq)
fi
if [ " $(docker images -f dangling=true -q) " ];then
docker rmi $(docker images -f dangling=true -q)
fi


	if [ "$(docker ps -q -f name=api:base)" ]; then
    	docker rm -fv api:base
    	echo 'Container removed.'
	else
		if [ "$(docker ps -aq -f name=api:base)" ]; then
        	docker rm api:base
        	echo 'Container removed.'
    	fi
	fi

	if [ "$(docker ps -q -f name=solar_panel_2)" ]; then
    	docker rm -fv solar_panel_2
	else
		if [ "$(docker ps -aq -f name=solar_panel_2)" ]; then
        	docker rm -fv solar_panel_2
    	fi
	fi
}

function clean()
{
	remove
	 if [ "$(docker images -q ${BASE_IMAGENAME})" ]; then
            docker rmi -f $BASE_IMAGENAME
        fi
	if [ "$(docker images -q ${BASE_IMAGENAME})" ]; then
	    docker rmi -f $BASE_IMAGENAME
	fi
        if [ "$(docker images -q ${IMAGENAME})" ]; then
            docker rmi -f $IMAGENAME
        fi
	if [ "$(docker images -q ${IMAGENAME})" ]; then
	    docker rmi -f $IMAGENAME
	fi
}

function buildServerStub()
{
	if [ "$(docker images -q ${BASE_IMAGENAME})" ]; then
		clean
	fi
	if [ "$(docker images -q ${IMAGENAME})" ]; then
		clean
	fi
    cd $BASEDIR/1_Solar_Panel_Web_Portal/web-app/server-stub
    docker build  --no-cache -f Dockerfile.base -t $BASE_IMAGENAME .
    docker build -t $IMAGENAME .
    docker-compose down && docker-compose build --no-cache && docker-compose up -d
}

function buildnginx()
{
    cd $BASEDIR/1_Solar_Panel_Web_Portal/web-app/nginx
    bash build.sh build
    bash build.sh run
}

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
forever stop 1_Solar_Panel_Web_Portal/web-app/front-end/node_modules/@angular/cli/bin/ng
buildServerStub
buildnginx
cd $BASEDIR/1_Solar_Panel_Web_Portal/web-app/front-end
forever start node_modules/@angular/cli/bin/ng serve --host 0.0.0.0 --prod


#buildCloudPortalBackend
#buildCloudPortalFrontend
#forever start node_modules/@angular/cli/bin/ng serve --host 0.0.0.0 --prod
#forever stop 1_Solar_Panel_Web_Portal/web-app/front-end/node_modules/@angular/cli/bin/ng
# front-end/src/app/check-management/check-detail/check-detail.service   - defects to defect -     return this.http.get(Const.BACKEND_API_ROOT_URL + '/api/v1/station/' + stationId + '/date/' + date + '/defect?' + params.join('&')).map((res:Response) => {
# working url http://10.79.162.105:5000/spi/sungrow/api/v1/station/LN0001/date/2017-09-19/defect?category=1
# front-end/src/app/check-management/checkoverview/check-overview.service - status to station/status    getCheckOverviewInfo():Observable<Response> { return this.http.get(Const.BACKEND_API_ROOT_URL + '/api/v1/station/status').map
#   percent = Math.ceil(json.healthy/(json.healthy + json.infix + json.confirmed + json.toconfirm)); to   json.bad =  json.infix;json.toconfirm = item.status.tocomfirm;json.infix = item.status.tofix; percent = Math.ceil(json.healthy/(json.healthy + json.infix + json.toconfirm));
#  in src/app/shared/translator.service.ts this._default = translate.getBrowserLang(); to  this._default = 'en';  this.translate.use('en' || this.translate.getDefaultLang());
# check-detail-service.ts return this.http.get(Const.BACKEND_API_ROOT_URL + '/api/v1/station/' + stationId + '/date/' + date + '/defect/' + defectId + '/images/ir').map((res:Response) => {
#docker exec -ti server-stub_api_1 /bin/sh
