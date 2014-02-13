#!/usr/bin/env bash

# Provisioning script for Ubuntu boxes
# Script is run as privileged user so no need to sudo
# Remember to use non-interactive commands or pre-answer questions

# script is run by ssh user although cwd seems to be /home/vagrant
home_vagrant=/home/vagrant

# some may not be needed for different guest OSes
apt-get -y install curl
apt-get -y install vim
apt-get -y install screen
apt-get -y install python-dev # for pip install mercurial
apt-get -y install git
apt-get -y install exuberant-ctags
apt-get -y install unzip
apt-get -y install npm # nodejs + npm
apt-get -y install php5 # apache2 + php5 + extensions
apt-get -y install php5-json # needed for Composer
apt-get -y install php5-mcrypt # needed for Laravel

## php stuff
# install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
# mcrypt extension not enabled for CLI by default if using apt-get,
# Laravel installer checks mcrypt dependency through CLI
ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/cli/conf.d/mcrypt.ini


# get core config files
git clone https://github.com/pearpenguin/pearpenguin.github.io.git config
cp config/.vimrc $home_vagrant/.vimrc
cp config/.gitignore $home_vagrant/.gitignore

# configure git
git config --global user.name "Kenley Cheung"
git config --global user.email "winnt253@hotmail.com"
git config --global core.editor /usr/bin/vi
git config --global push.default simple
git config --global core.excludesfile $home_vagrant/.gitignore

# generate ssh key
ssh-keygen -t rsa -N "" -f $home_vagrant/.ssh/id_rsa

# setup python env
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python2 get-pip.py
python3 get-pip.py
rm get-pip.py # cleanup

# setup Google App Engine SDK
#wget http://googleappengine.googlecode.com/files/google_appengine_1.8.9.zip
#unzip google_app_engine_1.8.9.zip
# Add the SDK to PATH
#echo "export PATH=\$PATH:/$PWD/google_appengine" >> $home_vagrant/.bashrc




