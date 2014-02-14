#!/usr/bin/env bash

# Provisioning script for Ubuntu boxes
# Script is run as privileged user so no need to sudo
# Remember to use non-interactive commands or pre-answer questions
# (use debconf-set-selections?)

# script is run by ssh user although cwd seems to be /home/vagrant
home_vagrant=/home/vagrant
# directory to checkout pearpenguin.github.io (contains configs + scripts)
pearpenguin=config

# Arbitrary configs
db_pass=root

# update sources
apt-get update

# get packages (some may not be needed for different guest OSes)
apt-get -y install curl
apt-get -y install vim
apt-get -y install screen
apt-get -y install python-dev # for pip install mercurial
apt-get -y install git
apt-get -y install exuberant-ctags
apt-get -y install unzip
apt-get -y install npm # nodejs + npm
# php5 + modules
apt-get -y install php5 # apache2 + php5
apt-get -y install php5-json # needed for Composer
apt-get -y install php5-mcrypt # needed for Laravel
# databases
# pre-answer set password questions
echo mysql-server mysql-server/root_password password $dbpass | debconf-set-selection
echo mysql-server mysql-server/root_password_again password $dbpass | debconf-set-selection
apt-get -y install mysql-server
apt-get -y install php5-mysql # mysql module for php5
apt-get -y install sqlite3

# get core config files
git clone https://github.com/pearpenguin/pearpenguin.github.io.git $pearpenguin
cp $pearpenguin/.vimrc $home_vagrant/.vimrc
cp $pearpenguin/.gitignore $home_vagrant/.gitignore

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

## php stuff
# install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
# mcrypt extension not enabled for CLI by default if using apt-get,
# Laravel installer checks mcrypt dependency through CLI
ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/cli/conf.d/mcrypt.ini
# Start blank projects for various frameworks
# Wordpress
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz -C /vagrant
mysql -u root -p$db_pass < $pearpenguin/wp-setup-db.sql
# Must point to wp-admin/install.php to finish setup.
# dbname=wordpress, user=wordpress, password=root, host=localhost
# Laravel
composer create-project laravel/laravel laravel-test --prefer-dist
# Symfony
composer create-project symfony/framework-standard-edition symfony-test
# TODO: Symfony also asks for db config, find a way to pre-answer

# TODO: apache conf (virtual hosts for php stuffs)



