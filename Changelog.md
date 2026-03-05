# Changelog

Semua perubahan penting pada project ini akan didokumentasikan di file ini.

Format mengacu pada [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.0.0] - 2026-03-05

### Added
- `install-wp.sh` — Script instalasi WordPress otomatis dengan input interaktif
- `uninstall-wp.sh` — Script uninstall WordPress, database, dan konfigurasi Nginx
- `update-wp.sh` — Script update WordPress ke versi terbaru dengan backup otomatis
- `README.md` — Dokumentasi lengkap cara penggunaan
- `CONTRIBUTING.md` — Panduan kontribusi
- `LICENSE` — MIT License

### Notes
- Mendukung Ubuntu 22.04
- Stack: Nginx + PHP 8.1 + MariaDB
- Opsional integrasi Cloudflare Tunnel
