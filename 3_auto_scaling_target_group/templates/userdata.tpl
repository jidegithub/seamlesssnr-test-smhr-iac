#!/bin/bash
apt update -y
apt install nginx -y
chkconfig nginx on
cat <<'END_HTML' >/var/www/html/index.nginx-debian.html 
<html> <head> <title>magento</title> <style>body {margin-top: 40px; background-color: teal;} </style> </head><body> <div style=color:white;text-align:center> <h1>Magento Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on NGINX web server.</p> </div></body></html> 
END_HTML
service nginx start