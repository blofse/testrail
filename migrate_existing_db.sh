#!/bin/bash

if [[ $# -eq 0 ]] ; then
  echo 'Expecting one argument'
  exit 0
fi

if [ ! -f imports/testrail.sql ]; then
  echo File imports/testrail.sql not found, please export your existing Testrail into this file for import
  exit 0
fi

if [ ! -f imports/config.php ]; then
  echo File imports/config.php not found, please export your existing Testrail config.php into this file for import
  exit 0
fi

docker exec -i testrail-mysql mysql -u root --password="$1" < imports/testrail.sql

echo Copying, replacing, importing then deleting config.php for testrail
cp imports/config.php .
sed -i 's~!!!!~'$1'~g' config.php
docker cp config.php testrail:/var/www/html/testrail/config.php
rm config.php

if [ -f imports/attachment-reports.tar.gz ]; then
  echo Uploading and expanding attachments and reports
  docker cp imports/attachment-reports.tar.gz testrail:/opt/attachment-reports.tar.gz
  docker exec -i testrail tar -xzvf "/opt/attachment-reports.tar.gz" -C /opt
  docker exec -i -u root testrail chown -R www-data /opt/testrail/
fi

echo Done!
