#!/bin/bash

echo "What is the full subdomain you wish to create? (ex. sub.test.com)"

read SUB

sudo mkdir /srv/www/$SUB
sudo mkdir /srv/www/$SUB/logs
sudo mkdir /srv/www/$SUB/public_html
sudo touch /srv/www/$SUB/logs/access.log
sudo touch /srv/www/$SUB/logs/error.log

echo "$SUB folder structure created"

echo "Creating /etc/nginx/sites-availabl/$SUB"

echo "#
#
# $SUB (/etc/nginx/sites-available/$SUB)
#
server {
    listen    8081;
    server_name $SUB;
    access_log /srv/www/$SUB/logs/access.log;
    error_log /srv/www/$SUB/logs/eror.log;

    location / {
        root    /srv/www/$SUB/public_html;
        index   index.html index.htm;
    }
}">/etc/nginx/sites-available/$SUB

echo "Successfully created /etc/nginx/sites-available/$SUB"

echo "chown'ing newly created subdomain directories"
sudo chown -R root:www-data /srv/www/$SUB/

echo "Would you like to enable $SUB? (yes or no)"

read enableOpt
if [ $enableOpt = "yes" ]; then
    ln -s /etc/nginx/sites-available/$SUB /etc/nginx/sites-enabled
elif [ $enableOpt = "no" ]; then
    echo "$SUB was not enabled at this time, please run 'ln -s /etc/nginx/sites-available/$SUB /etc/nginx/sites-enabled' to enable it later."
fi

echo "Would you like to restart nginx? (Required for a newly enabled site)"

read reloadOpt
if [ $reloadOpt = "yes" ]; then
    echo "Restarting nginx now..."
    sudo /etc/init.d/nginx restart
elif [ $reloadOpt = "no" ]; then
    echo "Please restart nginx when you feel like it then..."
fi

echo "Enjoy your new domain! Don't forget to setup DNS. Please restart varnish cache too."
