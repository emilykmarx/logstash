#!/bin/bash

set -e

# This is just convenient for testing mysql stuff
# (and is half-notes, half-script).
# Installs mysql locally and creates a test table
# used in this commit's LS pipeline.

# download mysql here: https://dev.mysql.com/downloads/repo/apt/
sudo dpkg -i ./mysql-apt-config_0.8.29-1_all.deb
sudo apt-get update
sudo apt-get install mysql-server -y
sudo vim /etc/mysql/mysql.conf.d
# add skip-grant-tables
systemctl restart mysql
mysql -u root -p
  flush privileges;
  ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';
systemctl restart mysql
sudo vim /etc/mysql/mysql.conf.d
# remove skip-grant-tables
systemctl restart mysql
mysql -u root -p
  create database wtf_test_db;
  use wtf_test_db;
  create table wtf_test_table (col1 VARCHAR(20), col2 INT);
  insert into wtf_test_table values ('A', 1);
