#!/bin/sh
set -e

PGDATA='/var/lib/postgresql/data'
export PGDATA="$PGDATA"

grep -qxF '127.0.0.1 db' /etc/hosts || echo '127.0.0.1 db' >> /etc/hosts

cd /var/www/html
PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-production"
if [ "$APP_ENV" != 'prod' ]; then
	PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-development"
fi
ln -sf "$PHP_INI_RECOMMENDED" "$PHP_INI_DIR/php.ini"

mkdir -p var/cache var/log

gosu postgres pg_ctl -D "$PGDATA" -m fast -w start
echo "Waiting for db to be ready..."
REPEAT=0
until bin/console doctrine:query:sql "SELECT 1" > /dev/null 2>&1; do
  echo -ne '.'
  REPEAT=$((REPEAT + 1))
  sleep 1

  if [ $REPEAT -eq 15 ]; then
    echo "Database connection failed!"
    exit 1;
  fi
done

if ls -A src/Migrations/*.php > /dev/null 2>&1; then
  bin/console doctrine:migrations:migrate --no-interaction
fi

gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop
