#!/bin/bash

set -e

echo "=========================================="
echo "  导出 Docker 镜像 - 用于离线部署"
echo "=========================================="

IMAGE_DIR="images"
mkdir -p "$IMAGE_DIR"

echo ""
echo "[1/2] 导出 Odoo 17 镜像..."
docker save -o "$IMAGE_DIR/odoo-17.tar" odoo:17
echo "完成: $IMAGE_DIR/odoo-17.tar"

echo ""
echo "[2/2] 导出 PostgreSQL 15 镜像..."
docker save -o "$IMAGE_DIR/postgres-15.tar" postgres:15
echo "完成: $IMAGE_DIR/postgres-15.tar"

echo ""
echo "=========================================="
echo "  导出完成!"
echo "=========================================="
echo ""
ls -lh "$IMAGE_DIR"
echo ""
echo "下一步: 将 images/ 目录传输到目标服务器"
