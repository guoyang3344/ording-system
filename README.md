# 点餐系统 - 前后端分离项目

## 项目介绍

这是一个完整的前后端分离点餐系统，采用现代化技术栈开发，支持多商户、多店铺管理。

### 技术栈

**后端：**
- Spring Boot 2.7.18
- MyBatis-Plus 3.5.3.1
- MySQL 8.0+
- Spring Security + JWT
- Druid 数据库连接池
- Knife4j (API文档)
- Hutool 工具库

**前端：**
- Vue 3
- Vite 4
- Element Plus 2
- Vue Router 4
- Pinia (状态管理)
- Axios (HTTP请求)

### 系统功能

**用户端：**
- 用户注册/登录
- 浏览店铺列表
- 查看店铺详情和菜单
- 添加菜品到购物车
- 提交订单
- 查看订单状态
- 个人中心和地址管理

**管理端：**
- 数据概览
- 店铺管理
- 菜品管理
- 分类管理
- 订单管理
- 用户管理

### 数据库表设计

- `sys_user` - 用户表
- `sys_role` - 角色表
- `sys_permission` - 权限表
- `sys_user_role` - 用户角色关联表
- `sys_role_permission` - 角色权限关联表
- `merchant` - 商户表
- `store` - 店铺表
- `category` - 菜品分类表
- `dish` - 菜品表
- `dish_spec` - 菜品规格表
- `cart` - 购物车表
- `orders` - 订单表
- `order_item` - 订单明细表
- `user_address` - 用户地址表
- `order_evaluation` - 订单评价表

## 项目结构

```
demo02/
├── database/
│   └── init.sql           # 数据库初始化脚本
├── backend/                # 后端项目
│   ├── pom.xml
│   └── src/
│       └── main/
│           ├── java/com/ordering/
│           │   ├── config/          # 配置类
│           │   ├── controller/      # 控制器
│           │   ├── dto/             # 数据传输对象
│           │   ├── entity/          # 实体类
│           │   ├── exception/       # 异常处理
│           │   ├── mapper/          # Mapper接口
│           │   ├── security/        # 安全配置
│           │   ├── service/         # 服务层
│           │   │   └── impl/        # 服务实现
│           │   ├── util/            # 工具类
│           │   └── OrderingSystemApplication.java
│           └── resources/
│               └── application.yml   # 配置文件
├── frontend/               # 前端项目
│   ├── package.json
│   ├── vite.config.js
│   ├── index.html
│   └── src/
│       ├── api/            # API接口
│       ├── components/     # 公共组件
│       ├── router/         # 路由配置
│       ├── store/          # 状态管理
│       ├── styles/         # 样式文件
│       ├── utils/          # 工具函数
│       ├── views/          # 页面组件
│       │   ├── admin/      # 管理端页面
│       │   ├── cart/       # 购物车
│       │   ├── home/       # 首页
│       │   ├── login/      # 登录
│       │   ├── order/      # 订单
│       │   ├── register/   # 注册
│       │   ├── store/      # 店铺
│       │   └── user/       # 用户中心
│       ├── App.vue
│       └── main.js
└── start.bat               # 启动脚本
```

## 快速开始

### 环境要求

- JDK 8 或更高版本
- Maven 3.6+
- Node.js 16+ (npm 8+)
- MySQL 8.0+

### 安装步骤

**1. 数据库初始化**

```bash
# 登录 MySQL
mysql -u root -p

# 执行初始化脚本
source database/init.sql
```

**2. 修改数据库配置**

编辑 `backend/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ordering_system?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai
    username: root      # 修改为你的用户名
    password: root      # 修改为你的密码
```

**3. 启动后端**

```bash
cd backend
mvn spring-boot:run
```

或者直接运行 `start.bat` 脚本。

**4. 启动前端**

```bash
cd frontend
npm install
npm run dev
```

### 访问地址

- 前端地址: http://localhost:3000
- 后端地址: http://localhost:8080
- API文档: http://localhost:8080/doc.html
- Druid监控: http://localhost:8080/druid

### 默认账号

- 管理员: admin / 123456 (BCrypt加密)

## API 接口

### 认证接口

- `POST /api/auth/login` - 用户登录
- `POST /api/auth/register` - 用户注册
- `GET /api/auth/userinfo` - 获取用户信息
- `POST /api/auth/logout` - 用户登出

### 店铺接口

- `GET /api/public/store/list` - 获取店铺列表（公开）
- `GET /api/public/store/{id}` - 获取店铺详情（公开）
- `GET /api/store/page` - 分页获取店铺列表
- `POST /api/store` - 创建店铺
- `PUT /api/store` - 更新店铺
- `PUT /api/store/status/{id}` - 更新店铺状态

### 菜品接口

- `GET /api/public/dish/store/{storeId}` - 获取店铺菜品列表
- `GET /api/public/dish/{id}` - 获取菜品详情
- `GET /api/dish/page` - 分页获取菜品列表
- `POST /api/dish` - 创建菜品
- `PUT /api/dish` - 更新菜品
- `PUT /api/dish/status/{id}` - 更新菜品状态

## 开发说明

### 后端开发

- 实体类使用 `@TableName` 注解映射表名
- 使用 `BaseEntity` 作为基类，包含通用字段
- Mapper 继承 `BaseMapper` 获得基础 CRUD 能力
- Service 继承 `ServiceImpl` 实现基础服务

### 前端开发

- 使用 Composition API + `<script setup>` 语法
- 使用 Pinia 进行状态管理，支持持久化
- 使用 Element Plus 组件库
- API 统一封装在 `src/api/` 目录下
- 路由配置在 `src/router/index.js`

## 安全说明

- 密码使用 BCrypt 加密存储
- 接口使用 JWT Token 认证
- 敏感操作需要登录验证
- 支持跨域配置

## 后续扩展

- [ ] 支付集成（微信支付、支付宝）
- [ ] 实时订单推送（WebSocket）
- [ ] 图片上传（OSS/MinIO）
- [ ] 优惠券系统
- [ ] 会员积分系统
- [ ] 数据统计报表
- [ ] 移动端适配

## 许可证

MIT License
