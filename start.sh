#!/bin/bash
set -e

# run entrypoint
/entrypoint.sh

# run nginx & php-fpm
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
