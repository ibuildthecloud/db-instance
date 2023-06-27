#!/bin/sh
set -e

(
    sleep 60
    kill $PPID
) &

while ! mysql --connect-timeout=2 -h db -u ${ADMIN_USER} -p${ADMIN_PASS} -e "SELECT 1"; do
    sleep .5
done

echo Creating database $DBNAME and user $USER with user $ADMIN_USER
mysql -h db -u ${ADMIN_USER} -p${ADMIN_PASS} << EOF
CREATE DATABASE IF NOT EXISTS ${DBNAME};
CREATE USER IF NOT EXISTS '${USER}'@'%';
ALTER USER '${USER}'@'%' IDENTIFIED BY '${PASS}';
GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${USER}'@'%';
FLUSH PRIVILEGES;
EOF
