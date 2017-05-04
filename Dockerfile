FROM alpine

ENV IONCUBE_VERSION=6.0.9

# Setup apache and php
RUN \ 
  apk --update add php5 apache2 php5-apache2 curl php5-cli php5-mysql php5-curl wget unzip \
  && rm -f /var/cache/apk/* \
  && mkdir /run/apache2 \
  && sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' /etc/apache2/httpd.conf \
  && mkdir -p /opt/utils

RUN wget -O ioncube_loaders_lin_x86-64_${IONCUBE_VERSION}.tar.gz --no-verbose "http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64_${IONCUBE_VERSION}.tar.gz" && \
    tar vxfz ioncube_loaders_lin_*.tar.gz && \
    rm -f ioncube_loaders_lin_*.tar.gz

RUN \
  sed -i 's~;zend.script_encoding\ =~zend_extension=/ioncube/ioncube_loader_lin_5.6.so~' /etc/php5/php.ini

COPY testrail-*.zip /
RUN cd /var/www/localhost/htdocs && unzip -q /testrail-*.zip

RUN adduser -D -S -u 1000 www-data

RUN \
  mkdir /var/www/localhost/htdocs/testrail/logs \
  && chown www-data /var/www/localhost/htdocs/testrail/logs \
  && echo '* * * * * www-data /usr/bin/php /var/www/localhost/htdocs/testrail/task.php' > /etc/crontabs/testrail
    
COPY config.php /var/www/localhost/htdocs/config.php
COPY run.sh /

RUN chmod +x run.sh

ENTRYPOINT ["/run.sh"]
