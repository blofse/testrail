# testrail
A restartable docker image for test rail

Any feedback let me know - its all welcome!

# Pre-req

Before running this docker image, please [clone / download the repo](https://github.com/blofse/testrail), inlcuding the script files.

# How to use this image
## (optional) Migrating existing testrail servers

Shutdown the existing testrail server instance and backup the following:
* config.php modified during the install, possibly located in /var/www/html/testrail/config.php
* Mysqldump the existing testrail db into testrail.sql. An example is below:
** mysqldump --databases testrail > testrail.sql

Please modify permissions of localhost within the testrail.sql to generally be % (all locations) except for below which should remain lower case:
```
INSERT INTO `proxies_priv` VALUES ('localhost','root','','',1,'boot@connecting host','0000-00-00 00:00:00');
```

Copy the files into the following locations, respective to the script file locations:
* imports/config.php
* imports/testrail.sql

## Initialise
If the above step has not been complete, then below will initialise with an empty testrail db, otherwise your existing TR instance should be migrated also with the command below.

Run the following command, replacing *** with your desired db password:
```
./initial_start '***'
```
This will setup two containers: 
* testrail-mysql - a container to store your testrail db data
* testrail - the container containing the testrail server

## (optional) setting up as a service

Once initialised and perhaps migrated, the docker container can then be run as a service. 
Included in the repo is the service for centos 7 based os's and to install run:
```
./copy_install_and_start_as_service.sh
```
