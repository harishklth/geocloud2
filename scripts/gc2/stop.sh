#!/bin/bash

docker stop postgis
docker stop elasticsearch
docker stop gc2core
docker stop mapcache
docker stop kibana
docker stop logstash
docker stop filebeat