FROM alpine:3.20.6

RUN apk update && apk add mariadb-client \
	php83 \
	php83-fpm \
	php83-phar \
	php83-curl \
	php83-mysqli \
	php83-iconv \
	php83-json \
	wget 

COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

RUN mkdir -p /var/www/wp /var/www/html

COPY ./tools/wordpress-script.sh /usr/local/bin/wordpress-script.sh
RUN chmod +x /usr/local/bin/wordpress-script.sh 

RUN adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data

EXPOSE 9000

CMD ["wordpress-script.sh"]
