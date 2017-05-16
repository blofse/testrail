FROM ubuntu:trusty

ENV IONCUBE_VERSION=6.0.9

RUN apt-get update
RUN apt-get install -y --no-install-recommends php5 php5-cli php5-mysql php5-curl
RUN apt-get install -y --no-install-recommends curl unzip
RUN rm -rf /var/lib/apt/lists/*

RUN curl -O http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64_${IONCUBE_VERSION}.tar.gz
RUN tar vxfz ioncube_loaders_lin_x86-64_${IONCUBE_VERSION}.tar.gz
RUN rm -f ioncube_loaders_lin_x86-64_${IONCUBE_VERSION}.tar.gz

RUN sed -i 's~;zend.script_encoding\ =~zend_extension=/ioncube/ioncube_loader_lin_5.5.so~' /etc/php5/cli/php.ini
RUN sed -i 's~;zend.script_encoding\ =~zend_extension=/ioncube/ioncube_loader_lin_5.5.so~' /etc/php5/apache2/php.ini

COPY testrail-*.zip /
RUN cd /var/www/html && unzip -q /testrail-*.zip

RUN mkdir /var/www/html/testrail/logs
RUN chown www-data /var/www/html/testrail/logs
RUN echo '* * * * * www-data /usr/bin/php /var/www/html/testrail/task.php' > /etc/cron.d/testrail

COPY run.sh /

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
