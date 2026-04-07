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
| PostgreSQL (Dify) | postgres | - | Dify 数据存储 |
| PostgreSQL (Odoo) | odoo | odoo123 | Odoo 数据存储 |
| Redis (Dify) | - | - | Dify 缓存 |
| Weaviate (Dify) | - | - | Dify 向量数据库 |

### 1.3 容器列表

| 容器名 | 镜像 | 端口 | 说明 |
|--------|------|------|------|
| docker-api-1 | dify-api | 5001 | Dify API 服务 |
| docker-worker-1 | dify-api | - | Dify 后台任务 |
| docker-web-1 | dify-web | 80 | Dify Web 界面 |
| docker-db-1 | postgres | 5432 | Dify 数据库 |
| docker-redis-1 | redis | 6379 | Dify 缓存 |
| docker-weaviate-1 | weaviate | 8080 | Dify 向量库 |
| docker-sandbox-1 | dify-sandbox | 8194 | Dify 沙箱 |
| odoo-web | odoo:17 | 8069 | Odoo 服务 |
| odoo-db | postgres:15 | 5432 | Odoo 数据库 |

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
sudo docker ps | grep docker

# 查看 Ollama 容器
sudo docker ps | grep ollama
```

### 2.3 查看日志

```bash
# Odoo 日志
sudo docker logs odoo-web -f

# Odoo 数据库日志
sudo docker logs odoo-db -f

# Dify API 日志
sudo docker logs docker-api-1 -f

# Dify Worker 日志
sudo docker logs docker-worker-1 -f

# Dify Web 日志
sudo docker logs docker-web-1 -f
```

### 2.4 重启服务

```bash
# 重启 Odoo
cd /opt/odoo
sudo docker-compose restart

# 重启 Dify
cd /opt/dify/docker
sudo docker-compose restart

# 重启单个容器
sudo docker restart docker-api-1
sudo docker restart odoo-web
```

### 2.5 停止/启动服务

```bash
# 停止 Odoo
cd /opt/odoo
sudo docker-compose down

# 启动 Odoo
sudo docker-compose up -d

# 停止 Dify
cd /opt/dify/docker
sudo docker-compose down

# 启动 Dify
sudo docker-compose up -d
```

---

## 三、Dify 操作

### 3.1 登录 Dify

1. 访问 http://192.168.108.116
2. 输入邮箱和密码登录
3. 首次访问需要创建管理员账户

### 3.2 创建 AI 应用

1. 点击 **创建应用**
2. 选择应用类型:
   - **聊天助手**: 对话式问答
   - **文本生成**: 单次文本生成
   - **Agent**: 智能代理
   - **工作流**: 复杂流程编排
3. 输入应用名称
4. 配置模型:
   - 模型供应商: Ollama
   - 模型: deepseek-r1:32b 或 qwq:latest
5. 编写提示词
6. 保存并发布

### 3.3 创建知识库

1. 点击顶部 **知识库** 菜单
2. 点击 **创建知识库**
3. 输入知识库名称
4. 上传文档:
   - 支持格式: PDF、Word、TXT、Markdown
   - 单个文件最大 15MB
5. 等待文档处理:
   - 文档分段
   - 向量化
   - 索引构建
6. 处理完成后可查看分段结果

### 3.4 关联知识库到应用

1. 进入应用编辑页面
2. 点击左侧 **上下文** 设置
3. 点击 **添加** 选择知识库
4. 保存设置
5. 测试问答效果

### 3.5 用户管理

```bash
# 查看所有用户
sudo docker exec docker-db-1 psql -U postgres -d dify -c "SELECT id, name, email, status FROM accounts;"

# 查看用户权限
sudo docker exec docker-db-1 psql -U postgres -d dify -c "SELECT a.name, a.email, taj.role FROM tenant_account_joins taj JOIN accounts a ON taj.account_id = a.id;"
```

### 3.6 Dify 数据库操作

```bash
# 连接 Dify 数据库
sudo docker exec -it docker-db-1 psql -U postgres -d dify

# 查看所有表
\dt

# 查看应用列表
SELECT id, name, mode FROM apps;

# 查看知识库列表
SELECT id, name FROM datasets;

# 退出
\q
```

---

## 四、Odoo 操作

### 4.1 首次配置

1. 访问 http://192.168.108.116:8069
2. 填写 Master Password: `admin123`
3. 创建数据库:
   - Database Name: `knowledge_base`
   - Email: `admin@company.com`
   - Password: `admin`
   - Language: 简体中文
   - Country: China
4. 点击 "Create database"

### 4.2 安装知识库模块

1. 进入主界面后，点击 "Apps"
2. 搜索 "Knowledge" 或 "知识库"
3. 点击 "Install" 安装
4. 推荐安装模块:
   - Knowledge (知识库)
   - Documents (文档管理)
   - Sign (电子签名)

### 4.3 创建文档分类

1. 进入 Knowledge 模块
2. 创建分类:
   - 部署手册
   - 故障案例
   - 技术规范
   - 操作流程
3. 添加文档内容

### 4.4 Odoo 数据库操作

```bash
# 连接 Odoo 数据库
sudo docker exec -it odoo-db psql -U odoo -d knowledge_base

# 查看已安装模块
SELECT name FROM ir_module_module WHERE state = 'installed';

# 退出
\q
```

---

## 五、Ollama 操作

### 5.1 查看模型列表

```bash
# 通过 API 查看
curl http://localhost:11434/api/tags

# 通过命令行查看
ollama list
```

### 5.2 运行模型

```bash
# 运行 deepseek-r1
ollama run deepseek-r1:32b

# 运行 qwq
ollama run qwq:latest
```

### 5.3 模型管理

```bash
# 拉取新模型
ollama pull <模型名>

# 删除模型
ollama rm <模型名>

# 查看模型信息
ollama show <模型名>
```

---

## 六、数据同步 (待开发)

### 6.1 同步流程

```
Odoo 文档 → Python 脚本 → Dify API → 知识库
```

### 6.2 配置定时任务

```bash
# 编辑 crontab
crontab -e

# 每小时同步一次
0 * * * * /opt/odoo/sync/sync_to_dify.py
```

---

## 七、故障排查

### 7.1 Odoo 无法访问

```bash
# 检查容器状态
sudo docker ps | grep odoo

# 检查端口
sudo netstat -tlnp | grep 8069

# 查看日志
sudo docker logs odoo-web --tail 100

# 检查权限
ls -la /opt/odoo/data
sudo chown -R 101:101 /opt/odoo/data
```

### 7.2 Dify 无法访问

```bash
# 检查容器状态
sudo docker ps | grep docker

# 检查端口
sudo netstat -tlnp | grep 80

# 查看 API 日志
sudo docker logs docker-api-1 --tail 100

# 查看 Nginx 日志
sudo docker logs docker-web-1 --tail 100
```

### 7.3 数据库连接失败

```bash
# 检查 PostgreSQL 容器
sudo docker ps | grep postgres

# 进入数据库容器
sudo docker exec -it odoo-db psql -U odoo -d postgres

# 检查连接
sudo docker exec odoo-web ping odoo-db
```

### 7.4 AI 模型无响应

```bash
# 检查 Ollama 服务
curl http://localhost:11434/api/tags

# 检查模型
ollama list

# 查看 GPU 状态
nvidia-smi

# 重启 Ollama
sudo systemctl restart ollama
```

### 7.5 Dify 登录失败

```bash
# 检查 Redis 缓存
sudo docker exec docker-redis-1 redis-cli ping

# 清除登录限制缓存
sudo docker exec docker-redis-1 redis-cli KEYS '*login_error*'
sudo docker exec docker-redis-1 redis-cli DEL 'login_error_rate_limit:<邮箱>'

# 查看用户状态
sudo docker exec docker-db-1 psql -U postgres -d dify -c "SELECT email, status FROM accounts WHERE email = '<邮箱>';"
```

---

## 八、备份与恢复

### 8.1 备份 Odoo 数据

```bash
# 备份 PostgreSQL
sudo docker exec odoo-db pg_dump -U odoo knowledge_base > /backup/odoo_$(date +%Y%m%d).sql

# 备份文件存储
sudo tar -czvf /backup/odoo_data_$(date +%Y%m%d).tar.gz /opt/odoo/data
```

### 8.2 备份 Dify 数据

```bash
# 备份 PostgreSQL
sudo docker exec docker-db-1 pg_dump -U postgres dify > /backup/dify_$(date +%Y%m%d).sql

# 备份 Weaviate 向量数据
sudo docker exec docker-weaviate-1 curl -s http://localhost:8080/v1/schema > /backup/weaviate_schema_$(date +%Y%m%d).json
```

### 8.3 恢复数据

```bash
# 恢复 Odoo 数据库
cat /backup/odoo_20260407.sql | sudo docker exec -i odoo-db psql -U odoo knowledge_base

# 恢复 Dify 数据库
cat /backup/dify_20260407.sql | sudo docker exec -i docker-db-1 psql -U postgres dify

# 恢复文件
sudo tar -xzvf /backup/odoo_data_20260407.tar.gz -C /
```

---

## 九、常用命令速查

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
| 查看 Ollama 模型 | `ollama list` |
| 查看 Dify 用户 | `sudo docker exec docker-db-1 psql -U postgres -d dify -c "SELECT email, name FROM accounts;"` |

---

**版本**: v1.1  
**更新日期**: 2026-04-07
