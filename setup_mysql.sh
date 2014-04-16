#!/bin/bash
set -e

#Run mysql user
chown -R mysql:mysql /var/lib/mysql

#Start mysqld 
/etc/init.d/mysqld start &
MYSQL_PID=$!
wait $MYSQL_PID

#Setup MYSQL
MYSQL_COMMAND="mysql -uroot mysql -e"

$MYSQL_COMMAND "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'  WITH GRANT OPTION;"
$MYSQL_COMMAND "CREATE DATABASE your_database ;"
$MYSQL_COMMAND "FLUSH PRIVILEGES;"

