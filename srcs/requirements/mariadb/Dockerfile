FROM alpine:3.20.6

# Install MariaDB and dependencies
RUN apk update && apk add mariadb mariadb-client mariadb-common bash

# Create necessary directories and set permissions
RUN mkdir -p /run/mysqld && \
    mkdir -p /var/log/mysql && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/log/mysql

# Copy MariaDB configuration and entrypoint script
COPY tools/my.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/mariadb-entrypoint.sh /usr/local/bin

# Make entrypoint script executable
RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

# Use the entrypoint script to start MariaDB
ENTRYPOINT ["mariadb-entrypoint.sh"]

