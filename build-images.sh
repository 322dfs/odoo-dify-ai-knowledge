#!/bin/bash

set -e

echo "=========================================="
echo "  Odoo + Dify AI 知识库 - 镜像导出脚本"
echo "=========================================="
echo ""
echo "此脚本用于在有网络的机器上导出 Docker 镜像"
echo "导出后可传输到无网络服务器进行离线部署"
echo ""

IMAGES_DIR="images"
IMAGES=("odoo:17" "postgres:15")

mkdir -p "$IMAGES_DIR"

echo "[1/2] 拉取镜像..."
for image in "${IMAGES[@]}"; do
    name=$(echo "$image" | tr ':', '-')
    echo "  拉取 $image ..."
    docker pull "$image"
done

echo ""
echo "[2/2] 导出镜像..."
for image in "${IMAGES[@]}"; do
    name=$(echo "$image" | tr ':', '-')
    filename="$IMAGES_DIR/${name}.tar"
    echo "  导出 $image -> $filename"
    docker save "$image" -o "$filename"
done

echo ""
echo "=========================================="
echo "  导出完成！"
echo "=========================================="
echo ""
echo "镜像文件列表："
ls -lh "$IMAGES_DIR"/*.tar
echo ""
echo "总大小："
du -sh "$IMAGES_DIR"
echo ""
echo "下一步："
echo "  1. 将整个项目目录传输到目标服务器"
echo "  2. 在目标服务器上运行 deploy-offline.sh"
echo ""
