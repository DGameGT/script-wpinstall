#!/bin/bash

# ============================================
#   WordPress Auto Updater
#   by DGameXO - github.com/DGameGT
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "============================================"
echo "       WordPress Auto Updater"
echo "       by DGameXO - github.com/DGameGT"
echo "============================================"
echo -e "${NC}"

# Check root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Jalankan script ini sebagai root!${NC}"
  exit 1
fi

WP_PATH="/var/www/wordpress"

if [ ! -d "$WP_PATH" ]; then
  echo -e "${RED}[ERROR] WordPress tidak ditemukan di $WP_PATH${NC}"
  exit 1
fi

echo -e "${YELLOW}[INFO] Memulai update WordPress...${NC}"
echo ""

echo -e "${GREEN}[1/4] Backup wp-config.php...${NC}"
cp $WP_PATH/wp-config.php /root/wp-config.php.bak
echo "  Backup disimpan di /root/wp-config.php.bak"

echo -e "${GREEN}[2/4] Download WordPress terbaru...${NC}"
cd /tmp
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

echo -e "${GREEN}[3/4] Update file WordPress...${NC}"
cp -rf /tmp/wordpress/* $WP_PATH/
chown -R www-data:www-data $WP_PATH/

echo -e "${GREEN}[4/4] Restore wp-config.php...${NC}"
cp /root/wp-config.php.bak $WP_PATH/wp-config.php
chown www-data:www-data $WP_PATH/wp-config.php

# Cleanup
rm -rf /tmp/wordpress /tmp/latest.tar.gz

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}   WordPress berhasil diupdate!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}[INFO] Backup wp-config.php tersimpan di /root/wp-config.php.bak${NC}"
echo ""
