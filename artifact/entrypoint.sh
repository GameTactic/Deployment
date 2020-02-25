#!/bin/sh

if [ -f /app_migrate ]; then
  echo "Waiting for db to be ready..."
  REPEAT=0
  until bin/console doctrine:query:sql "SELECT 1" > /dev/null 2>&1; do
    echo -ne '.'
    REPEAT=$((REPEAT + 1))
    sleep 1

    if [ $REPEAT -eq 30 ]; then
      echo "Database connection failed!"
      exit 1;
    fi
  done
  echo 'Running migrations...'
  /usr/local/bin/php /app/bin/console doctrine:migrations:migrate latest --no-interaction
fi

echo 'Starting Supervisor...'
/usr/bin/supervisord --nodaemon --configuration /etc/supervisord.conf
