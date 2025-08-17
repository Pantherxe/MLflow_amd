#!/bin/bash

# Environment Generation Script for fancyproject
# This script extracts S3 credentials from rclone config and generates .env file

REMOTE_NAME="rclone_s3" 
RCLONE_CONF="${HOME}/.config/rclone/rclone.conf"
ENV_DIR="${HOME}"
ENV_FILE="${ENV_DIR}/.env"

if [[ ! -f "$RCLONE_CONF" ]]; then
  echo "❌ rclone config not found at $RCLONE_CONF"
  exit 1
fi

# Extract values from rclone.conf
S3_ACCESS_KEY=$(grep -A5 "\[$REMOTE_NAME\]" "$RCLONE_CONF" | grep "access_key_id" | cut -d '=' -f2 | xargs)
S3_SECRET_ACCESS_KEY=$(grep -A5 "\[$REMOTE_NAME\]" "$RCLONE_CONF" | grep "secret_access_key" | cut -d '=' -f2 | xargs)
S3_ENDPOINT_URL=$(grep -A5 "\[$REMOTE_NAME\]" "$RCLONE_CONF" | grep "endpoint" | cut -d '=' -f2 | xargs)


# Project configuration
# Get public IP
HOST_IP=$(curl -s ifconfig.me)


# Hugging Face setup
HF_HOME="/mnt/data/hf_cache"
HF_TOKEN_PATH="/tmp/hf_token"


echo -n "🔐 Enter your Hugging Face token (will not be displayed): "
read -s HF_TOKEN
echo

# Write token to ephemeral location
echo "$HF_TOKEN" > "$HF_TOKEN_PATH"
chmod 600 "$HF_TOKEN_PATH"


# Creating .env file
{
  echo "S3_ACCESS_KEY=${S3_ACCESS_KEY}"
  echo "S3_SECRET_ACCESS_KEY=${S3_SECRET_ACCESS_KEY}"
  echo "HOST_IP=${HOST_IP}"
  echo "PROJECT_NAME=${PROJECT_NAME}"
  echo "S3_ENDPOINT_URL=${S3_ENDPOINT_URL}"
  echo "HF_HOME=${HF_HOME}"
  echo "HF_TOKEN_PATH=${HF_TOKEN_PATH}"
} > "$ENV_FILE"

echo "✅ The .env file has been generated successfully at : $ENV_FILE"
echo "🔑 Hugging Face token has been stored securely at: $HF_TOKEN_PATH"
