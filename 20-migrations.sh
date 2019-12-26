#!/bin/sh
set -e

cd /var/www/html
PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-production"
if [ "$APP_ENV" != 'prod' ]; then
	PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-development"
fi
ln -sf "$PHP_INI_RECOMMENDED" "$PHP_INI_DIR/php.ini"

mkdir -p var/cache var/log

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

if ls -A src/Migrations/*.php > /dev/null 2>&1; then
  bin/console doctrine:migrations:migrate --no-interaction
fi

chown nginx:nginx -R .
