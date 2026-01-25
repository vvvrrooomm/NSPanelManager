#!/bin/bash

mkdir -p data


if [ ! -e "data/nspanelmanager_db.sqlite3" ] && [ -e "$(pwd)/web/nspanelmanager/db.sqlite3" ]; then
	cp "$(pwd)/web/nspanelmanager/db.sqlite3" "data/nspanelmanager_db.sqlite3"
fi

if [ ! -e "data/secret.key" ] && [ -e "$(pwd)/web/nspanelmanager/secret.key" ]; then
	cp "$(pwd)/web/nspanelmanager/secret.key" "data/secret.key"
fi

docker build -t nspanelmanager -f Dockerfile.martin  --target development . 
docker rm -f nspanelmanager
docker run --name nspanelmanager  -v "../:/workspace"  -v "$(pwd)/data/":"/data/" -v "$(pwd)/MQTTManager:/MQTTManager" -v "$(pwd)/web:/web" -d -p 8006:8000 -p 8007:8001 nspanelmanager sleep 2d
# workspace: to compile protobuf cd /workspace/docker/protobuf
# MWTTManager: cd /MQTTManager; ./compile_all.sh
