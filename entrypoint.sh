#!/bin/bash
set -e

echo "[INFO] Generating .env.local from environment..."
/init-env.sh

# ✅ Hiển thị nội dung file /.env.local
if [ -f /.env.local ]; then
  echo "[INFO] Contents of /.env.local:"
  cat /.env.local
else
  echo "[WARNING] /.env.local not found!"
fi

# echo "[INFO] Checking if Moodle database needs initialization..."
# if [ -f /var/www/html/config.php ]; then
#   HAS_CONFIG_TABLE=$(mysql -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASS}" -D"${DB_NAME}" -e "SHOW TABLES LIKE 'mdl_config';" 2>/dev/null | grep config || true)

#   if [ -z "$HAS_CONFIG_TABLE" ]; then
#     echo "[INFO] Moodle database not initialized — running install_database.php..."
#     php /var/www/html/admin/cli/install_database.php \
#       --agree-license \
#       --adminuser="${ADMIN_USER}" \
#       --adminpass="${ADMIN_PASS}" \
#       --adminemail="${ADMIN_EMAIL}" || {
#         echo "[WARNING] install_database.php failed (possibly already initialized). Continuing anyway..."
#       }
#   else
#     echo "[INFO] Moodle database already initialized."
#   fi
# else
#   echo "[WARNING] config.php not found — skipping database initialization check."
# fi

echo "[INFO] Running Moodle upgrade..."
php /var/www/html/admin/cli/upgrade.php --non-interactive || true

php /var/www/html/admin/cli/cron.php

exec "$@"

# # ✅ Start PHP-FPM (not Apache)
# echo "[INFO] Starting PHP-FPM..."
# exec php-fpm
