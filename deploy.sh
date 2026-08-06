#!/bin/bash
# flatnotes deploy: rebuild client and restart service
set -e

SRC="$HOME/flatnotes"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "=== flatnotes 部署脚本 ==="
echo ""

cd "$SRC"

# 1. Rebuild client
echo "▶ npm run build..."
npm run build 2>&1 | tail -5

# 2. Restart service
echo "▶ 重启 flatnotes..."
sudo systemctl restart flatnotes
sleep 2

# 3. Verify
if systemctl is-active --quiet flatnotes; then
  echo "✓ flatnotes 运行正常"
else
  echo "❌ flatnotes 启动失败"
  sudo systemctl status flatnotes --no-pager -l
  exit 1
fi

echo ""
echo "=== 部署完成 ($(date '+%H:%M:%S')) ==="
