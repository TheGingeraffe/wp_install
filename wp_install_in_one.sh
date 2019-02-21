#!/bin/bash

read -ep "Target directory for WordPress installation: " TARGET;

confirm="Are you sure you would like to install WordPress in $TARGET?"
confirm="$confirm Files in $TARGET may be overwritten! (y/n): "

read -ep "$confirm" CONFIRMATION;

cd $TARGET

wget https://wordpress.org/latest.tar.gz
tar -xf latest.tar.gz
mv -f wordpress/* $(pwd) && \
rm -rf $(pwd)/wordpress/

read -ep "mySQL username? " MYSQL_USER;

read -sp "mySQL password? " MYSQL_PASS;
read -sp "Re-enter mySQL password: " MYSQL_PASS2;

uapi Mysql create_user \
name="$(whoami)_$MYSQL_USER" password="$MYSQL_PASS" && \

read -ep "mySQL database name? " MYSQL_DB;

uapi Mysql create_database \
name="$(whoami)_$MYSQL_DB" && \

uapi Mysql set_privileges_on_database \
user="$(whoami)_$MYSQL_USER" database="$(whoami)_$MYSQL_DB" privileges='ALL PRIVILEGES'

cp $(pwd)/wp-config-sample.php $(pwd)/wp-config.php
sed -i "s/username_here/$(whoami)_$MYSQL_USER/g" $(pwd)/wp-config.php
sed -i "s/password_here/$MYSQL_PASS/g" $(pwd)/wp-config.php
sed -i "s/database_name_here/$(whoami)_$MYSQL_DB/g" $(pwd)/wp-config.php

