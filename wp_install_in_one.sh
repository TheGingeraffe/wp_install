#!/bin/bash

read -ep "Target directory for WordPress installation: " TARGET;

confirm="Are you sure you would like to install WordPress in $TARGET?"
confirm="$confirm Files in $TARGET may be overwritten! (y/n): "

read -ep "$confirm" CONFIRMATION;

cd $TARGET

wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv -f wordpress/* $TARGET && \
rm -rf wordpress/

read -ep "mySQL username? " MYSQL_USER;
read -ep "mySQL password? " MYSQL_PASS;

uapi Mysql create_user \
name="$MYSQL_USER" password="$MYSQL_PASS" && \

read -ep "mySQL database name? " MYSQL_DB;

uapi Mysql create_database \
name="$(whoami)_$MYSQL_DB" && \

uapi Mysql set_privileges_on_database \
user="$MYSQL_USER" database="$MYSQL_DB" privileges='ALL PRIVILEGES'


