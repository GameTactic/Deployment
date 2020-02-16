#!/bin/sh

if [[ -z "${GT_MIGRATE}" ]]; then
  echo 'Running migrations...'
  /usr/local/bin/php /app/bin/console doctrine:migrations:migrate latest --no-interaction
fi

echo 'Starting Supervisor...'
/usr/bin/supervisord --nodaemon --configuration /etc/supervisord.conf
