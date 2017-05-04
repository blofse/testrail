FROM ubuntu:trusty

ENV IONCUBE_VERSION=6.0.9

RUN apt-get update \
    && apt-get install -y --no-install-recommends php5 php5-cli php5-mysql php5-curl \
    && apt-get install -y --no-install-recommends curl unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64_${IONCUBE_VERSION}.tar.gz \
    && tar vxfz ioncube_loaders_lin_x86-64_${IONCUBE_VERSION}.tar.gz \
    && rm -f ioncube_loaders_lin_x86-64_${IONCUBE_VERSION}.tar.gz

RUN \
  sed -i 's~;zend.script_encoding\ =~zend_extension=/ioncube/ioncube_loader_lin_5.5.so~' /etc/php5/cli/php.ini \
  && sed -i 's~;zend.script_encoding\ =~zend_extension=/ioncube/ioncube_loader_lin_5.5.so~' /etc/php5/apache2/php.ini

COPY testrail-*.zip /
RUN cd /var/www/html && unzip -q /testrail-*.zip

# RUN adduser -D -S -u 1000 www-data

RUN \
  mkdir /var/www/html/testrail/logs \
  && chown www-data /var/www/html/testrail/logs \
  && echo '* * * * * www-data /usr/bin/php /var/www/html/testrail/task.php' > /etc/cron.d/testrail
    
COPY config.php /var/www/html/testrail/config.php
COPY run.sh /

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
