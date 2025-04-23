#!/bin/bash

set -e

echo "=== Mulai instalasi GPT Matrix Bot ==="

# Pastikan jalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
  echo "Harap jalankan sebagai root (sudo su)"
  exit 1
fi

# Install paket dasar
apt update
apt install -y git python3 python3-pip python3-venv curl

# Folder kerja
BOT_DIR="/root/gpt-matrix"

# Bersihkan folder lama jika rusak
if [ -d "$BOT_DIR" ]; then
  echo "Hapus instalasi sebelumnya..."
  rm -rf "$BOT_DIR"
fi

# Clone ulang project
git clone https://github.com/matrixgpt/gpt-matrix.git "$BOT_DIR"
cd "$BOT_DIR"

# Setup virtual environment
python3 -m venv venv
source venv/bin/activate

# Buat file requirements.txt jika tidak ada
if [ ! -f requirements.txt ]; then
  echo "Buat file requirements.txt..."
  cat > requirements.txt <<EOF
matrix-nio[e2e]~=0.24.0
openai>=1.0.0
python-dotenv
EOF
fi

# Install dependensi Python
pip install --upgrade pip
pip install -r requirements.txt

# Buat file .env kalau belum ada
if [ ! -f .env ]; then
  echo "Buat file .env..."
  cp .env.example .env
fi

# Cek kalau bot.py tidak ada
if [ ! -f bot.py ]; then
  echo "ERROR: File bot.py tidak ditemukan!"
  echo "Periksa isi repository atau buat manual."
  exit 1
fi

# Info sukses
echo ""
echo "==== Instalasi selesai ===="
echo "Edit file kredensial: nano /root/gpt-matrix/.env"
echo "Untuk menjalankan bot:"
echo "cd /root/gpt-matrix && source venv/bin/activate && python3 bot.py"
