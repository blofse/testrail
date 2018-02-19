#!/bin/sh

rm /run/apache2/apache2.pid
/etc/init.d/apache2 start
sudo /usr/sbin/cron
sleep infinity
