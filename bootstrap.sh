#!/usr/bin/env bash

#yum -y update
#yum groupinstall  -y 'development tools'
yum install -y epel-release
yum install -y nodejs
yum install -y git
yum install -y libcurl-devel 
yum install -y vim-X11 vim-common vim-enhanced vim-minimal

# install ImageMagick
yum install -y  ImageMagick ImageMagick-devel

# install rvm 
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm reload
rvm install 2.2.1

gem install bundler rails
gem install capistrano
gem install passenger -v '=5.0.6'

passenger-install-nginx-module --languages ruby

sudo useradd -s /sbin/nologin -r nginx
sudo useradd deploy 

# set up ssh
DEPLOY_SSH_HOME='/home/deploy/.ssh'
mkdir $DEPLOY_SSH_HOME
touch $DEPLOY_SSH_HOME/authorized_keys
cat /vagrant/id_rsa.pub > $DEPLOY_SSH_HOME/authorized_keys
chmod 700 $DEPLOY_SSH_HOME
chmod 600 $DEPLOY_SSH_HOME/authorized_keys
chown -R deploy:deploy $DEPLOY_SSH_HOME
 
sudo groupadd web
sudo usermod -a -G web nginx
sudo usermod -a -G web vagrant
sudo usermod -a -G web deploy
sudo usermod -a -G root deploy
sudo mkdir /var/www
sudo chgrp -R web /var/www
sudo chmod -R 775 /var/www
sudo chown -R deploy:deploy /var/www

# sudoer file
cat /vagrant/sudoers > /etc/sudoers

# add nginx management file
touch /etc/rc.d/init.d/nginx
cat /vagrant/nginx_management > /etc/rc.d/init.d/nginx
cat /vagrant/nginx.conf > /opt/nginx/conf/nginx.conf
chmod +x /etc/rc.d/init.d/nginx
chown -R deploy:deploy /opt/nginx
#chown -R deploy:deploy /var/lock/subsys/nginx

