#!/bin/bash

echo "=========================================="
echo "  打包项目 - 准备上传 GitHub"
echo "=========================================="

VERSION="v1.0"
OUTPUT="odoo-dify-ai-knowledge-${VERSION}"

echo ""
echo "创建发布包: ${OUTPUT}.zip"

# 排除镜像文件打包
zip -r "${OUTPUT}.zip" . \
    -x "images/*.tar" \
    -x ".git/*" \
    -x "__pycache__/*" \
    -x "*.pyc" \
    -x ".env"

echo ""
echo "=========================================="
echo "  打包完成!"
echo "=========================================="
echo ""
ls -lh "${OUTPUT}.zip"
echo ""
echo "注意: 镜像文件 (images/*.tar) 未包含在压缩包中"
echo "如需离线部署，请单独传输镜像文件"
