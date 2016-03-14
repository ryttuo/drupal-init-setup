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

#reset terminal for weird characters
reset

#define dir path
DIR='/root/drupal-init-setup'

echo "Cloning drupal initial setup"
rm -rf $DIR
git clone https://github.com/ryttuo/drupal-init-setup.git $DIR

if [ -d $DIR ]; then
  echo "setup apache and drupal"
  cd $DIR
  cp -r data /home/vagrant
  rm -r $DIR

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
