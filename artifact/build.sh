#!/usr/bin/env sh
set -eu

# Configure Webserver
curl -Ss https://raw.githubusercontent.com/GameTactic/Deployment/master/artifact/nginx_main.conf > /etc/nginx/nginx.conf
curl -Ss https://raw.githubusercontent.com/GameTactic/Deployment/master/artifact/nginx.conf > /etc/nginx/http.d/default.conf

# Configure PHP
curl -Ss https://raw.githubusercontent.com/GameTactic/Deployment/master/artifact/docker.conf > /usr/local/etc/php-fpm.d/docker.conf
echo -e "[PHP]\nupload_max_filesize = 2M\npost_max_size = 4M\n" > /usr/local/etc/php/php.ini

# Install Nginx Metrics Export
wget "https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.9.0/nginx-prometheus-exporter_0.9.0_linux_amd64.tar.gz"
tar zxvf nginx-prometheus-exporter_0.9.0_linux_*.tar.gz
rm nginx-prometheus-exporter_0.9.0_linux_*.tar.gz
mv nginx-prometheus-exporter /bin


# Configure container runtime
curl -Ss https://raw.githubusercontent.com/GameTactic/Deployment/master/artifact/supervisord.conf > /etc/supervisord.conf
curl -Ss https://raw.githubusercontent.com/GameTactic/Deployment/master/artifact/entrypoint.sh > /entrypoint.sh
chmod +x /entrypoint.sh
