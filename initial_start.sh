#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Expecting one argument'
    exit 0
fi

docker run --name testrail-mysql -e MYSQL_ROOT_PASSWORD="$1" -d mysql:5.7
echo About to sleep to give the server time to start up
sleep 15
echo Sleep over, now performing initial db setup
docker exec -i testrail-mysql mysql -u root --password="$1" < imports/blank-db.sql

if [ -f imports/testrail.sql ]; then
  echo File imports/testrail.sql found, importing existing data
  docker exec -i testrail-mysql mysql -u root --password="$1" < testrail.sql
fi

echo Starting testrail container
docker run -d --name testrail --link testrail-mysql:testrail -p 7070:80 testrail

echo Done!
