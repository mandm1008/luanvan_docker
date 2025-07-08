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

echo "[INFO] Running Moodle upgrade..."
php /var/www/html/admin/cli/upgrade.php --non-interactive || true

# ✅ Vòng lặp chạy cron.php mỗi phút
echo "[INFO] Starting Moodle cron loop..."
while true; do
  echo "[INFO] Running cron at $(date '+%Y-%m-%d %H:%M:%S')"
  php /var/www/html/admin/cli/cron.php || echo "[ERROR] Cron failed"
  sleep 60
done

exec "$@"
