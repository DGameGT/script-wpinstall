#!/bin/bash

# ============================================
#   WordPress Auto Installer
#   CF Tunnel
#   by DGXO - github.com/DGameGT
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "============================================"
echo "       WordPress Auto Installer"
echo "       by DGameXO - github.com/DGameGT"
echo "============================================"
echo -e "${NC}"

# Check root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Jalankan script ini sebagai root!${NC}"
  exit 1
fi

# ============================================
# INPUT DARI USER
# ============================================

echo -e "${YELLOW}[INPUT] Konfigurasi WordPress${NC}"
echo ""

read -p "Domain WordPress (contoh: wp.dgxo.my.id): " WP_DOMAIN
read -p "Nama Database: " DB_NAME
read -p "Username Database: " DB_USER
read -s -p "Password Database: " DB_PASS
echo ""
read -p "Judul Website: " WP_TITLE
read -p "Username Admin WordPress: " WP_ADMIN_USER
read -s -p "Password Admin WordPress: " WP_ADMIN_PASS
echo ""
read -p "Email Admin WordPress: " WP_ADMIN_EMAIL

echo ""
echo -e "${YELLOW}[INFO] Konfigurasi yang akan digunakan:${NC}"
echo "  Domain      : $WP_DOMAIN"
echo "  DB Name     : $DB_NAME"
echo "  DB User     : $DB_USER"
echo "  WP Title    : $WP_TITLE"
echo "  WP Admin    : $WP_ADMIN_USER"
echo "  WP Email    : $WP_ADMIN_EMAIL"
echo ""
read -p "Lanjutkan instalasi? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
  echo -e "${RED}Instalasi dibatalkan.${NC}"
  exit 1
fi

# ============================================
# INSTALASI
# ============================================

echo ""
echo -e "${GREEN}[1/6] Update sistem...${NC}"
apt update -y && apt upgrade -y

echo -e "${GREEN}[2/6] Install Nginx, PHP, MariaDB...${NC}"
apt install -y nginx php8.1-fpm php8.1-mysql php8.1-curl php8.1-gd \
  php8.1-mbstring php8.1-xml php8.1-zip mariadb-server curl wget

echo -e "${GREEN}[3/6] Setup database...${NC}"
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

echo -e "${GREEN}[4/6] Download & ekstrak WordPress...${NC}"
cd /var/www/
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rm latest.tar.gz
chown -R www-data:www-data /var/www/wordpress/

echo -e "${GREEN}[5/6] Konfigurasi WordPress...${NC}"
cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

# Generate secret keys
SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

sed -i "s/database_name_here/$DB_NAME/" /var/www/wordpress/wp-config.php
sed -i "s/username_here/$DB_USER/" /var/www/wordpress/wp-config.php
sed -i "s/password_here/$DB_PASS/" /var/www/wordpress/wp-config.php

# Inject secret keys
PLACEHOLDER="define( 'AUTH_KEY',         'put your unique phrase here' );"
php_keys=$(echo "$SALT" | sed "s|'||g")
sed -i "/put your unique phrase here/d" /var/www/wordpress/wp-config.php
sed -i "/AUTH_KEY/d;/SECURE_AUTH_KEY/d;/LOGGED_IN_KEY/d;/NONCE_KEY/d;/AUTH_SALT/d;/SECURE_AUTH_SALT/d;/LOGGED_IN_SALT/d;/NONCE_SALT/d" /var/www/wordpress/wp-config.php

# Tambah WP_HOME dan WP_SITEURL
sed -i "s|/\* That's all, stop editing! Happy publishing. \*/|define('WP_HOME', 'https://$WP_DOMAIN');\ndefine('WP_SITEURL', 'https://$WP_DOMAIN');\n\n/* That's all, stop editing! Happy publishing. */|" /var/www/wordpress/wp-config.php

echo -e "${GREEN}[6/6] Konfigurasi Nginx...${NC}"
cat > /etc/nginx/sites-available/wordpress <<NGINX
server {
    listen 80;
    server_name $WP_DOMAIN;

    root /var/www/wordpress;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
NGINX

rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx
systemctl restart php8.1-fpm

# ============================================
# SELESAI
# ============================================

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}   WordPress berhasil diinstall!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "  Website  : ${BLUE}https://$WP_DOMAIN${NC}"
echo -e "  Admin    : ${BLUE}https://$WP_DOMAIN/wp-admin${NC}"
echo ""
echo -e "${YELLOW}[INFO] Jangan lupa setup Cloudflare Tunnel!${NC}"
echo -e "${YELLOW}       Dokumentasi: github.com/DGameGT/How-to-install-Cloudflared-in-Linux${NC}"
echo ""
