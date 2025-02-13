FROM wordpress:6.7.1-php8.1-apache

ENV TZ=America/Lima

WORKDIR /var/www/html

USER root

RUN apt-get update && apt-get install -y wget unzip less mariadb-client \
    && apt-get install -y libapache2-mod-security2 \
    && a2enmod headers \
    && a2enmod ssl \
    && a2enmod rewrite \
    && a2enmod remoteip \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /usr/src/wp-plugins && chown -R www-data:www-data /usr/src/wp-plugins

USER www-data

WORKDIR /usr/src/wp-plugins
RUN curl -O https://downloads.wordpress.org/plugin/wordfence.8.0.3.zip && \
    curl -O https://downloads.wordpress.org/plugin/sucuri-scanner.1.9.8.zip && \
    curl -O https://downloads.wordpress.org/plugin/limit-login-attempts-reloaded.2.26.17.zip && \
    curl -O https://downloads.wordpress.org/plugin/all-in-one-wp-security-and-firewall.5.3.8.zip && \
    curl -O https://downloads.wordpress.org/plugin/wps-hide-login.1.9.17.1.zip && \
    curl -O https://downloads.wordpress.org/plugin/updraftplus.1.25.1.zip

WORKDIR /var/www/html
RUN unzip -o "/usr/src/wp-plugins/wordfence.8.0.3.zip" -d /var/www/html/wp-content/plugins/ && \
    unzip -o "/usr/src/wp-plugins/sucuri-scanner.1.9.8.zip" -d /var/www/html/wp-content/plugins/ && \
    unzip -o "/usr/src/wp-plugins/limit-login-attempts-reloaded.2.26.17.zip" -d /var/www/html/wp-content/plugins/ && \
    unzip -o "/usr/src/wp-plugins/all-in-one-wp-security-and-firewall.5.3.8.zip" -d /var/www/html/wp-content/plugins/ && \
    unzip -o "/usr/src/wp-plugins/wps-hide-login.1.9.17.1.zip" -d /var/www/html/wp-content/plugins/ && \
    unzip -o "/usr/src/wp-plugins/updraftplus.1.25.1.zip" -d /var/www/html/wp-content/plugins/ 

USER root
RUN rm -rf /usr/src/wp-plugins

COPY wordpress/setup.sh /usr/local/bin/setup.sh
COPY wordpress/configure-plugins.sh /usr/local/bin/configure-plugins.sh
COPY wordpress/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY wordpress/modsecurity.conf /etc/modsecurity/modsecurity.conf
COPY wordpress/.htaccess /var/www/html/.htaccess
COPY wordpress/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN mkdir -p /var/www/html/wp-content/uploads
RUN mkdir -p /var/www/html/wp-content/aiowps_backups
RUN mkdir -p /var/www/html/wp-content/wflogs
RUN mkdir -p /var/www/html/wp-content/uploads/aios/firewall-rules

RUN chown -R www-data:www-data /var/www/html/wp-content \
    && chmod -R 755 /var/www/html/wp-content \
    && chown -R www-data:www-data /var/www/html/wp-content/uploads \
    && chmod -R 755 /var/www/html/wp-content/uploads \
    && chown -R www-data:www-data /var/www/html/wp-content/plugins \
    && chmod -R 755 /var/www/html/wp-content/plugins \
    && chown -R www-data:www-data /var/www/html/wp-content/themes \
    && chmod -R 755 /var/www/html/wp-content/themes \
    && chown -R www-data:www-data /var/www/html/wp-content/wflogs \
    && chmod -R 755 /var/www/html/wp-content/wflogs \
    && chown -R www-data:www-data /var/www/html/wp-content/aiowps_backups \
    && chmod -R 755 /var/www/html/wp-content/aiowps_backups \
    && chown -R www-data:www-data /var/www/html/wp-content/uploads/aios/firewall-rules \
    && chmod -R 755 /var/www/html/wp-content/uploads/aios/firewall-rules \
    && touch /var/www/html/.htaccess_temp \
    && chown www-data:www-data /var/www/html/.htaccess_temp \
    && chmod 664 /var/www/html/.htaccess_temp

RUN a2enmod security2 && \
    echo "SecRuleEngine On" >> /etc/apache2/mods-enabled/security2.conf

RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.revalidate_freq=2" >> /usr/local/etc/php/conf.d/opcache.ini

RUN chmod +x /usr/local/bin/setup.sh /usr/local/bin/configure-plugins.sh /usr/local/bin/docker-entrypoint.sh 

RUN rm -rf /var/www/html/readme.html /var/www/html/license.txt

RUN chown www-data:www-data /var/www/html/.htaccess && chmod 644 /var/www/html/.htaccess

RUN mkdir -p /var/www/html/wp-content/themes/tema-blog
COPY wordpress/blog /var/www/html/wp-content/themes/tema-blog
RUN chown -R www-data:www-data /var/www/html/wp-content/themes/tema-blog

USER www-data

EXPOSE 80 443

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]