#!/bin/sh

echo Stopping existing container
docker stop $(docker ps -a -q  --filter ancestor=testrail)

echo Copying and running service
yes | cp docker-testrail.service /etc/systemd/system/. && systemctl daemon-reload
systemctl start docker-testrail
echo Done!
