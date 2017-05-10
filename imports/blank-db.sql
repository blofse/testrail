CREATE DATABASE testrail DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

CREATE USER 'testrail'@'localhost' IDENTIFIED BY 'testrail';
GRANT ALL ON testrail.* TO 'testrail'@'localhost';

CREATE USER 'testrail'@'%' IDENTIFIED BY 'testrail';
GRANT ALL ON testrail.* TO 'testrail'@'%';

