#!/bin/bash

# ============================================
#   WordPress Auto Uninstaller
#   by DGameXO - github.com/DGameGT
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}"
echo "============================================"
echo "       WordPress Auto Uninstaller"
echo "       by DGameXO - github.com/DGameGT"
echo "============================================"
echo -e "${NC}"

# Check root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Jalankan script ini sebagai root!${NC}"
  exit 1
fi

echo -e "${YELLOW}[WARNING] Script ini akan menghapus:${NC}"
echo "  - File WordPress di /var/www/wordpress"
echo "  - Database & user database WordPress"
echo "  - Konfigurasi Nginx WordPress"
echo ""
read -p "Nama database yang ingin dihapus: " DB_NAME
read -p "Username database yang ingin dihapus: " DB_USER
echo ""
read -p "Yakin ingin uninstall WordPress? Tindakan ini tidak bisa dibatalkan! (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
  echo -e "${GREEN}Uninstall dibatalkan.${NC}"
  exit 1
fi

echo ""
echo -e "${RED}[1/4] Menghapus file WordPress...${NC}"
rm -rf /var/www/wordpress

echo -e "${RED}[2/4] Menghapus database & user...${NC}"
mysql -u root <<EOF
DROP DATABASE IF EXISTS \`$DB_NAME\`;
DROP USER IF EXISTS '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

echo -e "${RED}[3/4] Menghapus konfigurasi Nginx...${NC}"
rm -f /etc/nginx/sites-enabled/wordpress
rm -f /etc/nginx/sites-available/wordpress
systemctl restart nginx

echo -e "${RED}[4/4] Menghapus service Cloudflare Tunnel (jika ada)...${NC}"
systemctl stop cloudflared 2>/dev/null
systemctl disable cloudflared 2>/dev/null
rm -f /etc/systemd/system/cloudflared.service
systemctl daemon-reload

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}   WordPress berhasil diuninstall!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
