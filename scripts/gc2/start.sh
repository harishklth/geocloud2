#!/bin/bash

daemonize=false

while getopts ":d:" opt; do
    case "$opt" in
    d)  daemonize=$OPTARG
        ;;
    esac
done

echo $daemonize

docker start postgis
docker start elasticsearch
docker start geoserver
docker start gc2core
until [ "`/usr/bin/docker inspect -f {{.State.Running}} gc2core`" == "true" ]; do
    sleep 0.1;
done;
docker start mapcache
docker start kibana
docker start logstash
docker start logstashforwarder
until [ "`/usr/bin/docker inspect -f {{.State.Running}} vidi`" == "true" ]; do
    sleep 0.1;
done;
docker exec vidi bash -c "cd /root/vidi && grunt"
docker exec vidi bash -c "/usr/bin/supervisorctl -c /etc/supervisor/conf.d/supervisord.conf restart vidi"

if [ $daemonize == true ]; then
    exit 0
fi

check () {
    flag=0
    if [[ "`/usr/bin/docker inspect -f {{.State.Running}} $1`" == "true" ]]
        then
                return 1
        else
                return 0
    fi
}

while true; do
    sleep 10;
    #echo "checking...";

    check postgis
    if [[ $? = 0 ]]
        then
                echo "postgis stopped";
                break;
    fi

    check elasticsearch
    if [[ $? = 0 ]]
        then
                echo "elasticsearch stopped";
                break;
    fi

    check geoserver
    if [[ $? = 0 ]]
        then
                echo "geoserver stopped";
                break;
    fi

    check gc2core
    if [[ $? = 0 ]]
        then
                echo "gc2Core stopped";
                break;
    fi

    check mapcache
    if [[ $? = 0 ]]
        then
                echo "mapcache stopped";
                break;
    fi
done