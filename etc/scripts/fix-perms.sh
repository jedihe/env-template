#!/bin/bash

echo "Setting ownership for repo dir..."
cd /var/www/html/
chown $HOST_UID:www-data repo

echo "Setting ownership for everything under repo dir..."
cd repo
chown -R $HOST_UID:www-data .* *

echo "Setting permissions for everything under repo dir..."
# See https://www.drupal.org/node/244924#linux-servers
find . -type d -exec chmod u=rwx,g=rx,o= '{}' \;
find . -type f -exec chmod u=rw,g=r,o= '{}' \;

echo "Allowing www-data to write to files+private dirs"
chmod g+w sites/default/files
chmod g+w sites/default/files/private
