#!/bin/bash
set -e

if [ -n "$GC2_PASSWORD" ]; then
  sed -i "s/YOUR_PASSWORD/$GC2_PASSWORD/g" /var/www/geocloud2/app/conf/Connection.php
  exec "$@"
else
  echo '
        ****************************************************
        ERROR:   No password has been set for the GC2 user.
                 Use "-e GC2_PASSWORD=password" to set
                 it in "docker run".
        ****************************************************
        '
    exit 1
fi