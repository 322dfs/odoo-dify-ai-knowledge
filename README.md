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
┌─────────────────────────────────────────────────────────────────────────┐
│                           内网服务器 (192.168.108.116)                    │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │                    AI 问答服务 (Dify 1.4.0)                         │ │
│  │                                                                     │ │
│  │   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐           │ │
│  │   │   Dify      │    │ PostgreSQL  │    │   Redis     │           │ │
│  │   │   Web UI    │    │   :5432     │    │   :6379     │           │ │
│  │   │   :80       │    │  (Dify DB)  │    │  (Cache)    │           │ │
│  │   └─────────────┘    └─────────────┘    └─────────────┘           │ │
│  │          │                  │                  │                   │ │
│  │          ▼                  ▼                  ▼                   │ │
│  │   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐           │ │
│  │   │  Dify API   │    │  Dify       │    │  Weaviate   │           │ │
│  │   │  Worker     │    │  Sandbox    │    │  向量数据库  │           │ │
│  │   └─────────────┘    └─────────────┘    └─────────────┘           │ │
│  │                                                                     │ │
│  │   功能：AI 对话、知识库管理、RAG 检索、工作流编排                      │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                    │                                     │
│                                    ▼                                     │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │                    本地大模型 (Ollama)                              │ │
│  │                                                                     │ │
│  │   ┌─────────────────────────────────────────────────────────────┐  │ │
│  │   │  GPU: 2× RTX 2080 Ti (22GB 显存)                            │  │ │
│  │   │  模型: deepseek-r1:32b / qwq:latest                         │  │ │
│  │   │  端口: :11434                                                │  │ │
│  │   └─────────────────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                    │                                     │
│                                    ▼                                     │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │                    知识库服务 (Odoo 17)                             │ │
│  │                                                                     │ │
│  │   ┌─────────────┐              ┌─────────────┐                     │ │
│  │   │   Odoo 17   │              │ PostgreSQL  │                     │ │
│  │   │   知识库     │◄────────────┤   :5432     │                     │ │
│  │   │   :8069     │              │ (Odoo DB)   │                     │ │
│  │   └─────────────┘              └─────────────┘                     │ │
│  │                                                                     │ │
│  │   功能：文档管理、知识分类、权限控制、版本管理                         │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                    │                                     │
│                                    ▼                                     │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │                    数据同步服务 (Python)                            │ │
│  │                                                                     │ │
│  │   Odoo 文档 ────► Python 同步脚本 ────► Dify 知识库                 │ │
│  │                                                                     │ │
│  │   功能：定时同步、增量更新、格式转换                                  │ │
│  └────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 功能特性

### 🤖 Dify AI 问答平台

| 功能 | 说明 |
|------|------|
| **AI 对话** | 基于 DeepSeek-R1 的智能问答 |
| **知识库** | 支持 PDF、Word、Markdown 等格式文档上传 |
| **RAG 检索** | 向量化检索，精准定位知识内容 |
| **工作流** | 可视化编排 AI 工作流程 |
| **多模型支持** | 可接入 Ollama 本地模型或 API 模型 |

### 📚 Odoo 知识库系统

| 功能 | 说明 |
|------|------|
| **文档管理** | 多级分类、标签管理、版本控制 |
| **权限控制** | 按部门、角色设置访问权限 |
| **协作编辑** | 多人协作、评论、审批流程 |
| **搜索功能** | 全文检索、高级筛选 |

### 🔗 系统集成

| 功能 | 说明 |
|------|------|
| **数据同步** | Odoo 文档自动同步到 Dify 知识库 |
| **定时任务** | 支持定时增量同步 |
| **日志追踪** | 完整的同步日志和错误处理 |

---

## 文件说明

```
odoo-dify-ai-knowledge/
├── README.md                 # 本文档（部署指南）
├── PROJECT_OVERVIEW.md       # 项目详细概述
├── OPERATION_GUIDE.md        # 操作手册（日常运维）
├── 视频演示剧本.md            # 视频演示剧本
├── docker-compose.yml        # Odoo 服务编排配置
├── odoo.conf                 # Odoo 配置文件
├── build-images.sh           # 一键导出镜像脚本
├── deploy-offline.sh         # 离线部署脚本
├── export-images.sh          # 镜像导出脚本
├── package.sh                # 打包脚本
└── images/                   # 镜像文件目录（需自行生成）
    ├── odoo-17.tar           # Odoo 17 镜像 (~570MB)
    └── postgres-15.tar       # PostgreSQL 15 镜像 (~150MB)
```

---

## 快速访问

| 服务 | 地址 | 说明 |
|------|------|------|
| **Dify AI 平台** | http://192.168.108.116 | AI 问答、知识库管理 |
| **Odoo 知识库** | http://192.168.108.116:8069 | 文档管理、知识分类 |
| **Ollama API** | http://192.168.108.116:11434 | 本地大模型接口 |

---

## 部署指南

### 前置条件

| 条件 | 要求 | 检查命令 |
|------|------|----------|
| 操作系统 | Ubuntu 20.04+ / CentOS 7+ | `cat /etc/os-release` |
| Docker | 20.10+ | `docker --version` |
| Docker Compose | v2.0+ | `docker-compose --version` |
| 内存 | 最低 8GB，推荐 16GB+ | `free -h` |
| GPU | 推荐 NVIDIA GPU（用于本地模型） | `nvidia-smi` |
| 磁盘 | 最低 50GB 可用空间 | `df -h` |

---

### 方式一：有网络环境部署

适用于服务器可访问外网的情况。

#### 步骤 1：克隆项目

```bash
git clone https://github.com/322dfs/odoo-dify-ai-knowledge.git
cd odoo-dify-ai-knowledge
```

#### 步骤 2：拉取 Docker 镜像

```bash
# 拉取 Odoo 17 镜像
docker pull odoo:17

# 拉取 PostgreSQL 15 镜像
docker pull postgres:15

# 验证镜像
docker images | grep -E "odoo|postgres"
```

#### 步骤 3：创建目录结构

```bash
# 创建 Odoo 数据目录
sudo mkdir -p /opt/odoo/{config,addons,data,postgres}

# 查看目录结构
tree /opt/odoo
```

目录说明：
| 目录 | 用途 |
|------|------|
| `/opt/odoo/config` | Odoo 配置文件 |
| `/opt/odoo/addons` | 自定义模块 |
| `/opt/odoo/data` | Odoo 数据文件 |
| `/opt/odoo/postgres` | PostgreSQL 数据 |

#### 步骤 4：复制配置文件

```bash
# 复制 docker-compose.yml
sudo cp docker-compose.yml /opt/odoo/

# 复制 odoo.conf
sudo cp odoo.conf /opt/odoo/config/

# 验证文件
ls -la /opt/odoo/
ls -la /opt/odoo/config/
```

#### 步骤 5：启动服务

```bash
# 进入部署目录
cd /opt/odoo

# 启动服务（后台运行）
sudo docker-compose up -d

# 等待服务启动（约 30 秒）
sleep 30
```

#### 步骤 6：验证部署

```bash
# 检查容器状态
sudo docker-compose ps

# 检查 Odoo 服务
curl -I http://localhost:8069

# 查看日志
sudo docker-compose logs -f
```

---

### 方式二：无网络环境部署（离线部署）

适用于服务器无法访问外网的情况。需要在有网络的机器上准备镜像文件。

#### 步骤 1：在有网络机器上准备镜像

```bash
# 克隆项目
git clone https://github.com/322dfs/odoo-dify-ai-knowledge.git
cd odoo-dify-ai-knowledge

# 赋予执行权限
chmod +x build-images.sh

# 执行一键导出（自动拉取并导出镜像）
./build-images.sh
```

导出过程约需 5-10 分钟，完成后显示：
```
镜像文件列表：
-rw------- 1 root root 568M odoo-17.tar
-rw------- 1 root root 147M postgres-15.tar

总大小：
715M    images/
```

#### 步骤 2：传输文件到目标服务器

**方式 A：使用 SCP 传输**
```bash
# 传输整个项目目录
scp -r odoo-dify-ai-knowledge user@server-ip:/tmp/

# 或只传输必要文件
scp -r images/ docker-compose.yml odoo.conf deploy-offline.sh user@server-ip:/tmp/odoo/
```

**方式 B：使用 U 盘或其他介质**
```bash
# 打包项目
tar -czvf odoo-dify-offline.tar.gz odoo-dify-ai-knowledge/

# 复制到 U 盘后，在目标服务器解压
tar -xzvf odoo-dify-offline.tar.gz
```

#### 步骤 3：在目标服务器上部署

```bash
# 进入项目目录
cd /tmp/odoo-dify-ai-knowledge

# 赋予执行权限
chmod +x deploy-offline.sh

# 执行离线部署脚本
sudo ./deploy-offline.sh
```

或手动执行：

```bash
# 1. 导入镜像
sudo docker load -i images/odoo-17.tar
sudo docker load -i images/postgres-15.tar

# 2. 创建目录
sudo mkdir -p /opt/odoo/{config,addons,data,postgres}

# 3. 复制配置文件
sudo cp docker-compose.yml /opt/odoo/
sudo cp odoo.conf /opt/odoo/config/

# 4. 启动服务
cd /opt/odoo
sudo docker-compose up -d
```

#### 步骤 4：验证部署

```bash
# 检查容器状态
sudo docker ps

# 检查服务响应
curl -I http://localhost:8069
```

---

## 首次使用指南

### Dify AI 平台

#### 步骤 1：访问 Dify

浏览器访问：`http://服务器IP`

#### 步骤 2：创建管理员账户

首次访问会显示设置页面：
1. 输入 **邮箱**
2. 输入 **用户名**
3. 输入 **密码**
4. 点击 **设置**

#### 步骤 3：创建 AI 应用

1. 点击 **创建应用**
2. 选择 **聊天助手** 或 **工作流**
3. 配置模型（选择 Ollama 本地模型）
4. 开始对话测试

#### 步骤 4：创建知识库

1. 点击 **知识库** 菜单
2. 点击 **创建知识库**
3. 上传文档（PDF、Word、Markdown 等）
4. 等待文档处理完成
5. 在应用中关联知识库

---

### Odoo 知识库

#### 步骤 1：访问 Odoo

浏览器访问：`http://服务器IP:8069`

#### 步骤 2：创建数据库

1. 填写 **Master Password**: `admin123`
2. 填写数据库信息：
   - **Database Name**: `knowledge_base`（自定义）
   - **Email**: `admin@company.com`（自定义）
   - **Password**: `admin`（自定义，请修改）
   - **Phone number**: 可留空
   - **Language**: `简体中文`
   - **Country**: `China`
3. 点击 **Create database**

#### 步骤 3：安装知识库模块

1. 进入主界面，点击 **Apps**（应用）
2. 搜索 **Knowledge** 或 **知识库**
3. 点击 **Install** 安装
4. 推荐安装模块：
   - Knowledge（知识库）
   - Documents（文档管理）
   - Sign（电子签名）

#### 步骤 4：创建文档分类

1. 进入 **Knowledge** 模块
2. 创建分类结构：
   - 部署手册
   - 故障案例
   - 技术规范
   - 操作流程
3. 添加文档内容

---

## 常见问题

### Q1: Odoo 显示 500 错误

**原因**: 数据目录权限问题

**解决**:
```bash
sudo chown -R 101:101 /opt/odoo/data
sudo chmod -R 755 /opt/odoo/data
sudo docker-compose restart odoo-web
```

### Q2: 数据库连接失败

**原因**: PostgreSQL 未启动或连接配置错误

**解决**:
```bash
# 检查数据库容器
sudo docker ps | grep postgres

# 查看数据库日志
sudo docker logs odoo-db

# 重启数据库
sudo docker-compose restart odoo-db
```

### Q3: 端口被占用

**原因**: 8069 端口已被其他服务使用

**解决**:
```bash
# 查看端口占用
sudo netstat -tlnp | grep 8069

# 修改 docker-compose.yml 中的端口映射
ports:
  - "8070:8069"  # 改为其他端口
```

### Q4: 容器无法启动

**原因**: 镜像未正确导入或损坏

**解决**:
```bash
# 重新导入镜像
sudo docker load -i images/odoo-17.tar
sudo docker load -i images/postgres-15.tar

# 验证镜像完整性
sudo docker images | grep -E "odoo|postgres"
```

### Q5: Dify 登录失败

**原因**: 账户未创建或密码错误

**解决**:
1. 确认已创建管理员账户
2. 检查 Redis 缓存是否正常
3. 查看日志排查问题

---

## 服务管理命令

| 操作 | 命令 |
|------|------|
| 启动服务 | `cd /opt/odoo && sudo docker-compose up -d` |
| 停止服务 | `cd /opt/odoo && sudo docker-compose down` |
| 重启服务 | `cd /opt/odoo && sudo docker-compose restart` |
| 查看状态 | `sudo docker-compose ps` |
| 查看日志 | `sudo docker-compose logs -f` |
| 进入容器 | `sudo docker exec -it odoo-web bash` |

---

## 开发计划

- [x] Odoo 17 部署
- [x] PostgreSQL 15 部署
- [x] Dify 1.4.0 部署
- [x] Ollama 本地模型集成
- [x] 离线部署脚本
- [x] 项目文档完善
- [ ] Odoo 知识库模块配置
- [ ] Dify 知识库配置
- [ ] 数据同步脚本开发
- [ ] 定时同步任务配置

---

## 相关文档

- [项目详细概述](PROJECT_OVERVIEW.md) - 架构设计和技术细节
- [操作手册](OPERATION_GUIDE.md) - 日常运维和故障排查
- [视频演示剧本](视频演示剧本.md) - 系统演示流程

---

## 联系方式

如有问题或建议，欢迎联系：

- **GitHub Issues**: https://github.com/322dfs/odoo-dify-ai-knowledge/issues
- **项目维护者**: SUBENCAI
- **邮箱**: 2080981057@qq.com

---

**版本**: v1.1  
**更新日期**: 2026-04-07  
**GitHub**: https://github.com/322dfs/odoo-dify-ai-knowledge
