#!/bin/bash

set -e

echo "=========================================="
echo "  Odoo + Dify AI 知识库 - 离线部署脚本"
echo "=========================================="

DEPLOY_DIR="/opt/odoo"
IMAGE_DIR="$DEPLOY_DIR/images"

echo ""
echo "[1/5] 检查 Docker 服务..."
if ! command -v docker &> /dev/null; then
    echo "错误: Docker 未安装"
    exit 1
fi
echo "Docker 版本: $(docker --version)"

echo ""
echo "[2/5] 创建目录结构..."
sudo mkdir -p "$DEPLOY_DIR"/{config,addons,data,postgres}
echo "目录创建完成"

echo ""
echo "[3/5] 导入 Docker 镜像..."
if [ -f "$IMAGE_DIR/odoo-17.tar" ]; then
    echo "导入 Odoo 17 镜像..."
    sudo docker load -i "$IMAGE_DIR/odoo-17.tar"
else
    echo "警告: odoo-17.tar 不存在，跳过"
fi

if [ -f "$IMAGE_DIR/postgres-15.tar" ]; then
    echo "导入 PostgreSQL 15 镜像..."
    sudo docker load -i "$IMAGE_DIR/postgres-15.tar"
else
    echo "警告: postgres-15.tar 不存在，跳过"
fi

echo ""
echo "[4/5] 部署配置文件..."
if [ -f "$DEPLOY_DIR/docker-compose.yml" ]; then
    echo "docker-compose.yml 已存在"
else
    echo "请确保 docker-compose.yml 和 odoo.conf 已放置在 $DEPLOY_DIR"
fi

echo ""
echo "[5/5] 启动服务..."
cd "$DEPLOY_DIR"
sudo docker-compose up -d

echo ""
echo "=========================================="
echo "  部署完成!"
echo "=========================================="
echo ""
echo "访问地址:"
echo "  Odoo:  http://$(hostname -I | awk '{print $1}'):8069"
echo ""
echo "管理员密码: admin123"
echo ""
echo "常用命令:"
echo "  查看状态: sudo docker-compose ps"
echo "  查看日志: sudo docker-compose logs -f"
echo "  停止服务: sudo docker-compose down"
echo "  重启服务: sudo docker-compose restart"
echo ""
