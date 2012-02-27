#!/bin/bash

echo "Domain to create without www (ex. text.com)"

read DOMAIN
wwwDOMAIN="www.$DOMAIN"

sudo mkdir /srv/www/$DOMAIN
sudo mkdir /srv/www/$DOMAIN/logs
sudo mkdir /srv/www/$DOMAIN/public_html
sudo touch /srv/www/$DOMAIN/logs/access.log
sudo touch /srv/www/$DOMAIN/logs/error.log

echo "$DOMAIN folder structure created"

echo "Creating /etc/nginx/sites-available/$DOMAIN"

echo "#
#
# $DOMAIN (/etc/nginx/sites-available/$DOMAIN)
#
server {
    listen    80;
    server_name $wwwDOMAIN $DOMAIN;
    access_log /srv/www/$DOMAIN/logs/access.log;
    error_log /srv/www/$DOMAIN/logs/eror.log;

    location / {
        root    /srv/www/$DOMAIN/public_html;
        index   index.html index.htm;
    }
}">/etc/nginx/sites-available/$DOMAIN

echo "Successfully created /etc/nginx/sites-available/$DOMAIN"

echo "Would you like to enable $DOMAIN? (yes or no)"

read enableOpt
if [ $enableOpt = "yes" ]; then
    ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled
elif [ $enableOpt = "no" ]; then
    echo "$DOMAIN was not enabled at this time, please run 'ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled' to enable it later."
fi

echo "Would you like to restart nginx? (Required for a newly enabled site)"

read reloadOpt
if [ $reloadOpt = "yes" ]; then
    echo "Restarting nginx now..."
    sudo /etc/init.d/nginx restart
elif [ $reloadOpt = "no" ]; then
    echo "Please restart nginx when you feel like it then..."
fi

echo "Enjoy your new domain! Don't forget to setup DNS"
