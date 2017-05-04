FROM alpine

ENV IONCUBE_VERSION=6.0.9

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Setup apache and php
RUN \ 
  apk update && apk upgrade \
  && apk add --no-cache apache2 \
  && apk add --no-cache php7-apache2 php7-mysqli php7-curl php7-mbstring \
  && apk add --no-cache curl wget unzip \
  && rm -f /var/cache/apk/* \
  && mkdir /run/apache2 \
  && sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' /etc/apache2/httpd.conf \
  && mkdir -p /opt/utils

RUN wget -O ioncube_loaders_lin_x86-64_${IONCUBE_VERSION}.tar.gz --no-verbose "http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64_${IONCUBE_VERSION}.tar.gz" && \
    tar vxfz ioncube_loaders_lin_*.tar.gz && \
    rm -f ioncube_loaders_lin_*.tar.gz

RUN \
  sed -i 's~;zend.script_encoding\ =~zend_extension=/ioncube/ioncube_loader_lin_7.0.so~' /etc/php7/php.ini

COPY testrail-*.zip /
RUN cd /var/www/localhost/htdocs && unzip -q /testrail-*.zip

RUN adduser -D -S -u 1000 www-data

RUN \
  mkdir /var/www/localhost/htdocs/testrail/logs \
  && chown www-data /var/www/localhost/htdocs/testrail/logs \
  && echo '* * * * * www-data /usr/bin/php /var/www/localhost/htdocs/testrail/task.php' > /etc/crontabs/testrail
    
COPY config.php /var/www/localhost/htdocs/config.php
COPY run.sh /

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
