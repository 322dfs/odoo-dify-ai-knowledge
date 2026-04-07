# Odoo + Dify AI 知识库 - 系统测试脚本
# 用于视频演示

$ServerIP = "192.168.108.116"
$ServerUser = "beeplux-ai-2080ti"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Odoo + Dify AI 知识库 - 系统测试" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$Passed = 0
$Failed = 0

function Test-Service {
    param($Name, $TestScript, $SuccessMessage)
    
    Write-Host "[$Name] 测试中..." -NoNewline
    try {
        $result = Invoke-Expression $TestScript 2>$null
        if ($result -match "OK|200|303|finished") {
            Write-Host " [通过]" -ForegroundColor Green
            Write-Host "  $SuccessMessage" -ForegroundColor Gray
            $script:Passed++
            return $true
        } else {
            Write-Host " [失败]" -ForegroundColor Red
            $script:Failed++
            return $false
        }
    } catch {
        Write-Host " [失败]" -ForegroundColor Red
        $script:Failed++
        return $false
    }
}

Write-Host "========== 1. SSH 连接测试 ==========" -ForegroundColor Yellow
Test-Service "SSH连接" "ssh $ServerUser@$ServerIP 'echo OK'" "SSH 免密登录成功"

Write-Host ""
Write-Host "========== 2. Docker 容器状态 ==========" -ForegroundColor Yellow
Write-Host "[容器列表]"
ssh $ServerUser@$ServerIP "sudo docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"

Write-Host ""
Write-Host "========== 3. Odoo 服务测试 ==========" -ForegroundColor Yellow
Test-Service "Odoo HTTP" "ssh $ServerUser@$ServerIP 'curl -s -o /dev/null -w %{http_code} http://localhost:8069/'" "Odoo 服务响应正常"

Write-Host ""
Write-Host "========== 4. Dify 服务测试 ==========" -ForegroundColor Yellow
Test-Service "Dify API" "ssh $ServerUser@$ServerIP 'curl -s http://localhost/console/api/setup'" "Dify 服务已初始化"

Write-Host ""
Write-Host "========== 5. Ollama 模型测试 ==========" -ForegroundColor Yellow
Write-Host "[可用模型]"
ssh $ServerUser@$ServerIP "curl -s http://localhost:11434/api/tags"

Write-Host ""
Write-Host "========== 6. GPU 状态 ==========" -ForegroundColor Yellow
ssh $ServerUser@$ServerIP "nvidia-smi --query-gpu=name,memory.total,memory.used --format=csv"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  测试结果: 通过 $Passed / 失败 $Failed" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "访问地址:" -ForegroundColor Yellow
Write-Host "  Odoo:  http://$ServerIP`:8069"
Write-Host "  Dify:  http://$ServerIP"
Write-Host ""
