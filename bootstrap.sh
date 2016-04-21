#!/usr/bin/env bash

apt-get update
apt-get -y install git

## Setup mysql Katana specific setup
debconf-set-selections <<< 'mysql-server mysql-server/root_password password notsecretpassword'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password notsecretpassword'
apt-get -y install -qq mysql-server
apt-get -y install -qq mysql-workbench

## The user account for the katana user is: myuser/mypassword
mysql -uroot -pnotsecretpassword < /vagrant/katanasetup.sql

apt-get -y install -qq libsasl2-dev libmysqlclient-dev libldap2-dev libssl-dev python-dev python-pip python-virtualenv
