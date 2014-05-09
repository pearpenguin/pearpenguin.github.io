#!/usr/bin/env bash

# Provisioning script for Ubuntu boxes
# Script is run as privileged user so no need to sudo
# Remember to use non-interactive commands or pre-answer questions
# (use debconf-set-selections?)

# script is run by ssh user although cwd seems to be /home/vagrant
home_dir=/home/vagrant
# directory to checkout pearpenguin.github.io (contains configs + scripts)
pearpenguin=/vagrant/pearpenguin.github.io

# Arbitrary configs
db_pass=root

# update sources
apt-get update

# get packages (some may not be needed for different guest OSes)
apt-get -y install curl
apt-get -y install vim
apt-get -y install tmux
apt-get -y install python-dev # for pip install mercurial
apt-get -y install git
apt-get -y install exuberant-ctags
apt-get -y install unzip
apt-get -y install npm # nodejs + npm
# php5 + modules
apt-get -y install php5 # apache2 + php5
apt-get -y install php5-json php5-mcrypt php5-curl php5-gd php5-intl

# databases
# pre-answer set password questions
echo mysql-server mysql-server/root_password password $dbpass | debconf-set-selection
echo mysql-server mysql-server/root_password_again password $dbpass | debconf-set-selection
apt-get -y install mysql-server
apt-get -y install php5-mysql # mysql module for php5
#apt-get -y install sqlite3

# get core config files
git clone https://github.com/pearpenguin/pearpenguin.github.io.git $pearpenguin
cp $pearpenguin/.vimrc $home_dir/.vimrc
cp $pearpenguin/.gitignore $home_dir/.gitignore

# configure git
git config --global user.name "Kenley Cheung"
git config --global user.email "winnt253@hotmail.com"
git config --global core.editor /usr/bin/vi
git config --global push.default simple
git config --global core.excludesfile $home_dir/.gitignore

# generate ssh key
ssh-keygen -t rsa -N "" -f $home_dir/.ssh/id_rsa

# setup python env
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python2 get-pip.py
python3 get-pip.py
rm get-pip.py # cleanup

# setup Google App Engine SDK
appengine=google_appengine_1.8.9
#wget http://googleappengine.googlecode.com/files/${appengine}.zip
#unzip ${appengine}.zip -d /vagrant
# Add the SDK to PATH
#echo "export PATH=\$PATH:/vagrant/google_appengine" >> $home_dir/.bashrc

## php stuff
# config php settings (max upload, max size, other limits)
##
# install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
# mcrypt extension ini not included, this is a known bug
ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/cli/conf.d/mcrypt.ini
ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/apache2/conf.d/mcrypt.ini
# Start blank projects for various frameworks
# Setup databases
mysql -u root -p$db_pass < $pearpenguin/setup-db.sql
# Wordpress
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz -C /vagrant
# Must point to wp-admin/install.php to finish setup.
# dbname=wordpress, user=wordpress, password=root, host=localhost
# Laravel
composer create-project laravel/laravel laravel-test --prefer-dist
# Symfony (check config with web/config.php)
#composer create-project symfony/framework-standard-edition symfony-test
# TODO: Symfony also asks for db config, find a way to pre-answer
# Concrete5
concrete5=concrete5.6.2.1
wget http://www.concrete5.org/download_file/-/view/64359/8497/ #5.6.2.1
unzip ${concrete5}.zip -d /vagrant
mv /vagrant/$concrete5 /vagrant/concrete5
# Point web browser to concrete5 to install
# Drupal
drupal=drupal-7.26
wget http://ftp.drupal.org/files/projects/${drupal}.tar.gz
tar -xvzf ${drupal}.tar.gz -C /vagrant
mv /vagrant/$drupal /vagrant/drupal
cd /vagrant/drupal/sites/default
cp default.settings.php settings.php # make default drupal settings file

# Fetch apache2 conf from pearpenguin
cp $pearpenguin/etc/apache2/sites-available/all.conf /etc/apache2/sites-available/all.conf
# Enable all sites
cd /etc/apache2/sites-enabled
ln -s ../sites-available/all.conf all.conf
# Create log dirs
cd /var/log/apache2
mkdir wordpress laravel symfony concrete5 drupal


