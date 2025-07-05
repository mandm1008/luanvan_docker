#!/bin/bash

# Lấy PROJECT_NUMBER từ Metadata Server
PROJECT_NUMBER=$(curl -s -H "Metadata-Flavor: Google" \
  "http://metadata.google.internal/computeMetadata/v1/project/numeric-project-id")

K_REGION="asia-southeast1"

# Dựng BASE_URL nếu chưa có sẵn
BASE_URL="https://${K_SERVICE}-${PROJECT_NUMBER}.${K_REGION}.run.app"

# Ghi vào file .env.local
cat <<EOF > /.env.local
BASE_URL=${BASE_URL}
ADMIN_USER=${ADMIN_USER}
ADMIN_PASS=${ADMIN_PASS}
ADMIN_EMAIL=${ADMIN_EMAIL}
DB_HOST=${DB_HOST}
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASS=${DB_PASS}
GCS_BUCKET=${GCS_BUCKET}
MAIN_TOKEN=${MAIN_TOKEN}
EOF
