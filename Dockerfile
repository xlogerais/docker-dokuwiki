#
# Dockerfile for dokuwiki
#
FROM ubuntu:14.04

MAINTAINER Xavier Logerais <xavier@logerais.com>

ENV DEBIAN_FRONTEND noninteractive

ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data

ENV APACHE_SERVER_NAME  dokuwiki.exemple.com
ENV APACHE_SERVER_ADMIN admin@exemple.com

ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_LOCK_DIR  /var/run/apache2
ENV APACHE_PID_FILE  /var/run/apache2.pid

# Update apt database
RUN apt-get update

# Install some utilities
RUN apt-get install -y curl

# Install apache
RUN apt-get install -y apache2

# Install php
RUN apt-get install -y php5 php5-gd

# Activate needed modules
a2enmod rewrite
a2enmod php5

# Install Dokuwiki in /var/www/dokuwiki
RUN mkdir -p /var/www/dokuwiki && cd /var/www/dokuwiki && curl http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz | tar --verbose --extract --ungzip --strip-components=1

# Fix perms
RUN chown -R www-data /var/www/dokuwiki
RUN chgrp -R www-data /var/www/dokuwiki

# Ajust apache config
ADD apache2/dokuwiki.conf /etc/apache2/sites-available/dokuwiki.conf
RUN a2ensite dokuwiki
RUN a2dissite 000-default

# Expose apache listening port
EXPOSE 80

# Expose dokuwiki directory
VOLUME /var/www/dokuwiki

# Expose apache log dir
VOLUME /var/log/apache2

CMD /usr/sbin/apache2 -D FOREGROUND
#ENTRYPOINT ["/usr/sbin/apache2"]
#CMD ["-D", "FOREGROUND"]
