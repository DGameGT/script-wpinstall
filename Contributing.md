# Contributing

Terima kasih sudah tertarik untuk berkontribusi pada project ini! 🎉

---

## Cara Berkontribusi

### 1. Fork repo ini
Klik tombol **Fork** di pojok kanan atas halaman GitHub.

### 2. Clone repo hasil fork kamu
```bash
git clone https://github.com/DGameGT/wpinstall.git
cd wpinstaller
```

### 3. Buat branch baru
```bash
git checkout -b fitur-baru
```

### 4. Lakukan perubahan
Edit file yang diperlukan. Pastikan script tetap berjalan dengan baik di Ubuntu 22.04.

### 5. Commit perubahan
```bash
git add .
git commit -m "feat: tambah fitur XYZ"
```

### 6. Push ke branch kamu
```bash
git push origin fitur-baru
```

### 7. Buat Pull Request
Buka repo kamu di GitHub, lalu klik **Compare & pull request**.

---

## Panduan Penulisan Script

- Gunakan `bash` sebagai interpreter (`#!/bin/bash`)
- Tambahkan warna output agar mudah dibaca (gunakan variabel warna yang sudah ada)
- Selalu cek apakah script dijalankan sebagai root
- Tambahkan komentar pada bagian yang kompleks
- Test script di fresh install Ubuntu 22.04 sebelum PR

---

## Format Commit Message

Gunakan format berikut:

| Prefix | Keterangan |
|--------|-----------|
| `feat:` | Fitur baru |
| `fix:` | Bug fix |
| `docs:` | Perubahan dokumentasi |
| `refactor:` | Refactor kode |
| `chore:` | Hal-hal kecil (update versi, dll) |

Contoh:
```
feat: tambah support Ubuntu 24.04
fix: perbaiki error saat database sudah ada
docs: update README bagian CF Tunnel
```

---

## Melaporkan Bug

Buka [Issues](https://github.com/DGameGT/wpinstaller/issues) dan sertakan:
- Versi OS yang digunakan
- Langkah untuk mereproduksi bug
- Output error yang muncul
- Screenshot jika perlu

---

## Lisensi

Dengan berkontribusi, kamu setuju bahwa kontribusimu akan dilisensikan di bawah [MIT License](LICENSE).
