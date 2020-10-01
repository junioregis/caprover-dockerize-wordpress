FROM wordpress:5.5.1-php7.4

COPY root/ /var/www/html/
COPY wp-content/ /var/www/html/wp-content/