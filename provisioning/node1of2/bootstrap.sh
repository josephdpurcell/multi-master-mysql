#!/bin/bash
# Node 1 of 2 provisioning
DIR=$1

DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server mysql-client

cp $DIR/etc/mysql/my.cnf /etc/mysql/my.cnf
sudo chmod 644 /etc/mysql/my.cnf
sudo service mysql restart
mysqladmin -u root password pass

# replicate node 1 to node 2
echo "GRANT REPLICATION SLAVE ON *.* TO 'replicator'@'%' IDENTIFIED BY 'pass';
FLUSH PRIVILEGES;
CREATE DATABASE twitter;
USE twitter;
CREATE TABLE twitter.users (
    id INTEGER(255) UNSIGNED AUTO_INCREMENT,
    name varchar(255),
    email varchar(255),
    created_at TIMESTAMP DEFAULT '0000-00-00 00:00:00',
    modified_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    UNIQUE KEY (email),
    PRIMARY KEY (id)
);" | mysql -u root -ppass

# replicate node 2 to node 1
echo "STOP SLAVE;
CHANGE MASTER TO MASTER_HOST='10.0.0.102',MASTER_USER='replicator', MASTER_PASSWORD='pass';
START SLAVE;" | mysql -u root -ppass

touch /tmp/provisioned

# INSERT INTO `twitter`.`users` (`created_at`, `name`, `email`) VALUES (null, 'Joe', 'joe@example.com');
# INSERT INTO `twitter`.`users` (`created_at`, `name`, `email`) VALUES (null, 'Bob', 'bob@example.com');
# SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1; SLAVE START; 
# SHOW SLAVE STATUS\G
