#!/usr/bin/env sh
set -eu

# Configure Webserver
curl -Ss https://raw.githubusercontent.com/GameTactic/Deployment/master/artifact/nginx_main.conf > /etc/nginx/nginx.conf
curl -Ss https://raw.githubusercontent.com/GameTactic/Deployment/master/artifact/nginx.conf > /etc/nginx/conf.d/default.conf

# Configure PHP
curl -Ss https://raw.githubusercontent.com/GameTactic/Deployment/master/artifact/docker.conf > /usr/local/etc/php-fpm.d/docker.conf
echo -e "[PHP]\nupload_max_filesize = 2M\npost_max_size = 4M\n" > /usr/local/etc/php/php.ini

# Install Nginx Metrics Export
wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.7.0/nginx-prometheus-exporter-0.7.0-linux-amd64.tar.gz
tar zxvf nginx-prometheus-exporter-0.7.0-linux-amd64.tar.gz
rm nginx-prometheus-exporter-0.7.0-linux-amd64.tar.gz
mv nginx-prometheus-exporter /bin

# Configure container runtime
curl -Ss https://raw.githubusercontent.com/GameTactic/Deployment/master/artifact/supervisord.conf > /etc/supervisord.conf
curl -Ss https://raw.githubusercontent.com/GameTactic/Deployment/master/artifact/entrypoint.sh > /entrypoint.sh
chmod +x /entrypoint.sh
