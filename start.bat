@echo off
echo ========================================
echo      点餐系统 - 启动脚本
echo ========================================
echo.

echo [1/3] 检查环境...
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Java 环境，请先安装 JDK 8+
    pause
    exit /b 1
)

where mvn >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Maven 环境，请先安装 Maven
    pause
    exit /b 1
)

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] 未找到 Node.js 环境，前端将无法启动
)

echo.
echo [2/3] 启动后端服务...
echo 正在启动 Spring Boot 服务 (端口: 8080)...
echo 请确保 MySQL 数据库已启动，并已执行 database/init.sql
echo.

cd /d "%~dp0backend"
start cmd /k "echo 后端服务正在启动... && mvn spring-boot:run"

echo 后端服务启动中... 请等待控制台输出 'Started OrderingSystemApplication'
echo.

timeout /t 5 /nobreak >nul

echo [3/3] 启动前端服务...
echo 正在启动 Vue 3 开发服务器 (端口: 3000)...
echo.

cd /d "%~dp0frontend"
start cmd /k "echo 前端服务正在启动... && npm install && npm run dev"

echo.
echo ========================================
echo      启动完成！
echo ========================================
echo.
echo 后端地址: http://localhost:8080
echo 前端地址: http://localhost:3000
echo API文档:  http://localhost:8080/doc.html
echo 数据库监控: http://localhost:8080/druid
echo.
echo 默认管理员账号: admin / 123456
echo.
echo 注意事项:
echo 1. 请确保 MySQL 数据库已创建并执行了初始化脚本
echo 2. 请修改 backend/src/main/resources/application.yml 中的数据库配置
echo 3. 首次启动前端需要安装依赖，请耐心等待
echo.
pause
