# 操作手册

## 一、系统概览

### 1.1 服务状态

```
服务器: 192.168.108.116
用户: beeplux-ai-2080ti
SSH: 已配置免密登录
```

| 服务 | 状态 | 访问地址 |
|------|------|----------|
| Dify (AI问答) | ✅ 运行中 | http://192.168.108.116 |
| Odoo (知识库) | ✅ 运行中 | http://192.168.108.116:8069 |
| Ollama (大模型) | ✅ 运行中 | http://192.168.108.116:11434 |

### 1.2 数据库信息

| 数据库 | 用户 | 密码 | 用途 |
|--------|------|------|------|
| PostgreSQL (Dify) | - | - | Dify 数据存储 |
| PostgreSQL (Odoo) | odoo | odoo123 | Odoo 数据存储 |

---

## 二、日常操作

### 2.1 SSH 连接服务器

```bash
# 从 Windows 连接
ssh beeplux-ai-2080ti@192.168.108.116
```

### 2.2 查看 Docker 容器状态

```bash
# 查看所有容器
sudo docker ps -a

# 查看 Odoo 相关容器
sudo docker ps | grep odoo

# 查看 Dify 相关容器
sudo docker ps | grep -E "dify|api|worker"
```

### 2.3 查看日志

```bash
# Odoo 日志
sudo docker logs odoo-web -f

# Odoo 数据库日志
sudo docker logs odoo-db -f

# Dify API 日志
sudo docker logs docker-api-1 -f
```

### 2.4 重启服务

```bash
# 重启 Odoo
cd /opt/odoo
sudo docker-compose restart

# 重启 Dify
cd /opt/dify/docker
sudo docker-compose restart
```

### 2.5 停止/启动服务

```bash
# 停止 Odoo
cd /opt/odoo
sudo docker-compose down

# 启动 Odoo
sudo docker-compose up -d
```

---

## 三、Odoo 操作

### 3.1 首次配置

1. 访问 http://192.168.108.116:8069
2. 填写 Master Password: `admin123`
3. 创建数据库:
   - Database Name: `knowledge_base`
   - Email: `admin@company.com`
   - Password: `admin`
   - 勾选 "Demo data" (可选)
4. 点击 "Create database"

### 3.2 安装知识库模块

1. 进入主界面后，点击 "Apps"
2. 搜索 "Knowledge" 或 "知识库"
3. 点击 "Install" 安装
4. 推荐安装模块:
   - Knowledge (知识库)
   - Documents (文档管理)
   - Sign (电子签名)

### 3.3 创建文档分类

1. 进入 Knowledge 模块
2. 创建分类:
   - 部署手册
   - 故障案例
   - 技术规范
   - 操作流程
3. 添加文档内容

---

## 四、Dify 操作

### 4.1 创建知识库

1. 访问 http://192.168.108.116
2. 进入 "知识库" 页面
3. 点击 "创建知识库"
4. 上传文档或导入数据

### 4.2 创建 AI 应用

1. 进入 "工作室" 页面
2. 创建新应用
3. 选择模型: deepseek-r1:32b 或 qwq:latest
4. 关联知识库
5. 配置提示词

---

## 五、数据同步 (待开发)

### 5.1 同步流程

```
Odoo 文档 → Python 脚本 → Dify API → 知识库
```

### 5.2 配置定时任务

```bash
# 编辑 crontab
crontab -e

# 每小时同步一次
0 * * * * /opt/odoo/sync/sync_to_dify.py
```

---

## 六、故障排查

### 6.1 Odoo 无法访问

```bash
# 检查容器状态
sudo docker ps | grep odoo

# 检查端口
sudo netstat -tlnp | grep 8069

# 查看日志
sudo docker logs odoo-web --tail 100
```

### 6.2 数据库连接失败

```bash
# 检查 PostgreSQL 容器
sudo docker ps | grep postgres

# 进入数据库容器
sudo docker exec -it odoo-db psql -U odoo -d postgres

# 检查连接
sudo docker exec odoo-web ping odoo-db
```

### 6.3 AI 模型无响应

```bash
# 检查 Ollama 服务
curl http://localhost:11434/api/tags

# 检查模型
ollama list

# 重启 Ollama
sudo systemctl restart ollama
```

---

## 七、备份与恢复

### 7.1 备份 Odoo 数据

```bash
# 备份 PostgreSQL
sudo docker exec odoo-db pg_dump -U odoo knowledge_base > /backup/odoo_$(date +%Y%m%d).sql

# 备份文件存储
sudo tar -czvf /backup/odoo_data_$(date +%Y%m%d).tar.gz /opt/odoo/data
```

### 7.2 恢复数据

```bash
# 恢复数据库
cat /backup/odoo_20260407.sql | sudo docker exec -i odoo-db psql -U odoo knowledge_base

# 恢复文件
sudo tar -xzvf /backup/odoo_data_20260407.tar.gz -C /
```

---

## 八、常用命令速查

| 操作 | 命令 |
|------|------|
| SSH 连接 | `ssh beeplux-ai-2080ti@192.168.108.116` |
| 查看容器 | `sudo docker ps` |
| 查看日志 | `sudo docker logs <容器名> -f` |
| 重启服务 | `cd /opt/odoo && sudo docker-compose restart` |
| 进入容器 | `sudo docker exec -it <容器名> bash` |
| 查看磁盘 | `df -h` |
| 查看内存 | `free -h` |
| 查看 GPU | `nvidia-smi` |

---

**版本**: v1.0  
**更新日期**: 2026-04-07
