
-- ----------------------------
-- Table structure for sys_license_agreement
-- ----------------------------
DROP TABLE IF EXISTS `sys_license_agreement`;
CREATE TABLE `sys_license_agreement` (
                                         `id` varchar(64) NOT NULL COMMENT '主键ID',
                                         `name` varchar(255) DEFAULT NULL COMMENT '名称',
                                         `version` varchar(64) DEFAULT NULL COMMENT '版本号',
                                         `content` text COMMENT '内容',
                                         `type` varchar(32) DEFAULT NULL COMMENT '协议类型(PRIVACY:隐私协议,USER:用户协议,SERVICE:服务协议等)',
                                         `storage_path` varchar(512) DEFAULT NULL COMMENT '协议存储地址(文件路径/URL/对象存储key)',
                                         `effective_date` datetime DEFAULT NULL COMMENT '生效日期',
                                         `expire_date` datetime DEFAULT NULL COMMENT '失效日期',
                                         `remarks` varchar(512) DEFAULT NULL COMMENT '备注',
                                         `data_status` varchar(32) DEFAULT '01' COMMENT '数据状态：01 正常/active、02 已删除/deleted',
                                         `created_at` datetime DEFAULT NULL COMMENT '创建时间',
                                         `created_by` varchar(64) DEFAULT NULL COMMENT '创建人ID',
                                         `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
                                         `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
                                         `updated_by` varchar(64) DEFAULT NULL COMMENT '更新人ID',
                                         `updater_name` varchar(64) DEFAULT NULL COMMENT '更新人名称',
                                         PRIMARY KEY (`id`),
                                         KEY `idx_type` (`type`),
                                         KEY `idx_data_status` (`data_status`),
                                         KEY `idx_effective_date` (`effective_date`),
                                         KEY `idx_expire_date` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统授权协议表';


-- ----------------------------
-- Table structure for user_license_acceptance
-- ----------------------------
DROP TABLE IF EXISTS `user_license_acceptance`;
CREATE TABLE `user_license_acceptance` (
                                           `id` bigint(20) NOT NULL AUTO_INCREMENT,
                                           `user_id` bigint(20) NOT NULL COMMENT '用户ID',
                                           `user_name` varchar(100) DEFAULT NULL COMMENT '用户名称',
                                           `user_phone` varchar(20) DEFAULT NULL COMMENT '用户手机号',
                                           `license_id` bigint(20) NOT NULL COMMENT '协议ID',
                                           `license_type` tinyint(4) NOT NULL COMMENT '协议类型(与sys_license_agreement.type对应)',
                                           `license_version` varchar(50) NOT NULL COMMENT '协议版本号',
                                           `accept_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '接受时间',
                                           `ip_address` varchar(50) DEFAULT NULL COMMENT '接受时的IP地址',
                                           `device_info` varchar(200) DEFAULT NULL COMMENT '设备信息',
                                           PRIMARY KEY (`id`),
                                           KEY `idx_user_license` (`user_id`, `license_id`),
                                           KEY `idx_user_phone` (`user_phone`),
                                           KEY `idx_license_type_version` (`license_type`, `license_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户协议接受记录表';

-- ----------------------------
-- Table structure for sys_invoice
-- ----------------------------
DROP TABLE IF EXISTS `sys_invoice`;
CREATE TABLE `sys_invoice` (
                               `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                               `tenant_id` bigint(20) unsigned NOT NULL COMMENT '租户ID',
                               `business_type` tinyint(4) NOT NULL COMMENT '业务类型：01-货主企业 02-车队企业 03-平台企业 04-个人用户 05-司机 06-供应商',

    -- 具体业务ID字段（根据business_type选择使用哪个字段）
                               `shipper_id` bigint(20) unsigned NOT NULL COMMENT '货主ID（business_type=01时使用）',
                               `fleet_id` bigint(20) unsigned NOT NULL COMMENT '车队ID（business_type=02时使用）',
                               `platform_id` bigint(20) unsigned NOT NULL COMMENT '平台企业ID（business_type=03时使用）',
                               `user_id` bigint(20) unsigned NOT NULL COMMENT '个人用户ID（business_type=04时使用）',
                               `driver_id` bigint(20) unsigned NOT NULL COMMENT '司机ID（business_type=05时使用）',
                               `supplier_id` bigint(20) unsigned NOT NULL COMMENT '供应商ID（business_type=06时使用）',

                               `invoice_type` tinyint(4) NOT NULL COMMENT '开票类型：01-增值税普票 02-增值税专票 03-电子普票 04-电子专票',
                               `title_type` tinyint(4) NOT NULL COMMENT '抬头类型：01-企业 02-个人',

    -- 企业信息
                               `company_name` varchar(200) NOT NULL COMMENT '企业名称',
                               `tax_identifier` varchar(20) NOT NULL COMMENT '纳税人识别号（税号）',
                               `company_address` varchar(500) NOT NULL COMMENT '企业地址',
                               `company_tel` varchar(20) NOT NULL COMMENT '企业电话',
                               `bank_name` varchar(100) NOT NULL COMMENT '开户银行',
                               `bank_account` varchar(50) NOT NULL COMMENT '银行账号',

    -- 个人信息
                               `personal_name` varchar(50) NOT NULL COMMENT '个人姓名',
                               `id_card_number` varchar(20) NOT NULL COMMENT '身份证号',

    -- 收票信息
                               `receiver_name` varchar(50) NOT NULL COMMENT '收票人姓名',
                               `receiver_phone` varchar(20) NOT NULL COMMENT '收票人手机',
                               `receiver_email` varchar(100) NOT NULL COMMENT '收票人邮箱',
                               `receiver_province` varchar(20) NOT NULL COMMENT '收票省份',
                               `receiver_city` varchar(20) NOT NULL COMMENT '收票城市',
                               `receiver_district` varchar(20) NOT NULL COMMENT '收票区县',
                               `receiver_address` varchar(500) NOT NULL COMMENT '收票详细地址',
                               `receiver_postcode` varchar(10) NOT NULL COMMENT '邮政编码',

    -- 状态控制
                               `is_default` tinyint(1) NOT NULL COMMENT '是否默认开票信息：01-是 02-否',
                               `status` tinyint(4) NOT NULL COMMENT '数据状态：01-启用 02-禁用 03-作废 04-已删除',
                               `audit_status` tinyint(4) NOT NULL COMMENT '审核状态：01-待审核 02-审核通过 03-审核驳回',


    -- 系统字段
                               `created_by` bigint(20) unsigned NOT NULL COMMENT '创建人',
                               `updated_by` bigint(20) unsigned NOT NULL COMMENT '更新人',
                               `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                               `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                               `version` int(11) NOT NULL COMMENT '版本号（乐观锁）',


                               PRIMARY KEY (`id`),
                               KEY `idx_tenant_business` (`tenant_id`, `business_type`),
                               KEY `idx_shipper` (`shipper_id`),
                               KEY `idx_fleet` (`fleet_id`),
                               KEY `idx_platform` (`platform_id`),
                               KEY `idx_user` (`user_id`),
                               KEY `idx_driver` (`driver_id`),
                               KEY `idx_supplier` (`supplier_id`),
                               KEY `idx_business_default` (`business_type`, `is_default`),
                               KEY `idx_tax_identifier` (`tax_identifier`),
                               KEY `idx_status` (`status`),
                               KEY `idx_created_at` (`created_at`),
                               KEY `idx_company_name` (`company_name`(50))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='开票信息表';

CREATE TABLE `invoice_item_config` (
                                       `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                       `tenant_id` bigint(20) unsigned NOT NULL DEFAULT '0',
                                       `item_name` varchar(100) NOT NULL COMMENT '开票项目名称',
                                       `tax_rate` decimal(5,2) NOT NULL COMMENT '税率',
                                       `tax_code` varchar(20) NOT NULL DEFAULT '' COMMENT '税收编码',
                                       `description` varchar(500) NOT NULL DEFAULT '' COMMENT '项目描述',
                                       `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0-禁用 1-启用',
                                       `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                       `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                       PRIMARY KEY (`id`),
                                       KEY `idx_tenant` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='开票项目配置表';

CREATE TABLE `invoice_record` (
                                  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                  `tenant_id` bigint(20) unsigned NOT NULL COMMENT '租户ID',
                                  `invoice_info_id` bigint(20) unsigned NOT NULL COMMENT '开票信息ID',

    -- 票据相关信息
                                  `invoice_number` varchar(50) NOT NULL COMMENT '发票号码',
                                  `invoice_code` varchar(20) NOT NULL COMMENT '发票代码',
                                  `invoice_type` tinyint(4) NOT NULL COMMENT '发票类型：01-增值税普票 02-增值税专票...',

    -- 开票内容
                                  `invoice_amount` decimal(15,2) NOT NULL COMMENT '开票金额',
                                  `tax_amount` decimal(15,2) NOT NULL COMMENT '税额',
                                  `total_amount` decimal(15,2) NOT NULL COMMENT '价税合计',

    -- 开票状态
                                  `invoice_status` tinyint(4) NOT NULL COMMENT '开票状态：10-待开票 20-已开票 30-已寄送 40-已签收 50-已退票',

    -- 时间信息
                                  `invoice_date` date NOT NULL COMMENT '开票日期',
                                  `send_date` date DEFAULT NULL COMMENT '寄送日期',
                                  `receive_date` date DEFAULT NULL COMMENT '签收日期',

    -- 关联信息
                                  `order_id` varchar(50) NOT NULL COMMENT '订单编号',
                                  `order_amount` decimal(15,2) NOT NULL COMMENT '订单金额',

                                  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

                                  PRIMARY KEY (`id`),
                                  KEY `idx_invoice_info` (`invoice_info_id`),
                                  KEY `idx_invoice_number` (`invoice_number`),
                                  KEY `idx_order_id` (`order_id`),
                                  KEY `idx_invoice_date` (`invoice_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='开票记录表';


-- ----------------------------

CREATE TABLE `sys_invoice` (
                               `id` BIGINT ( 20 ) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                               `tenant_id` BIGINT ( 20 ) UNSIGNED DEFAULT NULL COMMENT '租户ID',
                               `business_type` TINYINT ( 4 ) DEFAULT NULL COMMENT '业务类型：01-货主企业 02-车队企业 03-平台企业 04-个人用户 05-司机 06-供应商',
                               `shipper_id` BIGINT ( 20 ) UNSIGNED DEFAULT NULL COMMENT '货主ID',
                               `fleet_id` BIGINT ( 20 ) UNSIGNED DEFAULT NULL COMMENT '车队ID',
                               `invoice_type` TINYINT ( 4 ) DEFAULT NULL COMMENT '开票类型：01-增值税普票 02-增值税专票 03-电子普票 04-电子专票',
                               `title_type` TINYINT ( 4 ) DEFAULT NULL COMMENT '抬头类型：01-企业 02-个人',
                               `company_name` VARCHAR ( 255 ) DEFAULT NULL COMMENT '企业名称',
                               `tax_identifier` VARCHAR ( 255 ) DEFAULT NULL COMMENT '纳税人识别号（税号）',
                               `company_address` VARCHAR ( 500 ) DEFAULT NULL COMMENT '企业地址',
                               `company_tel` VARCHAR ( 20 ) DEFAULT NULL COMMENT '企业电话',
                               `bank_name` VARCHAR ( 255 ) DEFAULT NULL COMMENT '开户银行',
                               `bank_account` VARCHAR ( 50 ) DEFAULT NULL COMMENT '银行账号',
                               `is_default` TINYINT ( 4 ) DEFAULT NULL COMMENT '是否默认开票信息：01-是 02-否',
                               `version` INT ( 11 ) DEFAULT NULL COMMENT '版本号（乐观锁）',
                               `status` TINYINT ( 4 ) NOT NULL COMMENT '数据状态：01-启用 02-禁用 03-作废 04-已删除',
                               create_time datetime NOT NULL COMMENT '创建时间',
                               creator_id VARCHAR ( 64 ) DEFAULT NULL COMMENT '创建人ID',
                               creator_name VARCHAR ( 255 ) DEFAULT NULL COMMENT '创建人姓名',
                               update_time datetime DEFAULT NULL COMMENT '更新时间',
                               updater_id VARCHAR ( 64 ) DEFAULT NULL COMMENT '更新人ID',
                               updater_name VARCHAR ( 255 ) DEFAULT NULL COMMENT '更新人姓名',
                               PRIMARY KEY ( `id` ),
                               KEY `idx_tenant_business` ( `tenant_id`, `business_type` ),
                               KEY `idx_shipper` ( `shipper_id` ),
                               KEY `idx_fleet` ( `fleet_id` ),
                               KEY `idx_business_default` ( `business_type`, `is_default` ),
                               KEY `idx_tax_identifier` ( `tax_identifier` ),
                               KEY `idx_status` ( `status` ),
                               KEY `idx_create_time` ( `create_time` ),
                               KEY `idx_company_name` (
                                   `company_name` ( 255 ))
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '开票信息表';


--

-- ----------------------------
-- Table structure for sys_qualification_certificate
-- ----------------------------
DROP TABLE IF EXISTS `sys_qualification_certificate`;
CREATE TABLE sys_qualification_certificate (
                                               `id` BIGINT ( 20 ) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',

                                               id_number VARCHAR ( 255 ) DEFAULT NULL COMMENT '身份证号',
                                               assessment_date VARCHAR ( 255 ) DEFAULT NULL COMMENT '考核时间',
                                               certificate_number VARCHAR ( 255 ) COMMENT '从业资格证号',
                                               file_number VARCHAR ( 20 ) COMMENT '档案号',
                                               union_card_number VARCHAR ( 10 ) COMMENT '福路通号',
                                               continuing_education_info VARCHAR ( 255 ) COMMENT '继续教育信息',
                                               sex VARCHAR ( 20 ) COMMENT '性别',
                                               phone_number VARCHAR ( 50 ) COMMENT '联系电话',
                                               registration_date VARCHAR ( 255 ) COMMENT '登记时间',
                                               work_unit VARCHAR ( 100 ) COMMENT '单位',
                                               integrity_assessment_info VARCHAR ( 100 ) COMMENT '诚信考核信息',
                                               nationality VARCHAR ( 255 ) COMMENT '国籍',
                                               name VARCHAR ( 255 ) COMMENT '姓名',
                                               address VARCHAR ( 50 ) COMMENT '住址',
                                               driving_class VARCHAR ( 255 ) COMMENT '准驾车型',
                                               issuing_authority VARCHAR ( 100 ) COMMENT '发证机关',
                                               birth_date VARCHAR ( 255 ) COMMENT '出生日期',

                                               category VARCHAR ( 255 ) COMMENT '从业资格类别',
                                               initial_issue_date VARCHAR ( 255 ) COMMENT '初次领证日期',
                                               issue_date VARCHAR ( 255 ) COMMENT '有效起始日期',
                                               expiry_date VARCHAR ( 255 ) COMMENT '有效截止日期',


                                               qualification_oss VARCHAR ( 500 ) COMMENT '从业资格证OSS存储地址',
                                               qualification_url VARCHAR ( 500 ) COMMENT '从业资格证平台URL存储地址',
                                               qualification_data TEXT COMMENT '从业资格证识别原始响应数据',
                                               `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                               PRIMARY KEY ( id ),
                                               INDEX idx_certificate_number ( certificate_number ),
                                               INDEX idx_name ( NAME ),
                                               INDEX idx_id_number ( id_number ),
                                               INDEX idx_created_at ( create_time )
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '道路运输从业资格证识别记录表';


-- ----------------------------
-- Table structure for user_event_log
-- ----------------------------
DROP TABLE IF EXISTS `user_event_log`;
CREATE TABLE `sys_user_event_log` (
                                      `id` varchar(64) NOT NULL COMMENT '主键ID',

                                      `event_id` varchar(64) DEFAULT NULL COMMENT '全局唯一事件ID',
                                      `event_type` varchar(32) DEFAULT NULL COMMENT '事件类型: page, click, exposure, api, system, view, purchase',
                                      `event_name` varchar(255) DEFAULT NULL COMMENT '事件技术标识符：home_page_view, invoice_btn_click, product_card_exposure, api_invoice_create',
                                      `event_time` varchar(255) DEFAULT NULL COMMENT '事件发生时间(精确到毫秒)',
                                      `start_time` varchar(255) DEFAULT NULL COMMENT '开始时间（对于有时长的事件）',
                                      `end_time` varchar(255) DEFAULT NULL COMMENT '结束时间（对于有时长的事件）',
                                      `duration` int unsigned DEFAULT NULL COMMENT '事件持续时长（毫秒）',

    -- 业务元数据字段（分析的核心）
                                      `page` varchar(255) DEFAULT NULL COMMENT '页面路径',
                                      `module` varchar(255) DEFAULT NULL COMMENT '功能模块',
                                      `component` varchar(255) DEFAULT NULL COMMENT 'UI组件',
                                      `object_type` varchar(64) DEFAULT NULL COMMENT '业务对象类型',
                                      `object_id` varchar(64) DEFAULT NULL COMMENT '业务对象ID',
                                      `action` varchar(64) DEFAULT NULL COMMENT '操作动作',

    -- 用户与环境字段
                                      `user_id` varchar(64) DEFAULT NULL COMMENT '用户ID',
                                      `user_agent` varchar(512) DEFAULT NULL COMMENT 'User-Agent信息',
                                      `device_id` varchar(64) DEFAULT NULL COMMENT '设备ID',
                                      `session_id` varchar(64) DEFAULT NULL COMMENT '会话ID',
                                      `ip` varchar(45) DEFAULT NULL COMMENT 'IP地址',
                                      `platform` varchar(32) DEFAULT NULL COMMENT '技术平台: iOS, Android, Web, MiniProgram',
                                      `source_client` varchar(32) DEFAULT NULL COMMENT '数据来源端（角色 + 平台组合）: driver-app, shipper-app, driver-mini, shipper-mini, driver-pc, shipper-pc, admin-pc, web-pc, web-mobile, ios-app, android-app, wechat-mini, alipay-mini, douyin-mini, quick-app',
                                      `os_version` varchar(32) DEFAULT NULL COMMENT '操作系统版本',
                                      `app_version` varchar(32) DEFAULT NULL COMMENT '应用版本',
                                      `referrer` varchar(1024) DEFAULT NULL COMMENT '来源页',

                                      `data_status` varchar(8) DEFAULT NULL COMMENT '数据状态: 01-正常, 02-异常, 03-已修复',

                                      `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据上报到服务器的时间',

                                      PRIMARY KEY (`id`),
                                      UNIQUE KEY `uk_event_id` (`event_id`),
                                      KEY `idx_user_id` (`user_id`),
                                      KEY `idx_event_name` (`event_name`),
                                      KEY `idx_create_time` (`create_time`),
                                      KEY `idx_event_time` (`event_time`),
                                      KEY `idx_object` (`object_type`, `object_id`),
                                      KEY `idx_page` (`page`(191)),
                                      KEY `idx_module` (`module`),
                                      KEY `idx_session` (`session_id`),
                                      KEY `idx_user_event` (`user_id`, `event_time`)
) ENGINE=InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT='用户行为事件埋点日志表';

-- 1. 首页浏览（有停留时长）
INSERT INTO user_event_log (
    event_id, event_type, event_name, event_time, start_time, end_time, duration,
    page, module, object_type, object_id, action,
    user_id, user_agent, device_id, session_id, ip, platform, app_version, create_time
) VALUES (
             'event_7234567890123457001', '页面', '首页浏览', '2023-10-27 09:15:23.456',
             '2023-10-27 09:15:23.456', '2023-10-27 09:16:05.123', 41667,
             '/首页/主页', '首页', '页面', '首页', '浏览',
             'user_1001', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15', 'device_abc123', 'sess_9f8j3d', '192.168.1.100', 'iOS', '3.5.1',
             '2023-10-27 09:16:05.500'
         );

-- 2. 商品搜索
INSERT INTO user_event_log (
    event_id, event_type, event_name, event_time,
    page, module, component, object_type, action,
    user_id, device_id, session_id, platform, app_version, extra_data, create_time
) VALUES (
             'event_7234567890123457002', '搜索', '搜索查询', '2023-10-27 09:16:10.200',
             '/搜索', '搜索', '搜索栏', '搜索', '查询',
             'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS', '3.5.1',
             '{"keyword": "无线耳机", "result_count": 24}',
             '2023-10-27 09:16:10.500'
         );

-- 3. 商品列表曝光
INSERT INTO user_event_log (
    event_id, event_type, event_name, event_time,
    page, module, component, object_type, object_id, action,
    user_id, device_id, session_id, platform, create_time
) VALUES (
             'event_7234567890123457003', '曝光', '搜索结果曝光', '2023-10-27 09:16:11.100',
             '/搜索/结果', '搜索', '商品列表', '商品', 'prod_3001', '曝光',
             'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
             '2023-10-27 09:16:11.350'
         );

-- 4. 商品点击
INSERT INTO user_event_log (
    event_id, event_type, event_name, event_time,
    page, module, component, object_type, object_id, action,
    user_id, device_id, session_id, platform, create_time
) VALUES (
             'event_7234567890123457004', '点击', '商品点击', '2023-10-27 09:16:15.800',
             '/搜索/结果', '搜索', '商品项', '商品', 'prod_3001', '点击',
             'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
             '2023-10-27 09:16:16.100'
         );

-- 5. 商品详情页浏览
INSERT INTO user_event_log (
    event_id, event_type, event_name, event_time, start_time, end_time, duration,
    page, module, object_type, object_id, action,
    user_id, device_id, session_id, platform, app_version, create_time
) VALUES (
             'event_7234567890123457005', '页面', '商品详情页浏览', '2023-10-27 09:16:16.200',
             '2023-10-27 09:16:16.200', '2023-10-27 09:17:30.000', 73800,
             '/商品/详情/3001', '商品', '商品', 'prod_3001', '浏览',
             'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS', '3.5.1',
             '2023-10-27 09:17:30.300'
         );

-- 6. 加入购物车
INSERT INTO user_event_log (
    event_id, event_type, event_name, event_time,
    page, module, component, object_type, object_id, action,
    user_id, device_id, session_id, platform, create_time
) VALUES (
             'event_7234567890123457006', '点击', '加入购物车', '2023-10-27 09:17:25.500',
             '/商品/详情/3001', '购物', '操作按钮', '商品', 'prod_3001', '加入购物车',
             'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
             '2023-10-27 09:17:25.800'
         );

-- 7. 购物车页面浏览
INSERT INTO user_event_log (
    event_id, event_type, event_name, event_time, start_time, end_time, duration,
    page, module, object_type, action,
    user_id, device_id, session_id, platform, create_time
) VALUES (
             'event_7234567890123457007', '页面', '购物车页面浏览', '2023-10-27 09:17:40.000',
             '2023-10-27 09:17:40.000', '2023-10-27 09:18:10.000', 30000,
             '/购物车', '购物', '购物车', '浏览',
             'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
             '2023-10-27 09:18:10.300'
         );

-- 8. 点击结算
INSERT INTO user_event_log (
    event_id, event_type, event_name, event_time,
    page, module, component, object_type, action,
    user_id, device_id, session_id, platform, create_time
) VALUES (
             'event_7234567890123457008', '点击', '结算点击', '2023-10-27 09:18:05.200',
             '/购物车', '购物', '结算按钮', '订单', '结算', '点击',
             'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
             '2023-10-27 09:18:05.500'
         );

-- 9. 支付成功（API事件）
INSERT INTO user_event_log (
    event_id, event_type, event_name, event_time,
    module, object_type, object_id, action,
    user_id, device_id, session_id, platform, create_time
) VALUES (
             'event_7234567890123457009', '接口', '支付成功', '2023-10-27 09:19:30.100',
             '支付', '订单', 'order_5001', '支付成功',
             'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
             '2023-10-27 09:19:30.400'
         );

-- 10. 用户注册成功
INSERT INTO user_event_log (
    event_id, event_type, event_name, event_time,
    module, object_type, action,
    user_id, user_agent, device_id, session_id, ip, platform, app_version, create_time
) VALUES (
             'event_7234567890123457010', '系统', '用户注册', '2023-10-27 09:20:15.300',
             '用户', '用户', '注册',
             'user_1002', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'device_def456', 'sess_7g6h5k', '10.0.0.1', '网页', '1.2.0',
             '2023-10-27 09:20:15.600'
         );
