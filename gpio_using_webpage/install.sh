#!/bin/bash

# considering /var/www/ is the web server root directory
cp -r sh/ /var/www/

chown root /var/www/sh/php_shell.sh
chmod u=rwx,go=xr /var/www/sh/php_shell.sh

gcc /var/www/sh/wrapper.c -o /var/www/sh/php_root
chown root /var/www/sh/php_root
chmod u=rwx,go=xr,+s /var/www/sh/php_root 

