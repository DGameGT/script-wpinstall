# WordPress Auto Installer
by DGXO - github.com/DGameGT

Script otomatis untuk install WordPress di Ubuntu 22.04 dengan Nginx, PHP 8.1, dan MariaDB. Cocok untuk deploy WordPress di LXC Proxmox.

---

## Persyaratan

- Ubuntu 22.04 (fresh install)
- Akses root
- Koneksi internet
- Domain yang sudah diarahkan ke server (via Cloudflare Tunnel atau lainnya)

---

## Cara Pakai

### 1. Download script
```bash
wget https://raw.githubusercontent.com/DGameGT/wordpress-installer/main/install-wp.sh
```
atau upload manual ke server.

### 2. Beri izin eksekusi
```bash
chmod +x install-wp.sh
```

### 3. Jalankan script
```bash
./install-wp.sh
```

### 4. Isi informasi yang diminta
Script akan menanyakan:
| Input | Keterangan |
|-------|-----------|
| Domain | Domain/subdomain WordPress (contoh: `wp.dgxo.my.id`) |
| Nama Database | Nama database yang akan dibuat |
| Username Database | Username untuk database |
| Password Database | Password untuk database |
| Judul Website | Nama/judul website WordPress |
| Username Admin WP | Username untuk login ke dashboard WP |
| Password Admin WP | Password untuk login ke dashboard WP |
| Email Admin WP | Email admin WordPress |

---

## Yang Diinstall Otomatis

- Nginx
- PHP 8.1 + ekstensi (fpm, mysql, curl, gd, mbstring, xml, zip)
- MariaDB
- WordPress (versi terbaru)

---

## Setelah Instalasi

Akses website kamu di:
```
https://DOMAIN_KAMU
```

Login ke dashboard admin:
```
https://DOMAIN_KAMU/wp-admin
```

---

## Publish ke Internet (Cloudflare Tunnel)

Agar website bisa diakses dari internet tanpa membuka port router, gunakan Cloudflare Tunnel.

Dokumentasi lengkap: [How-to-install-Cloudflared-in-Linux](https://github.com/DGameGT/How-to-install-Cloudflared-in-Linux)

---

## Stack

- **OS**: Ubuntu 22.04
- **Web Server**: Nginx
- **PHP**: 8.1
- **Database**: MariaDB
- **CMS**: WordPress (latest)
- **Tunnel**: Cloudflare Tunnel (opsional)

---

## Lisensi

Script ini bebas digunakan, dimodifikasi, dan dipublikasikan ulang.
