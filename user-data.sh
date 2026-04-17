#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
apt update -y
apt install -y lighttpd
systemctl start lighttpd
systemctl enable lighttpd
touch /var/www/html/index.html
echo "<h1>Hello World from $(hostname -f ) </h1>" > /var/www/html/index.html