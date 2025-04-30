#!/bin/bash
set -e

if [ ! -e /etc/.firstrun ]; then
    cat << EOF >> /etc/my.cnf.d/mariadb-server.cnf
[mysqld]
bind-address=0.0.0.0
skip-networking=0
EOF
    touch /etc/.firstrun
fi

#initialization mariadb
if [ ! -e /var/lib/mysql/.firstmount ]; then
    # Initialize a database on the volume and start MariaDB in the background
    mysql_install_db --datadir=/var/lib/mysql --skip-test-db --user=mysql --group=mysql \
    --auth-root-authentication-method=socket >/dev/null 2>/dev/null
    mysqld_safe &
    mysqld_pid=$!

    # Wait for the server to be started, then set up database and accounts
    echo "Initializing MariaDB data directory..."
    until mysqladmin ping -u root --silent --wait >/dev/null 2>/dev/null; do
        sleep 1
    done
    echo "MariaDB started. Setting up users and database..."

    cat << EOF | mysql --protocol=socket -u root

CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
GRANT ALL PRIVILEGES on *.* to 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;

EOF

    # Shut down the temporary server and mark the volume as initialized
    echo "Database setup complete. Shutting down temporary instance..."
    mysqladmin shutdown
    touch /var/lib/mysql/.firstmount
    echo "First-time setup completed."
fi

echo "Starting MariaDB server..."
exec mysqld_safe


