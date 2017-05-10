#!/bin/sh

echo Stopping existing container
docker stop testrail
docker stop testrail-mysql

echo Copying and running service
yes | cp docker-testrail-mysql.service /etc/systemd/system/.
yes | cp docker-testrail.service /etc/systemd/system/. 

systemctl daemon-reload

echo Starting services
systemctl start docker-testrail-mysql
systemctl start docker-testrail

echo Done!
