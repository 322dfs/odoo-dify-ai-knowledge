# Odoo + Dify 企业内网 AI 智能知识库

## 项目简介

本项目为**半导体初创公司**构建的私有化 AI 知识库系统，解决以下痛点：

| 痛点 | 解决方案 |
|------|----------|
| 员工不爱写文档，技术经验流失 | Odoo 知识库统一管理 |
| 知识分散，查找困难 | AI 智能问答快速检索 |
| 新人培训慢，重复问题多 | RAG 检索自动回答 |
| 数据安全合规要求 | 全内网部署，无外网依赖 |

---

## 系统架构

```
┌─────────────────────────────────────────────────────────────────┐
│                  内网服务器 192.168.108.116                       │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              AI 问答服务 (Dify 1.4.0)                      │   │
│  │   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │   │
│  │   │    Dify     │    │ PostgreSQL  │    │   Redis     │  │   │
│  │   │  AI 问答    │    │   :5432     │    │   :6379     │  │   │
│  │   │  :80/:443   │    │  (Dify专用)  │    │  (Dify专用)  │  │   │
│  │   └─────────────┘    └─────────────┘    └─────────────┘  │   │
│  │          │                Weaviate (向量库)               │   │
│  │          ▼                                                 │   │
│  │   ┌─────────────┐                                         │   │
│  │   │   Ollama    │  deepseek-r1:32b / qwq:latest          │   │
│  │   │  :11434     │  2×RTX2080Ti (22GB显存)                 │   │
│  │   └─────────────┘                                         │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              知识库服务 (Odoo 17)                          │   │
│  │   ┌─────────────┐    ┌─────────────┐                     │   │
│  │   │   Odoo 17   │    │ PostgreSQL  │                     │   │
│  │   │   知识库     │◄───┤   :5432     │                     │   │
│  │   │  :8069      │    │ (Odoo专用)   │                     │   │
│  │   └─────────────┘    └─────────────┘                     │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              数据同步服务 (待开发)                          │   │
│  │   Odoo 文档 ──────► Python 同步脚本 ──────► Dify 知识库    │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 系统现状

### 服务清单

| 服务 | 版本 | 端口 | 状态 | 用途 |
|------|------|------|------|------|
| Dify | 1.4.0 | 80/443 | ✅ 运行中 | AI 问答、RAG 检索 |
| Ollama | - | 11434 | ✅ 运行中 | 本地大模型服务 |
| PostgreSQL (Dify) | 15-alpine | 5432 | ✅ 运行中 | Dify 数据存储 |
| Redis | 6-alpine | 6379 | ✅ 运行中 | Dify 缓存 |
| Weaviate | 1.19.0 | - | ✅ 运行中 | Dify 向量库 |
| **Odoo** | **17** | **8069** | ✅ 运行中 | 知识库管理 |
| **PostgreSQL (Odoo)** | **15** | 5432 (内部) | ✅ 运行中 | Odoo 数据存储 |

### AI 模型

| 模型 | 大小 | 用途 |
|------|------|------|
| deepseek-r1:32b | 19 GB | 推理能力强，适合复杂问答 |
| qwq:latest | 19 GB | 推理模型，适合分析问题 |

### 硬件配置

| 项目 | 配置 |
|------|------|
| CPU | AMD Ryzen Threadripper 1950X 16核 |
| 内存 | 188 GB |
| GPU | 2× NVIDIA RTX 2080 Ti (22GB 显存) |
| 磁盘 | 228GB NVMe (已用126GB，剩余90GB) |

---

## 访问信息

| 服务 | 地址 | 账号 | 密码 |
|------|------|------|------|
| Odoo | http://192.168.108.116:8069 | admin | admin123 |
| Dify | http://192.168.108.116 | - | - |
| Ollama | http://192.168.108.116:11434 | - | - |

---

## 目录结构

```
odoo-dify-ai-knowledge/
├── README.md                 # 本文档
├── PROJECT_OVERVIEW.md       # 项目详细概述
├── OPERATION_GUIDE.md        # 操作手册
├── docker-compose.yml        # Odoo 服务编排
├── odoo.conf                 # Odoo 配置文件
├── build-images.sh           # 一键导出镜像脚本
├── deploy-offline.sh         # 离线部署脚本
├── export-images.sh          # 镜像导出脚本
├── package.sh                # 打包脚本
└── images/                   # 镜像文件目录（需自行生成）
    ├── odoo-17.tar           # Odoo 17 镜像
    └── postgres-15.tar       # PostgreSQL 15 镜像
```

---

## 快速开始

### 前置条件

- 服务器已安装 Docker 和 Docker Compose
- 已配置 SSH 免密登录

### 部署方式

#### 方式一：有网络环境（推荐）

服务器可访问外网时，直接拉取镜像部署：

```bash
# 1. 克隆项目
git clone https://github.com/322dfs/odoo-dify-ai-knowledge.git
cd odoo-dify-ai-knowledge

# 2. 拉取镜像
docker pull odoo:17
docker pull postgres:15

# 3. 创建目录
sudo mkdir -p /opt/odoo/{config,addons,data,postgres}

# 4. 复制配置文件
sudo cp docker-compose.yml odoo.conf /opt/odoo/

# 5. 启动服务
cd /opt/odoo
sudo docker-compose up -d
```

#### 方式二：无网络环境（离线部署）

服务器无法访问外网时，需要先在有网络的机器上导出镜像：

**步骤1：在有网络机器上导出镜像**
```bash
# 克隆项目
git clone https://github.com/322dfs/odoo-dify-ai-knowledge.git
cd odoo-dify-ai-knowledge

# 一键导出镜像（自动拉取并导出）
chmod +x build-images.sh
./build-images.sh
```

或手动导出：
```bash
docker pull odoo:17
docker pull postgres:15
docker save odoo:17 -o images/odoo-17.tar
docker save postgres:15 -o images/postgres-15.tar
```

**步骤2：传输文件到服务器**
```bash
# 传输所有文件到服务器
scp -r ./* user@server:/opt/odoo/
```

**步骤3：在服务器上导入镜像并部署**
```bash
cd /opt/odoo

# 导入镜像
sudo docker load -i images/odoo-17.tar
sudo docker load -i images/postgres-15.tar

# 创建目录
sudo mkdir -p /opt/odoo/{config,addons,data,postgres}

# 启动服务
sudo docker-compose up -d
```

### 首次使用 Odoo

1. 访问 http://服务器IP:8069
2. 填写 Master Password: `admin123`
3. 创建新数据库
4. 安装知识库模块

---

## 开发计划

- [x] Odoo 17 部署
- [x] PostgreSQL 15 部署
- [ ] Odoo 知识库模块配置
- [ ] Dify 知识库配置
- [ ] 数据同步脚本开发
- [ ] 定时同步任务配置
- [ ] 一键部署脚本完善

---

**版本**: v1.0  
**更新日期**: 2026-04-07
