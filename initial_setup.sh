#!/bin/bash

#the following commands are for start drupal and server configuration over
#vagrant virtual enviroment

echo "------------------------------------------------------------------------------"
echo "--"
echo "-- Apache and Drupal initial setup"
echo "--"
echo "-- @author Andrés Solano S <andres.solano@gmail.com>"
echo "------------------------------------------------------------------------------"
echo ""

if [ ! -d ~/provision ]; then
  echo ""
  echo ""
  echo ""
  echo "Initializing..."
  apt-get update
  apt-get install -y -V git
  ssh -oStrictHostKeyChecking=no -T git@github.com
fi


#define dir path
DIR="~/drupal-init-setup"

echo "Cloning provisioning"
rm -rf ~/drupal-init-setup
git clone git@github.com:ryttuo/drupal-init-setup.git $DIR

exit

if [ -d $DIR ]; then
  echo "setup apache and drupal"
  cd $DIR
  cp -r data /home/vagrant
  #rm -r $DIR

  #apache setup
  rm /etc/apache2/sites-enabled/*
  cd /etc/apache2/sites-available/
  cp /home/vagrant/data/sysadmin/apache/drupal.conf 001-drupal.conf
  cd ../sites-enabled/
  ln -s ../sites-available/001-drupal.conf .
  service apache2 restart

  #drupal setuo
  cd /home/vagrant/data/instances/news
  drush make news.make -y
  drush site-install minimal --account-name=admin --account-pass=admin --db-url=mysql://root:123456@localhost/news -y
  drush en aggregator contact dashboard field_ui file help image list number options menu path taxonomy -y
  drush en ctools memcache views views_ui features -y
else
  echo "Unable to setup the machine. Provision directory not found"
fi
