#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Expecting one argument'
    exit 0
fi

docker run --name testrail-mysql -e MYSQL_ROOT_PASSWORD="$1" -e MYSQL_DATABASE="testrail" -e MYSQL_USER="testrail" -e MYSQL_PASSWORD="$1" -v TestrailMysqlData:/var/lib/mysql -d mysql:5.7

echo About to sleep to give the server time to start up
sleep 15
echo Sleep over, now starting testrail container
docker run -d --name testrail --link testrail-mysql:testrail -p 7070:80 -v TestrailAttachmentsReports:/opt/testrail testrail

echo Done!
