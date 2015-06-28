FROM ubuntu:trusty
MAINTAINER Preecha Patumcharoenpol <yumyai@gmail.com>

# Install packages
#ADD sources.list /etc/apt/sources.list
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor git apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc curl && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin && mv /usr/local/bin/composer.phar /usr/local/bin/composer
RUN sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini

#RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

# Add SSH

# Configure application
RUN git clone https://github.com/nlplab/brat /brat

ADD files/config.py /brat/config.py
RUN mkdir -p /brat/data
RUN mkdir -p /brat/work
RUN chown www-data:www-data /brat/data
RUN chown www-data:www-data /brat/work
RUN chmod 777 -R /brat
ADD files/brat.conf /etc/apache2/sites-available/brat.conf
RUN a2dissite 000-default
RUN a2ensite brat
RUN a2enmod cgi

RUN rm -fr /var/www/html && ln -s /brat /var/www/html

# I don't know why this was commented
VOLUME ["/brat/data", "/brat/work"]

EXPOSE 80

# Add image configuration and scripts
ADD files/start.sh /start.sh
ADD files/run.sh /run.sh
RUN chmod 755 /*.sh
ADD files/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
CMD ["/run.sh"]
