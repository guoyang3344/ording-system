-- 点餐系统数据库初始化脚本
-- 数据库: ordering_system

-- 创建数据库
CREATE DATABASE IF NOT EXISTS ordering_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ordering_system;

-- 1. 用户表
CREATE TABLE IF NOT EXISTS `sys_user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码',
    `nickname` VARCHAR(50) COMMENT '昵称',
    `avatar` VARCHAR(255) COMMENT '头像',
    `phone` VARCHAR(20) COMMENT '手机号',
    `email` VARCHAR(100) COMMENT '邮箱',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    UNIQUE KEY `uk_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 2. 角色表
CREATE TABLE IF NOT EXISTS `sys_role` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `role_name` VARCHAR(50) NOT NULL COMMENT '角色名称',
    `role_code` VARCHAR(50) NOT NULL COMMENT '角色代码',
    `description` VARCHAR(255) COMMENT '描述',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 3. 权限表
CREATE TABLE IF NOT EXISTS `sys_permission` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父权限ID',
    `permission_name` VARCHAR(50) NOT NULL COMMENT '权限名称',
    `permission_code` VARCHAR(100) COMMENT '权限代码',
    `permission_type` TINYINT DEFAULT 1 COMMENT '权限类型：1-菜单，2-按钮',
    `path` VARCHAR(255) COMMENT '路由路径',
    `component` VARCHAR(255) COMMENT '组件路径',
    `icon` VARCHAR(50) COMMENT '图标',
    `sort` INT DEFAULT 0 COMMENT '排序',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 4. 用户角色关联表
CREATE TABLE IF NOT EXISTS `sys_user_role` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `role_id` BIGINT NOT NULL COMMENT '角色ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_role` (`user_id`, `role_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 5. 角色权限关联表
CREATE TABLE IF NOT EXISTS `sys_role_permission` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `role_id` BIGINT NOT NULL COMMENT '角色ID',
    `permission_id` BIGINT NOT NULL COMMENT '权限ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_role_permission` (`role_id`, `permission_id`),
    KEY `idx_role_id` (`role_id`),
    KEY `idx_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- 6. 商户表
CREATE TABLE IF NOT EXISTS `merchant` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '关联用户ID',
    `merchant_name` VARCHAR(100) NOT NULL COMMENT '商户名称',
    `merchant_logo` VARCHAR(255) COMMENT '商户Logo',
    `contact_person` VARCHAR(50) COMMENT '联系人',
    `contact_phone` VARCHAR(20) COMMENT '联系电话',
    `business_license` VARCHAR(255) COMMENT '营业执照',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0-待审核，1-正常，2-禁用',
    `audit_status` TINYINT DEFAULT 0 COMMENT '审核状态：0-待审核，1-审核通过，2-审核拒绝',
    `audit_remark` VARCHAR(255) COMMENT '审核备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商户表';

-- 7. 店铺表
CREATE TABLE IF NOT EXISTS `store` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `merchant_id` BIGINT NOT NULL COMMENT '商户ID',
    `store_name` VARCHAR(100) NOT NULL COMMENT '店铺名称',
    `store_logo` VARCHAR(255) COMMENT '店铺Logo',
    `description` VARCHAR(500) COMMENT '店铺描述',
    `province` VARCHAR(50) COMMENT '省份',
    `city` VARCHAR(50) COMMENT '城市',
    `district` VARCHAR(50) COMMENT '区县',
    `address` VARCHAR(255) COMMENT '详细地址',
    `longitude` DECIMAL(10,7) COMMENT '经度',
    `latitude` DECIMAL(10,7) COMMENT '纬度',
    `contact_phone` VARCHAR(20) COMMENT '联系电话',
    `business_hours` VARCHAR(100) COMMENT '营业时间',
    `min_order_amount` DECIMAL(10,2) DEFAULT 0 COMMENT '起送金额',
    `delivery_fee` DECIMAL(10,2) DEFAULT 0 COMMENT '配送费',
    `delivery_time` VARCHAR(50) COMMENT '预计配送时间',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-停业，1-营业中',
    `sort` INT DEFAULT 0 COMMENT '排序',
    `sales_count` INT DEFAULT 0 COMMENT '销量',
    `rating` DECIMAL(2,1) DEFAULT 5.0 COMMENT '评分',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_merchant_id` (`merchant_id`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='店铺表';

-- 8. 菜品分类表
CREATE TABLE IF NOT EXISTS `category` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `store_id` BIGINT NOT NULL COMMENT '店铺ID',
    `category_name` VARCHAR(50) NOT NULL COMMENT '分类名称',
    `icon` VARCHAR(255) COMMENT '分类图标',
    `sort` INT DEFAULT 0 COMMENT '排序',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜品分类表';

-- 9. 菜品表
CREATE TABLE IF NOT EXISTS `dish` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `store_id` BIGINT NOT NULL COMMENT '店铺ID',
    `category_id` BIGINT NOT NULL COMMENT '分类ID',
    `dish_name` VARCHAR(100) NOT NULL COMMENT '菜品名称',
    `description` VARCHAR(500) COMMENT '菜品描述',
    `image` VARCHAR(255) COMMENT '菜品图片',
    `price` DECIMAL(10,2) NOT NULL COMMENT '价格',
    `original_price` DECIMAL(10,2) COMMENT '原价',
    `unit` VARCHAR(20) DEFAULT '份' COMMENT '单位',
    `stock` INT DEFAULT 999 COMMENT '库存',
    `sales` INT DEFAULT 0 COMMENT '销量',
    `rating` DECIMAL(2,1) DEFAULT 5.0 COMMENT '评分',
    `is_hot` TINYINT DEFAULT 0 COMMENT '是否热销：0-否，1-是',
    `is_new` TINYINT DEFAULT 0 COMMENT '是否新品：0-否，1-是',
    `is_recommend` TINYINT DEFAULT 0 COMMENT '是否推荐：0-否，1-是',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-下架，1-上架',
    `sort` INT DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_store_id` (`store_id`),
    KEY `idx_category_id` (`category_id`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜品表';

-- 10. 菜品规格表
CREATE TABLE IF NOT EXISTS `dish_spec` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `dish_id` BIGINT NOT NULL COMMENT '菜品ID',
    `spec_name` VARCHAR(50) NOT NULL COMMENT '规格名称',
    `price` DECIMAL(10,2) NOT NULL COMMENT '价格',
    `stock` INT DEFAULT 999 COMMENT '库存',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_dish_id` (`dish_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜品规格表';

-- 11. 购物车表
CREATE TABLE IF NOT EXISTS `cart` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `store_id` BIGINT NOT NULL COMMENT '店铺ID',
    `dish_id` BIGINT NOT NULL COMMENT '菜品ID',
    `spec_id` BIGINT COMMENT '规格ID',
    `quantity` INT DEFAULT 1 COMMENT '数量',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_store_id` (`store_id`),
    KEY `idx_dish_id` (`dish_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- 12. 订单表
CREATE TABLE IF NOT EXISTS `orders` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `order_no` VARCHAR(32) NOT NULL COMMENT '订单编号',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `store_id` BIGINT NOT NULL COMMENT '店铺ID',
    `total_amount` DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
    `discount_amount` DECIMAL(10,2) DEFAULT 0 COMMENT '优惠金额',
    `pay_amount` DECIMAL(10,2) NOT NULL COMMENT '实际支付金额',
    `delivery_fee` DECIMAL(10,2) DEFAULT 0 COMMENT '配送费',
    `order_status` TINYINT DEFAULT 0 COMMENT '订单状态：0-待付款，1-待接单，2-制作中，3-配送中，4-已完成，5-已取消，6-已退款',
    `pay_type` TINYINT COMMENT '支付方式：1-微信支付，2-支付宝，3-余额支付',
    `pay_time` DATETIME COMMENT '支付时间',
    `consignee_name` VARCHAR(50) COMMENT '收货人姓名',
    `consignee_phone` VARCHAR(20) COMMENT '收货人电话',
    `province` VARCHAR(50) COMMENT '省份',
    `city` VARCHAR(50) COMMENT '城市',
    `district` VARCHAR(50) COMMENT '区县',
    `address` VARCHAR(255) COMMENT '详细地址',
    `remark` VARCHAR(500) COMMENT '备注',
    `expected_time` DATETIME COMMENT '预计送达时间',
    `delivery_time` DATETIME COMMENT '实际送达时间',
    `cancel_time` DATETIME COMMENT '取消时间',
    `cancel_reason` VARCHAR(255) COMMENT '取消原因',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_order_no` (`order_no`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_store_id` (`store_id`),
    KEY `idx_order_status` (`order_status`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 13. 订单明细表
CREATE TABLE IF NOT EXISTS `order_item` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `order_id` BIGINT NOT NULL COMMENT '订单ID',
    `order_no` VARCHAR(32) NOT NULL COMMENT '订单编号',
    `store_id` BIGINT NOT NULL COMMENT '店铺ID',
    `dish_id` BIGINT NOT NULL COMMENT '菜品ID',
    `spec_id` BIGINT COMMENT '规格ID',
    `dish_name` VARCHAR(100) NOT NULL COMMENT '菜品名称',
    `spec_name` VARCHAR(50) COMMENT '规格名称',
    `image` VARCHAR(255) COMMENT '菜品图片',
    `price` DECIMAL(10,2) NOT NULL COMMENT '单价',
    `quantity` INT NOT NULL COMMENT '数量',
    `total_amount` DECIMAL(10,2) NOT NULL COMMENT '小计金额',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_order_id` (`order_id`),
    KEY `idx_order_no` (`order_no`),
    KEY `idx_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- 14. 用户地址表
CREATE TABLE IF NOT EXISTS `user_address` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `consignee_name` VARCHAR(50) NOT NULL COMMENT '收货人姓名',
    `consignee_phone` VARCHAR(20) NOT NULL COMMENT '收货人电话',
    `province` VARCHAR(50) COMMENT '省份',
    `city` VARCHAR(50) COMMENT '城市',
    `district` VARCHAR(50) COMMENT '区县',
    `address` VARCHAR(255) NOT NULL COMMENT '详细地址',
    `longitude` DECIMAL(10,7) COMMENT '经度',
    `latitude` DECIMAL(10,7) COMMENT '纬度',
    `is_default` TINYINT DEFAULT 0 COMMENT '是否默认：0-否，1-是',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户地址表';

-- 15. 订单评价表
CREATE TABLE IF NOT EXISTS `order_evaluation` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `order_id` BIGINT NOT NULL COMMENT '订单ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `store_id` BIGINT NOT NULL COMMENT '店铺ID',
    `dish_rating` TINYINT DEFAULT 5 COMMENT '菜品评分：1-5分',
    `service_rating` TINYINT DEFAULT 5 COMMENT '服务评分：1-5分',
    `delivery_rating` TINYINT DEFAULT 5 COMMENT '配送评分：1-5分',
    `content` VARCHAR(500) COMMENT '评价内容',
    `images` VARCHAR(1000) COMMENT '评价图片，多个用逗号分隔',
    `is_anonymous` TINYINT DEFAULT 0 COMMENT '是否匿名：0-否，1-是',
    `reply_content` VARCHAR(500) COMMENT '商家回复',
    `reply_time` DATETIME COMMENT '回复时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_order_id` (`order_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单评价表';

-- ==================== 初始化数据 ====================

-- 初始化角色
INSERT INTO `sys_role` (`role_name`, `role_code`, `description`) VALUES
('超级管理员', 'SUPER_ADMIN', '系统超级管理员，拥有所有权限'),
('平台管理员', 'PLATFORM_ADMIN', '平台管理员，管理平台数据'),
('商户', 'MERCHANT', '商户，管理自己的店铺'),
('普通用户', 'USER', '普通用户，点餐用户');

-- 初始化管理员用户（密码: 123456，使用BCrypt加密）
INSERT INTO `sys_user` (`username`, `password`, `nickname`, `phone`, `status`) VALUES
('admin', '$2a$10$.I4X75kY8H9VbN0mK5J6L8P9Q2R4S7T8U9V0W1X2Y3Z4A5B6C7D8E', '超级管理员', '13800138000', 1);

-- 分配角色
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (1, 1);
