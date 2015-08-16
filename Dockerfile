FROM ubuntu:12.04
MAINTAINER Raffael Tancman <@rtancman>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y apache2 apache2.2-common --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y apg
RUN apt-get install -y sudo
RUN apt-get install -y vim 
RUN apt-get update && apt-get install -y curl libxml2 autoconf file gcc libc-dev make pkg-config re2c --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN mkdir -p /usr/local/www/data-dist && \
    mkdir -p /usr/local/www/app-dist && \
    mkdir -p /usr/local/www/workcopy && \
    mkdir -p /var/www/html/workcopy && \
    mkdir -p /var/www/html/personareyii && \
    mkdir -p /var/www/html/yiihoroscopoetc && \
    mkdir -p /var/www/html/phpbb && \
    mkdir -p /var/www/html/admin && \
    mkdir -p /var/www/html/yiicore && \
    mkdir -p /var/www/html/portal-client

RUN ln -sFf /var/www/html/workcopy /usr/local/www/data-dist/workcopy  && \
    ln -sFf /var/www/html/personareyii /usr/local/www/data-dist/personareyii  && \
    ln -sFf /var/www/html/yiihoroscopoetc /usr/local/www/data-dist/yiihoroscopoetc && \
    ln -sFf /var/www/html/admin /usr/local/www/data-dist/admin  && \
    ln -sFf /var/www/html/yiicore /usr/local/www/data-dist/yiicore  && \
    ln -sFf /var/www/html/portal-client /usr/local/www/workcopy/portal-client && \
    ln -sFf /var/www/html/phpbb /usr/local/www/app-dist/phpbb

RUN rm -rf /var/www/html && mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html && chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html
RUN mkdir -p /etc/apache2/certs/ && mkdir -p /etc/apache2/vhosts/
RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.dist 
COPY apache2/apache2.conf /etc/apache2/apache2.conf

RUN apt-get update && apt-get install -y php5 php5-cli php-pear php5-dev php5-gd php5-memcache php5-memcached php5-xsl php5-geoip php-soap php5-imap php5-curl php5-intl php5-mysql php5-xdebug php-apc libapache2-mod-php5 php5-mcrypt

# Apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APP_DOCUMENT_ROOT /var/www

ADD apache2/apache2 /usr/local/sbin/apache2
RUN chmod 755 /usr/local/sbin/apache2
RUN a2enmod headers
RUN a2enmod expires
RUN a2enmod ssl
RUN a2enmod rewrite
RUN sed -i "s/^\\( *export \+LANG.*\\)/#\\1/" /etc/apache2/envvars

RUN usermod -u 1000 www-data

RUN chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /usr/local/www/

ENV HOME /var/www/html
WORKDIR /var/www/html

EXPOSE 80
CMD ["/usr/local/sbin/apache2"]