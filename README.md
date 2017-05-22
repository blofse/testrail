# testrail - A dcoker image containing version 5.3.0.3603-ion53
A restartable docker image for testrail

Any feedback let me know - its all welcome!

# Pre-req

Before running this docker image, please [clone / download the repo](https://github.com/blofse/testrail), inlcuding the script files.

# How to use this image
## Initialise

Run the following command, replacing *** with your desired db password:
```
./initial_start.sh '***'
```
This will setup two containers: 
* testrail-mysql - a container to store your testrail db data
* testrail - the container containing the testrail server

## (optional) Migrating existing testrail servers

Shutdown the existing testrail server instance and backup the following:
* config.php modified during the install, possibly located in /var/www/html/testrail/config.php
* Mysqldump the existing testrail db into testrail.sql. An example is below:
	* mysqldump --databases testrail > testrail.sql
* Attachments and reports folder - usually found in /opt/testrail/attachments and /opt/testrail/reports, please place both folders inside a tar.gz containing the testrail directory.
The tar should be structured:
	* attachment-reports.tar.gz¬
		* testrail\
			* attachments\
			* reports\

Copy the files into the following locations, respective to the script file locations:
* imports/config.php
* imports/testrail.sql
* imports/attachment-reports.tar.gz

Once ready, run the following script, replacing *** with your db password:
```
./migrate_existing_db '***'
```

## (optional) setting up as a service

Once initialised and perhaps migrated, the docker container can then be run as a service. 
Included in the repo is the service for centos 7 based os's and to install run:
```
./copy_install_and_start_as_service.sh
```
