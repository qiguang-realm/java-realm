-- ----------------------------
-- Table structure for sys_license_agreement
-- ----------------------------
DROP TABLE IF EXISTS `sys_license_agreement`;
CREATE TABLE `sys_license_agreement`
(
    `id`             varchar(64) NOT NULL COMMENT '主键ID',
    `name`           varchar(255) DEFAULT NULL COMMENT '名称',
    `version`        varchar(64)  DEFAULT NULL COMMENT '版本号',
    `content`        text COMMENT '内容',
    `type`           varchar(32)  DEFAULT NULL COMMENT '协议类型(PRIVACY:隐私协议,USER:用户协议,SERVICE:服务协议等)',
    `storage_path`   varchar(512) DEFAULT NULL COMMENT '协议存储地址(文件路径/URL/对象存储key)',
    `effective_date` datetime     DEFAULT NULL COMMENT '生效日期',
    `expire_date`    datetime     DEFAULT NULL COMMENT '失效日期',
    `remarks`        varchar(512) DEFAULT NULL COMMENT '备注',
    `data_status`    varchar(32)  DEFAULT '01' COMMENT '数据状态：01 正常/active、02 已删除/deleted',
    `created_at`     datetime     DEFAULT NULL COMMENT '创建时间',
    `created_by`     varchar(64)  DEFAULT NULL COMMENT '创建人ID',
    `creator_name`   varchar(64)  DEFAULT NULL COMMENT '创建人名称',
    `updated_at`     datetime     DEFAULT NULL COMMENT '更新时间',
    `updated_by`     varchar(64)  DEFAULT NULL COMMENT '更新人ID',
    `updater_name`   varchar(64)  DEFAULT NULL COMMENT '更新人名称',
    PRIMARY KEY (`id`),
    KEY              `idx_type` (`type`),
    KEY              `idx_data_status` (`data_status`),
    KEY              `idx_effective_date` (`effective_date`),
    KEY              `idx_expire_date` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统授权协议表';


-- ----------------------------
-- Table structure for user_license_acceptance
-- ----------------------------
DROP TABLE IF EXISTS `user_license_acceptance`;
CREATE TABLE `user_license_acceptance`
(
    `id`              bigint(20) NOT NULL AUTO_INCREMENT,
    `user_id`         bigint(20) NOT NULL COMMENT '用户ID',
    `user_name`       varchar(100)         DEFAULT NULL COMMENT '用户名称',
    `user_phone`      varchar(20)          DEFAULT NULL COMMENT '用户手机号',
    `license_id`      bigint(20) NOT NULL COMMENT '协议ID',
    `license_type`    tinyint(4) NOT NULL COMMENT '协议类型(与sys_license_agreement.type对应)',
    `license_version` varchar(50) NOT NULL COMMENT '协议版本号',
    `accept_time`     datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '接受时间',
    `ip_address`      varchar(50)          DEFAULT NULL COMMENT '接受时的IP地址',
    `device_info`     varchar(200)         DEFAULT NULL COMMENT '设备信息',
    PRIMARY KEY (`id`),
    KEY               `idx_user_license` (`user_id`, `license_id`),
    KEY               `idx_user_phone` (`user_phone`),
    KEY               `idx_license_type_version` (`license_type`, `license_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户协议接受记录表';

-- ----------------------------
-- Table structure for sys_invoice
-- ----------------------------
DROP TABLE IF EXISTS `sys_invoice`;
CREATE TABLE `sys_invoice`
(
    `id`                bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `tenant_id`         bigint(20) unsigned NOT NULL COMMENT '租户ID',
    `business_type`     tinyint(4) NOT NULL COMMENT '业务类型：01-货主企业 02-车队企业 03-平台企业 04-个人用户 05-司机 06-供应商',

    -- 具体业务ID字段（根据business_type选择使用哪个字段）
    `shipper_id`        bigint(20) unsigned NOT NULL COMMENT '货主ID（business_type=01时使用）',
    `fleet_id`          bigint(20) unsigned NOT NULL COMMENT '车队ID（business_type=02时使用）',
    `platform_id`       bigint(20) unsigned NOT NULL COMMENT '平台企业ID（business_type=03时使用）',
    `user_id`           bigint(20) unsigned NOT NULL COMMENT '个人用户ID（business_type=04时使用）',
    `driver_id`         bigint(20) unsigned NOT NULL COMMENT '司机ID（business_type=05时使用）',
    `supplier_id`       bigint(20) unsigned NOT NULL COMMENT '供应商ID（business_type=06时使用）',

    `invoice_type`      tinyint(4) NOT NULL COMMENT '开票类型：01-增值税普票 02-增值税专票 03-电子普票 04-电子专票',
    `title_type`        tinyint(4) NOT NULL COMMENT '抬头类型：01-企业 02-个人',

    -- 企业信息
    `company_name`      varchar(200) NOT NULL COMMENT '企业名称',
    `tax_identifier`    varchar(20)  NOT NULL COMMENT '纳税人识别号（税号）',
    `company_address`   varchar(500) NOT NULL COMMENT '企业地址',
    `company_tel`       varchar(20)  NOT NULL COMMENT '企业电话',
    `bank_name`         varchar(100) NOT NULL COMMENT '开户银行',
    `bank_account`      varchar(50)  NOT NULL COMMENT '银行账号',

    -- 个人信息
    `personal_name`     varchar(50)  NOT NULL COMMENT '个人姓名',
    `id_card_number`    varchar(20)  NOT NULL COMMENT '身份证号',

    -- 收票信息
    `receiver_name`     varchar(50)  NOT NULL COMMENT '收票人姓名',
    `receiver_phone`    varchar(20)  NOT NULL COMMENT '收票人手机',
    `receiver_email`    varchar(100) NOT NULL COMMENT '收票人邮箱',
    `receiver_province` varchar(20)  NOT NULL COMMENT '收票省份',
    `receiver_city`     varchar(20)  NOT NULL COMMENT '收票城市',
    `receiver_district` varchar(20)  NOT NULL COMMENT '收票区县',
    `receiver_address`  varchar(500) NOT NULL COMMENT '收票详细地址',
    `receiver_postcode` varchar(10)  NOT NULL COMMENT '邮政编码',

    -- 状态控制
    `is_default`        tinyint(1) NOT NULL COMMENT '是否默认开票信息：01-是 02-否',
    `status`            tinyint(4) NOT NULL COMMENT '数据状态：01-启用 02-禁用 03-作废 04-已删除',
    `audit_status`      tinyint(4) NOT NULL COMMENT '审核状态：01-待审核 02-审核通过 03-审核驳回',


    -- 系统字段
    `created_by`        bigint(20) unsigned NOT NULL COMMENT '创建人',
    `updated_by`        bigint(20) unsigned NOT NULL COMMENT '更新人',
    `created_at`        datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`        datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `version`           int(11) NOT NULL COMMENT '版本号（乐观锁）',


    PRIMARY KEY (`id`),
    KEY                 `idx_tenant_business` (`tenant_id`, `business_type`),
    KEY                 `idx_shipper` (`shipper_id`),
    KEY                 `idx_fleet` (`fleet_id`),
    KEY                 `idx_platform` (`platform_id`),
    KEY                 `idx_user` (`user_id`),
    KEY                 `idx_driver` (`driver_id`),
    KEY                 `idx_supplier` (`supplier_id`),
    KEY                 `idx_business_default` (`business_type`, `is_default`),
    KEY                 `idx_tax_identifier` (`tax_identifier`),
    KEY                 `idx_status` (`status`),
    KEY                 `idx_created_at` (`created_at`),
    KEY                 `idx_company_name` (`company_name`(50))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='开票信息表';

CREATE TABLE `invoice_item_config`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `tenant_id`   bigint(20) unsigned NOT NULL DEFAULT '0',
    `item_name`   varchar(100)  NOT NULL COMMENT '开票项目名称',
    `tax_rate`    decimal(5, 2) NOT NULL COMMENT '税率',
    `tax_code`    varchar(20)   NOT NULL DEFAULT '' COMMENT '税收编码',
    `description` varchar(500)  NOT NULL DEFAULT '' COMMENT '项目描述',
    `status`      tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0-禁用 1-启用',
    `created_at`  datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY           `idx_tenant` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='开票项目配置表';

CREATE TABLE `invoice_record`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `tenant_id`       bigint(20) unsigned NOT NULL COMMENT '租户ID',
    `invoice_info_id` bigint(20) unsigned NOT NULL COMMENT '开票信息ID',

    -- 票据相关信息
    `invoice_number`  varchar(50)    NOT NULL COMMENT '发票号码',
    `invoice_code`    varchar(20)    NOT NULL COMMENT '发票代码',
    `invoice_type`    tinyint(4) NOT NULL COMMENT '发票类型：01-增值税普票 02-增值税专票...',

    -- 开票内容
    `invoice_amount`  decimal(15, 2) NOT NULL COMMENT '开票金额',
    `tax_amount`      decimal(15, 2) NOT NULL COMMENT '税额',
    `total_amount`    decimal(15, 2) NOT NULL COMMENT '价税合计',

    -- 开票状态
    `invoice_status`  tinyint(4) NOT NULL COMMENT '开票状态：10-待开票 20-已开票 30-已寄送 40-已签收 50-已退票',

    -- 时间信息
    `invoice_date`    date           NOT NULL COMMENT '开票日期',
    `send_date`       date                    DEFAULT NULL COMMENT '寄送日期',
    `receive_date`    date                    DEFAULT NULL COMMENT '签收日期',

    -- 关联信息
    `order_id`        varchar(50)    NOT NULL COMMENT '订单编号',
    `order_amount`    decimal(15, 2) NOT NULL COMMENT '订单金额',

    `created_at`      datetime       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      datetime       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    KEY               `idx_invoice_info` (`invoice_info_id`),
    KEY               `idx_invoice_number` (`invoice_number`),
    KEY               `idx_order_id` (`order_id`),
    KEY               `idx_invoice_date` (`invoice_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='开票记录表';


-- ----------------------------

CREATE TABLE `sys_invoice`
(
    `id`              BIGINT ( 20 ) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `tenant_id`       BIGINT ( 20 ) UNSIGNED DEFAULT NULL COMMENT '租户ID',
    `business_type`   TINYINT ( 4 ) DEFAULT NULL COMMENT '业务类型：01-货主企业 02-车队企业 03-平台企业 04-个人用户 05-司机 06-供应商',
    `shipper_id`      BIGINT ( 20 ) UNSIGNED DEFAULT NULL COMMENT '货主ID',
    `fleet_id`        BIGINT ( 20 ) UNSIGNED DEFAULT NULL COMMENT '车队ID',
    `invoice_type`    TINYINT ( 4 ) DEFAULT NULL COMMENT '开票类型：01-增值税普票 02-增值税专票 03-电子普票 04-电子专票',
    `title_type`      TINYINT ( 4 ) DEFAULT NULL COMMENT '抬头类型：01-企业 02-个人',
    `company_name`    VARCHAR(255) DEFAULT NULL COMMENT '企业名称',
    `tax_identifier`  VARCHAR(255) DEFAULT NULL COMMENT '纳税人识别号（税号）',
    `company_address` VARCHAR(500) DEFAULT NULL COMMENT '企业地址',
    `company_tel`     VARCHAR(20)  DEFAULT NULL COMMENT '企业电话',
    `bank_name`       VARCHAR(255) DEFAULT NULL COMMENT '开户银行',
    `bank_account`    VARCHAR(50)  DEFAULT NULL COMMENT '银行账号',
    `is_default`      TINYINT ( 4 ) DEFAULT NULL COMMENT '是否默认开票信息：01-是 02-否',
    `version`         INT ( 11 ) DEFAULT NULL COMMENT '版本号（乐观锁）',
    `status`          TINYINT ( 4 ) NOT NULL COMMENT '数据状态：01-启用 02-禁用 03-作废 04-已删除',
    create_time       datetime NOT NULL COMMENT '创建时间',
    creator_id        VARCHAR(64)  DEFAULT NULL COMMENT '创建人ID',
    creator_name      VARCHAR(255) DEFAULT NULL COMMENT '创建人姓名',
    update_time       datetime     DEFAULT NULL COMMENT '更新时间',
    updater_id        VARCHAR(64)  DEFAULT NULL COMMENT '更新人ID',
    updater_name      VARCHAR(255) DEFAULT NULL COMMENT '更新人姓名',
    PRIMARY KEY (`id`),
    KEY               `idx_tenant_business` ( `tenant_id`, `business_type` ),
    KEY               `idx_shipper` ( `shipper_id` ),
    KEY               `idx_fleet` ( `fleet_id` ),
    KEY               `idx_business_default` ( `business_type`, `is_default` ),
    KEY               `idx_tax_identifier` ( `tax_identifier` ),
    KEY               `idx_status` ( `status` ),
    KEY               `idx_create_time` ( `create_time` ),
    KEY               `idx_company_name` ( `company_name` ( 255 ))
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '开票信息表';


--

-- ----------------------------
-- Table structure for sys_qualification_certificate
-- ----------------------------
DROP TABLE IF EXISTS `sys_qualification_certificate`;
CREATE TABLE sys_qualification_certificate
(
    `id`                      BIGINT ( 20 ) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',

    id_number                 VARCHAR(255)      DEFAULT NULL COMMENT '身份证号',
    assessment_date           VARCHAR(255)      DEFAULT NULL COMMENT '考核时间',
    certificate_number        VARCHAR(255) COMMENT '从业资格证号',
    file_number               VARCHAR(20) COMMENT '档案号',
    union_card_number         VARCHAR(10) COMMENT '福路通号',
    continuing_education_info VARCHAR(255) COMMENT '继续教育信息',
    sex                       VARCHAR(20) COMMENT '性别',
    phone_number              VARCHAR(50) COMMENT '联系电话',
    registration_date         VARCHAR(255) COMMENT '登记时间',
    work_unit                 VARCHAR(100) COMMENT '单位',
    integrity_assessment_info VARCHAR(100) COMMENT '诚信考核信息',
    nationality               VARCHAR(255) COMMENT '国籍',
    name                      VARCHAR(255) COMMENT '姓名',
    address                   VARCHAR(50) COMMENT '住址',
    driving_class             VARCHAR(255) COMMENT '准驾车型',
    issuing_authority         VARCHAR(100) COMMENT '发证机关',
    birth_date                VARCHAR(255) COMMENT '出生日期',

    category                  VARCHAR(255) COMMENT '从业资格类别',
    initial_issue_date        VARCHAR(255) COMMENT '初次领证日期',
    issue_date                VARCHAR(255) COMMENT '有效起始日期',
    expiry_date               VARCHAR(255) COMMENT '有效截止日期',


    qualification_oss         VARCHAR(500) COMMENT '从业资格证OSS存储地址',
    qualification_url         VARCHAR(500) COMMENT '从业资格证平台URL存储地址',
    qualification_data        TEXT COMMENT '从业资格证识别原始响应数据',
    `create_time`             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id),
    INDEX                     idx_certificate_number ( certificate_number ),
    INDEX                     idx_name ( NAME ),
    INDEX                     idx_id_number ( id_number ),
    INDEX                     idx_created_at ( create_time )
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '道路运输从业资格证识别记录表';


-- ----------------------------
-- Table structure for user_event_log
-- ----------------------------
DROP TABLE IF EXISTS `user_event_log`;
CREATE TABLE `sys_user_event_log`
(
    `id`            varchar(64) NOT NULL COMMENT '主键ID',

    `event_id`      varchar(64)          DEFAULT NULL COMMENT '全局唯一事件ID',
    `event_type`    varchar(32)          DEFAULT NULL COMMENT '事件类型: page, click, exposure, api, system, view, purchase',
    `event_name`    varchar(255)         DEFAULT NULL COMMENT '事件技术标识符：home_page_view, invoice_btn_click, product_card_exposure, api_invoice_create',
    `event_time`    varchar(255)         DEFAULT NULL COMMENT '事件发生时间(精确到毫秒)',
    `start_time`    varchar(255)         DEFAULT NULL COMMENT '开始时间（对于有时长的事件）',
    `end_time`      varchar(255)         DEFAULT NULL COMMENT '结束时间（对于有时长的事件）',
    `duration`      int unsigned DEFAULT NULL COMMENT '事件持续时长（毫秒）',

    -- 业务元数据字段（分析的核心）
    `page`          varchar(255)         DEFAULT NULL COMMENT '页面路径',
    `module`        varchar(255)         DEFAULT NULL COMMENT '功能模块',
    `component`     varchar(255)         DEFAULT NULL COMMENT 'UI组件',
    `object_type`   varchar(64)          DEFAULT NULL COMMENT '业务对象类型',
    `object_id`     varchar(64)          DEFAULT NULL COMMENT '业务对象ID',
    `action`        varchar(64)          DEFAULT NULL COMMENT '操作动作',

    -- 用户与环境字段
    `user_id`       varchar(64)          DEFAULT NULL COMMENT '用户ID',
    `user_agent`    varchar(512)         DEFAULT NULL COMMENT 'User-Agent信息',
    `device_id`     varchar(64)          DEFAULT NULL COMMENT '设备ID',
    `session_id`    varchar(64)          DEFAULT NULL COMMENT '会话ID',
    `ip`            varchar(45)          DEFAULT NULL COMMENT 'IP地址',
    `platform`      varchar(32)          DEFAULT NULL COMMENT '技术平台: iOS, Android, Web, MiniProgram',
    `source_client` varchar(32)          DEFAULT NULL COMMENT '数据来源端（角色 + 平台组合）: driver-app, shipper-app, driver-mini, shipper-mini, driver-pc, shipper-pc, admin-pc, web-pc, web-mobile, ios-app, android-app, wechat-mini, alipay-mini, douyin-mini, quick-app',
    `os_version`    varchar(32)          DEFAULT NULL COMMENT '操作系统版本',
    `app_version`   varchar(32)          DEFAULT NULL COMMENT '应用版本',
    `referrer`      varchar(1024)        DEFAULT NULL COMMENT '来源页',

    `data_status`   varchar(8)           DEFAULT NULL COMMENT '数据状态: 01-正常, 02-异常, 03-已修复',

    `create_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据上报到服务器的时间',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_event_id` (`event_id`),
    KEY             `idx_user_id` (`user_id`),
    KEY             `idx_event_name` (`event_name`),
    KEY             `idx_create_time` (`create_time`),
    KEY             `idx_event_time` (`event_time`),
    KEY             `idx_object` (`object_type`, `object_id`),
    KEY             `idx_page` (`page`(191)),
    KEY             `idx_module` (`module`),
    KEY             `idx_session` (`session_id`),
    KEY             `idx_user_event` (`user_id`, `event_time`)
) ENGINE=InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT='用户行为事件埋点日志表';

-- 1. 首页浏览（有停留时长）
INSERT INTO user_event_log (event_id, event_type, event_name, event_time, start_time, end_time, duration,
                            page, module, object_type, object_id, action,
                            user_id, user_agent, device_id, session_id, ip, platform, app_version, create_time)
VALUES ('event_7234567890123457001', '页面', '首页浏览', '2023-10-27 09:15:23.456',
        '2023-10-27 09:15:23.456', '2023-10-27 09:16:05.123', 41667,
        '/首页/主页', '首页', '页面', '首页', '浏览',
        'user_1001', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15', 'device_abc123',
        'sess_9f8j3d', '192.168.1.100', 'iOS', '3.5.1',
        '2023-10-27 09:16:05.500');

-- 2. 商品搜索
INSERT INTO user_event_log (event_id, event_type, event_name, event_time,
                            page, module, component, object_type, action,
                            user_id, device_id, session_id, platform, app_version, extra_data, create_time)
VALUES ('event_7234567890123457002', '搜索', '搜索查询', '2023-10-27 09:16:10.200',
        '/搜索', '搜索', '搜索栏', '搜索', '查询',
        'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS', '3.5.1',
        '{"keyword": "无线耳机", "result_count": 24}',
        '2023-10-27 09:16:10.500');

-- 3. 商品列表曝光
INSERT INTO user_event_log (event_id, event_type, event_name, event_time,
                            page, module, component, object_type, object_id, action,
                            user_id, device_id, session_id, platform, create_time)
VALUES ('event_7234567890123457003', '曝光', '搜索结果曝光', '2023-10-27 09:16:11.100',
        '/搜索/结果', '搜索', '商品列表', '商品', 'prod_3001', '曝光',
        'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
        '2023-10-27 09:16:11.350');

-- 4. 商品点击
INSERT INTO user_event_log (event_id, event_type, event_name, event_time,
                            page, module, component, object_type, object_id, action,
                            user_id, device_id, session_id, platform, create_time)
VALUES ('event_7234567890123457004', '点击', '商品点击', '2023-10-27 09:16:15.800',
        '/搜索/结果', '搜索', '商品项', '商品', 'prod_3001', '点击',
        'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
        '2023-10-27 09:16:16.100');

-- 5. 商品详情页浏览
INSERT INTO user_event_log (event_id, event_type, event_name, event_time, start_time, end_time, duration,
                            page, module, object_type, object_id, action,
                            user_id, device_id, session_id, platform, app_version, create_time)
VALUES ('event_7234567890123457005', '页面', '商品详情页浏览', '2023-10-27 09:16:16.200',
        '2023-10-27 09:16:16.200', '2023-10-27 09:17:30.000', 73800,
        '/商品/详情/3001', '商品', '商品', 'prod_3001', '浏览',
        'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS', '3.5.1',
        '2023-10-27 09:17:30.300');

-- 6. 加入购物车
INSERT INTO user_event_log (event_id, event_type, event_name, event_time,
                            page, module, component, object_type, object_id, action,
                            user_id, device_id, session_id, platform, create_time)
VALUES ('event_7234567890123457006', '点击', '加入购物车', '2023-10-27 09:17:25.500',
        '/商品/详情/3001', '购物', '操作按钮', '商品', 'prod_3001', '加入购物车',
        'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
        '2023-10-27 09:17:25.800');

-- 7. 购物车页面浏览
INSERT INTO user_event_log (event_id, event_type, event_name, event_time, start_time, end_time, duration,
                            page, module, object_type, action,
                            user_id, device_id, session_id, platform, create_time)
VALUES ('event_7234567890123457007', '页面', '购物车页面浏览', '2023-10-27 09:17:40.000',
        '2023-10-27 09:17:40.000', '2023-10-27 09:18:10.000', 30000,
        '/购物车', '购物', '购物车', '浏览',
        'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
        '2023-10-27 09:18:10.300');

-- 8. 点击结算
INSERT INTO user_event_log (event_id, event_type, event_name, event_time,
                            page, module, component, object_type, action,
                            user_id, device_id, session_id, platform, create_time)
VALUES ('event_7234567890123457008', '点击', '结算点击', '2023-10-27 09:18:05.200',
        '/购物车', '购物', '结算按钮', '订单', '结算', '点击',
        'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
        '2023-10-27 09:18:05.500');

-- 9. 支付成功（API事件）
INSERT INTO user_event_log (event_id, event_type, event_name, event_time,
                            module, object_type, object_id, action,
                            user_id, device_id, session_id, platform, create_time)
VALUES ('event_7234567890123457009', '接口', '支付成功', '2023-10-27 09:19:30.100',
        '支付', '订单', 'order_5001', '支付成功',
        'user_1001', 'device_abc123', 'sess_9f8j3d', 'iOS',
        '2023-10-27 09:19:30.400');

-- 10. 用户注册成功
INSERT INTO user_event_log (event_id, event_type, event_name, event_time,
                            module, object_type, action,
                            user_id, user_agent, device_id, session_id, ip, platform, app_version, create_time)
VALUES ('event_7234567890123457010', '系统', '用户注册', '2023-10-27 09:20:15.300',
        '用户', '用户', '注册',
        'user_1002', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'device_def456', 'sess_7g6h5k',
        '10.0.0.1', '网页', '1.2.0',
        '2023-10-27 09:20:15.600');



-- ----------------------------
-- Table structure for sys_driver_rehire_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_driver_rehire_log`;
CREATE TABLE sys_driver_rehire_log
(
    id                BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键ID',

    -- 司机信息
    driver_id         BIGINT      NOT NULL COMMENT '司机ID',
    driver_name       VARCHAR(50) NOT NULL COMMENT '司机姓名',
    driver_phone      VARCHAR(20) COMMENT '司机手机号',

    -- 车队信息
    fleet_id          BIGINT               DEFAULT NULL COMMENT '车队ID',
    fleet_name        VARCHAR(255) COMMENT '车队名称',

    -- 入职相关信息
    rehire_date       DATETIME    NOT NULL COMMENT '重新入职日期',
    rehire_reason     VARCHAR(500) COMMENT '重新入职原因',

    -- 上次离职相关信息
    last_leave_date   DATETIME COMMENT '上次离职日期',
    last_leave_reason VARCHAR(500) COMMENT '上次离职原因',

    -- 系统信息
    `is_deleted`      TINYINT              DEFAULT 0 COMMENT '是否删除：0-否，1-是',
    create_by         BIGINT      NOT NULL COMMENT '创建人ID',
    create_by_name    VARCHAR(50) NOT NULL COMMENT '创建人姓名',
    create_time       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_by         BIGINT COMMENT '更新人ID',
    update_by_name    VARCHAR(50) COMMENT '更新人姓名',
    update_time       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    -- 索引
    PRIMARY KEY (id),
    INDEX             idx_driver_id (driver_id),
    INDEX             idx_fleet_id (fleet_id),
    INDEX             idx_rehire_date (rehire_date),
    INDEX             idx_create_time (create_time),
    INDEX             idx_driver_phone (driver_phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='司机重新入职记录表';


-- ----------------------------
-- Table structure for sys_order_payment_voucher
-- ----------------------------
DROP TABLE IF EXISTS `sys_order_payment_voucher`;
CREATE TABLE `sys_order_payment_voucher`
(
    `id`             BIGINT         NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `order_id`       BIGINT         NOT NULL COMMENT '运单ID',
    `fee_id`         BIGINT                  DEFAULT NULL COMMENT '费用ID（关联sys_order_extra_fee.id）',
    `voucher_url`    VARCHAR(500)   NOT NULL COMMENT '凭证URL',
    `payment_amount` DECIMAL(15, 2) NOT NULL COMMENT '支付金额',

    -- 费用相关
    `fee_name`       VARCHAR(500)   NOT NULL COMMENT '费用名称',

    -- 系统字段
    `is_deleted`     VARCHAR(10)    NOT NULL DEFAULT '0' COMMENT '是否删除：0-未删除，1-已删除',
    `create_by`      VARCHAR(50)    NOT NULL COMMENT '创建人ID',
    `create_by_name` VARCHAR(50)    NOT NULL COMMENT '创建人姓名',
    `create_time`    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by`      VARCHAR(50) COMMENT '更新人ID',
    `update_by_name` VARCHAR(50) COMMENT '更新人姓名',
    `update_time`    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_order_voucher` (`order_id`, `voucher_url`(200), `is_deleted`),
    UNIQUE KEY `uk_fee_voucher` (`fee_id`, `is_deleted`),
    KEY              `idx_order_id` (`order_id`),
    KEY              `idx_fee_id` (`fee_id`),
    KEY              `idx_is_deleted` (`is_deleted`),
    KEY              `idx_fee_name` (`fee_name`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='运单支付凭证表';


ALTER TABLE `sys_order`
    ADD COLUMN `data_source_type` TINYINT DEFAULT 0 COMMENT '数据来源类型：0-系统数据，1-补录数据，2-导入数据';

ALTER TABLE `sys_order`
    ADD INDEX `idx_data_source_type` (`data_source_type`);



-- ----------------------------
-- Table structure for sys_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_log`;
CREATE TABLE `sys_operation_log`
(
    -- 基础信息
    `id`                   bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
--                                      `id` varchar(64) NOT NULL COMMENT '主键ID',
    `tenant_id`            bigint(20) DEFAULT NULL COMMENT '租户ID(多租户系统使用)',
    `trace_id`             varchar(64)   DEFAULT NULL COMMENT '请求追踪ID(用于分布式系统跟踪)',
    `span_id`              varchar(64)   DEFAULT NULL COMMENT 'Span ID(链路追踪)',
    `log_type`             tinyint(2) NOT NULL DEFAULT '1' COMMENT '日志类型(1:操作日志 2:登录日志 3:异常日志 4:定时任务日志)',
    `log_level`            varchar(10)   DEFAULT 'INFO' COMMENT '日志级别(DEBUG/INFO/WARN/ERROR)',

    -- 操作内容
    `module_type`          varchar(20)   DEFAULT NULL COMMENT '模块类型(SYSTEM:系统管理 BUSINESS:业务管理 REPORT:报表管理 API:接口监控 TOOL:工具操作)',
    `module`               varchar(50) NOT NULL COMMENT '操作模块(如用户管理/订单管理)',
    `sub_module`           varchar(50)   DEFAULT NULL COMMENT '操作子模块',
    `feature`              varchar(50)   DEFAULT NULL COMMENT '功能点',
    `business_type`        tinyint(2) DEFAULT NULL COMMENT '业务类型(0其它 1新增 2修改 3删除 4授权 5导出 6导入 7强退 8生成代码 9清空数据)',
    `operation_type`       varchar(20) NOT NULL COMMENT '操作类型(ADD/UPDATE/DELETE/SELECT/LOGIN/LOGOUT/EXPORT/IMPORT/API_CALL等)',
    `operation_desc`       varchar(1000) DEFAULT NULL COMMENT '操作描述',
    `primary_business_id`  varchar(64)   DEFAULT NULL COMMENT '主业务ID(用于快速查询)',
    `business_ids`         text          DEFAULT NULL COMMENT '业务ID集合(JSON格式文本)',

    -- 业务数据
    `business_data`        text          DEFAULT NULL COMMENT '业务数据快照(JSON格式字符串)',
    `business_data_type`   varchar(20)   DEFAULT 'FULL' COMMENT '业务数据类型(FULL:完整数据 DIFF:差异数据)',
    `changed_fields`       text          DEFAULT NULL COMMENT '变更字段列表(逗号分隔)',
    `data_version`         varchar(50)   DEFAULT NULL COMMENT '数据版本号',

    -- 请求信息
    `request_method`       varchar(10)   DEFAULT NULL COMMENT '请求方法(GET/POST/PUT/DELETE/PATCH等)',
    `request_url`          varchar(500)  DEFAULT NULL COMMENT '请求URL',
    `api_version`          varchar(20)   DEFAULT NULL COMMENT 'API版本号',

    -- 请求参数
    `request_params`       text          DEFAULT NULL COMMENT '请求参数(JSON格式字符串)',
    `request_param_count`  int(11) DEFAULT '0' COMMENT '请求参数个数',
    `request_body`         longtext      DEFAULT NULL COMMENT '请求体内容',
    `request_content_type` varchar(100)  DEFAULT NULL COMMENT '请求内容类型',
    `request_headers`      text          DEFAULT NULL COMMENT '请求头信息(JSON格式字符串)',

    `response_code`        varchar(20)   DEFAULT NULL COMMENT '响应状态码(HTTP状态码或业务状态码)',
    `response_data`        longtext      DEFAULT NULL COMMENT '响应数据',
    `response_headers`     text          DEFAULT NULL COMMENT '响应头信息(JSON格式字符串)',
    `response_time`        bigint(20) DEFAULT NULL COMMENT '响应时间(毫秒)',

    -- 系统环境
    `app_name`             varchar(50)   DEFAULT NULL COMMENT '应用名称(微服务架构下使用)',
    `app_version`          varchar(20)   DEFAULT NULL COMMENT '应用版本',
    `device_type`          varchar(20)   DEFAULT NULL COMMENT '设备类型(WEB/IOS/ANDROID/H5/小程序等)',
    `os_info`              varchar(100)  DEFAULT NULL COMMENT '操作系统信息',
    `browser_info`         varchar(200)  DEFAULT NULL COMMENT '浏览器信息',

    -- 客户端详细信息
    `client_info`          text          DEFAULT NULL COMMENT '客户端详细信息(JSON格式字符串)',
    `screen_resolution`    varchar(20)   DEFAULT NULL COMMENT '屏幕分辨率',
    `client_language`      varchar(20)   DEFAULT NULL COMMENT '客户端语言',
    `timezone`             varchar(50)   DEFAULT NULL COMMENT '时区',

    -- 网络信息
    `ip_address`           varchar(64)   DEFAULT NULL COMMENT 'IP地址(支持IPv6)',
    `ip_location`          text          DEFAULT NULL COMMENT 'IP地理位置信息(JSON格式字符串)',
    `network_type`         varchar(20)   DEFAULT NULL COMMENT '网络类型(WIFI/4G/5G等)',
    `user_agent`           text          DEFAULT NULL COMMENT '完整的User-Agent',

    -- 操作人信息
    `operator_id`          varchar(64)   DEFAULT NULL COMMENT '操作人ID',
    `operator_name`        varchar(50)   DEFAULT NULL COMMENT '操作人姓名',
    `operator_account`     varchar(50)   DEFAULT NULL COMMENT '操作人账号',

    -- 角色信息
    `operator_roles`       text          DEFAULT NULL COMMENT '操作人角色列表(JSON格式字符串)',
    `role_level`           int(11) DEFAULT NULL COMMENT '角色等级',
    `operator_dept`        varchar(100)  DEFAULT NULL COMMENT '操作人部门',
    `operator_org`         varchar(100)  DEFAULT NULL COMMENT '操作人组织',
    `operator_position`    varchar(100)  DEFAULT NULL COMMENT '操作人职位',
    `operator_ext_info`    text          DEFAULT NULL COMMENT '操作人扩展信息(JSON格式字符串)',

    -- 操作状态
    `status`               tinyint(1) DEFAULT '1' COMMENT '操作状态(0:失败 1:成功 2:部分成功)',
    `error_code`           varchar(50)   DEFAULT NULL COMMENT '错误码',
    `error_msg`            text          DEFAULT NULL COMMENT '错误信息',
    `error_stack`          text          DEFAULT NULL COMMENT '错误堆栈',
    `retry_count`          tinyint(2) DEFAULT '0' COMMENT '重试次数',
    `error_details`        text          DEFAULT NULL COMMENT '错误详细信息(JSON格式字符串)',

    -- 性能指标
    `execute_time`         bigint(20) DEFAULT NULL COMMENT '执行耗时(毫秒)',
    `db_query_count`       int(11) DEFAULT NULL COMMENT '数据库查询次数',
    `db_query_time`        bigint(20) DEFAULT NULL COMMENT '数据库查询总耗时(毫秒)',
    `memory_usage`         bigint(20) DEFAULT NULL COMMENT '内存使用量(KB)',
    `data_size`            int(11) DEFAULT NULL COMMENT '数据大小(字节)',
    `cpu_usage`            decimal(5, 2) DEFAULT NULL COMMENT 'CPU使用率(%)',
    `performance_metrics`  text          DEFAULT NULL COMMENT '性能指标数据(JSON格式字符串)',

    -- 时间信息
    `start_time`           datetime(3) DEFAULT NULL COMMENT '操作开始时间(精确到毫秒)',
    `end_time`             datetime(3) DEFAULT NULL COMMENT '操作结束时间',
    `create_time`          datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP (3) COMMENT '日志创建时间',

    -- 管理字段
    `cost_category`        varchar(20)   DEFAULT NULL COMMENT '成本分类(高频/低频/重要业务)',
    `archived`             tinyint(1) DEFAULT '0' COMMENT '是否已归档(0:未归档 1:已归档)',
    `storage_level`        tinyint(1) DEFAULT '1' COMMENT '存储级别(1:热数据 2:温数据 3:冷数据)',
    `data_source`          varchar(50)   DEFAULT 'SYSTEM' COMMENT '数据来源(SYSTEM/IMPORT/API等)',
    `tags`                 text          DEFAULT NULL COMMENT '标签列表(JSON格式字符串)',

    PRIMARY KEY (`id`),
    KEY                    `idx_module` (`module`),
    KEY                    `idx_module_type` (`module_type`),
    KEY                    `idx_business_type` (`business_type`),
    KEY                    `idx_operator` (`operator_id`),
    KEY                    `idx_time` (`create_time`),
    KEY                    `idx_status` (`status`),
    KEY                    `idx_trace_id` (`trace_id`),
    KEY                    `idx_primary_business` (`primary_business_id`),
    KEY                    `idx_tenant` (`tenant_id`),
    KEY                    `idx_ip` (`ip_address`),
    KEY                    `idx_operation_type` (`operation_type`),
    KEY                    `idx_module_time` (`module`, `create_time`),
    KEY                    `idx_operator_time` (`operator_id`, `create_time`),
    KEY                    `idx_status_time` (`status`, `create_time`),
    KEY                    `idx_tenant_time` (`tenant_id`, `create_time`),
    KEY                    `idx_log_type_time` (`log_type`, `create_time`),
    KEY                    `idx_app_name` (`app_name`),
    KEY                    `idx_device_type` (`device_type`),
    KEY                    `idx_cost_category` (`cost_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='系统操作日志表';


-- ----------------------------
-- Table structure for vehicle_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `vehicle_operation_log`;

CREATE TABLE `vehicle_operation_log`
(
    -- 核心标识
    `id`                varchar(64)  NOT NULL COMMENT '主键ID',
    `vehicle_id`        varchar(64)  NOT NULL COMMENT '车辆ID',
    `license_plate`     varchar(20)  NOT NULL COMMENT '车牌号',

    -- 操作信息
    `operation_type`    varchar(30)  NOT NULL COMMENT '操作类型',
    `operation_name`    varchar(100) NOT NULL COMMENT '操作类型名称',

    -- 操作人信息
    `operator_id`       varchar(64)  NOT NULL COMMENT '操作人ID',
    `operator_name`     varchar(100) NOT NULL COMMENT '操作人姓名',

    -- 用户信息
    `user_id`           varchar(64)           DEFAULT NULL COMMENT '用户ID',
    `user_name`         varchar(100)          DEFAULT NULL COMMENT '用户姓名',
    `user_account`      varchar(50)           DEFAULT NULL COMMENT '用户账号',
    `user_phone`        varchar(20)           DEFAULT NULL COMMENT '用户手机号',

    -- 描述信息
    `operation_summary` varchar(255)          DEFAULT NULL COMMENT '操作摘要',
    `operation_details` text COMMENT '操作详情',

    -- 环境信息
    `ip_address`        varchar(45)           DEFAULT NULL COMMENT 'IP地址',
    `source`            varchar(50)  NOT NULL DEFAULT 'SYSTEM' COMMENT '操作来源: SYSTEM/WEB/APP/API',

    -- 时间戳（操作时间就是创建时间）
    `create_time`       datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作/创建时间',

    -- 主键和索引
    PRIMARY KEY (`id`),
    KEY                 `idx_vehicle_id` (`vehicle_id`),
    KEY                 `idx_license_plate` (`license_plate`),
    KEY                 `idx_create_time` (`create_time`),
    KEY                 `idx_operation_type` (`operation_type`),
    KEY                 `idx_operator_id` (`operator_id`),
    KEY                 `idx_user_id` (`user_id`),
    KEY                 `idx_user_account` (`user_account`),
    KEY                 `idx_user_phone` (`user_phone`),
    KEY                 `idx_source` (`source`),
    KEY                 `idx_vehicle_create_time` (`vehicle_id`, `create_time`),
    KEY                 `idx_plate_create_time` (`license_plate`, `create_time`),
    KEY                 `idx_operator_create_time` (`operator_id`, `create_time`),
    KEY                 `idx_operation_type_time` (`operation_type`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='车辆操作日志表';



-- 新增货单启用禁用功能
-- 执行人：[Qi]
-- 执行时间：2025-11-10
-- 变更原因：将启用禁用状态从货单业务状态中分离，便于独立管理货单的可用性

ALTER TABLE sys_goods
    ADD COLUMN is_active TINYINT(1) DEFAULT 1 COMMENT '启用状态: 1-启用, 0-禁用',
ADD COLUMN disable_reason VARCHAR(255) COMMENT '禁用原因',
ADD INDEX idx_is_active (is_active);



-- ----------------------------
-- Table structure for sys_goods_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_goods_operation_log`;

CREATE TABLE `sys_goods_operation_log`
(
    `id`                bigint NOT NULL AUTO_INCREMENT,
    `goods_id`          bigint NOT NULL COMMENT '货单ID',
    `goods_no`          varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '货单编号',
    `operation_type`    smallint                                                      DEFAULT NULL COMMENT '操作类型：1-创建 2-修改 3-启用 4-禁用 5-派单 6-作废 7-完成 8-异常终止 9-报价 10-议价 11-状态变更',
    `operation_name`    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作类型名称',
    `operation_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '操作内容详情',
    `operation_summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作摘要',
    `operator_id`       bigint                                                        DEFAULT NULL COMMENT '操作人ID',
    `operator_name`     varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作人姓名',
    `create_time`       datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '操作/创建时间',
    PRIMARY KEY (`id`) USING BTREE,
    KEY                 `idx_goods_id` (`goods_id`) USING BTREE,
    KEY                 `idx_goods_no` (`goods_no`) USING BTREE,
    KEY                 `idx_operator_id` (`operator_id`) USING BTREE,
    KEY                 `idx_operation_type` (`operation_type`) USING BTREE,
    KEY                 `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='货单操作日志表';



-- ----------------------------
-- Table structure for sys_order_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_order_operation_log`;

CREATE TABLE `sys_order_operation_log`
(
    `id`                bigint NOT NULL AUTO_INCREMENT,
    `order_id`          bigint NOT NULL COMMENT '运单ID',
    `order_no`          varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '运单编号',
    `dispatch_no`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '调拨单编号',
    `goods_no`          varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '货单号',

    -- 操作类型信息
    `operation_type`    smallint                                                      DEFAULT NULL COMMENT '操作类型：1-创建 2-修改 3-派车 4-接单 5-拒绝 6-取消 7-上车 8-到达装货地 9-装货 10-到达卸货地 11-卸货 12-完成 13-作废 14-异常终止 15-状态变更 16-报价 17-议价 18-对账 19-开票 20-报销 21-修改装货榜单图片 22-修改装货净重 23-修改卸货榜单图片 24-修改卸货净重',
    `operation_name`    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作类型名称',
    `operation_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '操作内容详情',
    `operation_summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作摘要',

    -- 操作人信息
    `operator_id`       bigint                                                        DEFAULT NULL COMMENT '操作人ID',
    `operator_name`     varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作人姓名',

    -- 运单基础信息
    `order_create_time` datetime                                                      DEFAULT NULL COMMENT '运单创建时间',

    -- 司机信息
    `driver_id`         bigint                                                        DEFAULT NULL COMMENT '司机ID',
    `driver_name`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '司机姓名',
    `driver_phone`      varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '司机手机号',
    `car_id`            bigint                                                        DEFAULT NULL COMMENT '车辆ID',
    `car_no`            varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  DEFAULT NULL COMMENT '车牌号',

    -- 车队信息
    `fleet_id`          bigint                                                        DEFAULT NULL COMMENT '所属车队ID',
    `fleet_name`        varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '车队名称',

    -- 货主信息
    `shipper_id`        bigint                                                        DEFAULT NULL COMMENT '货主ID',
    `shipper_name`      varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '货主名称',

    -- 用户信息
    `user_id`           bigint                                                        DEFAULT NULL COMMENT '用户ID',
    `real_name`         varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户真实姓名',

    -- 时间信息
    `create_time`       datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '操作日志创建时间',

    PRIMARY KEY (`id`) USING BTREE,
    KEY                 `idx_order_id` (`order_id`) USING BTREE,
    KEY                 `idx_order_no` (`order_no`) USING BTREE,
    KEY                 `idx_dispatch_no` (`dispatch_no`) USING BTREE,
    KEY                 `idx_goods_no` (`goods_no`) USING BTREE,
    KEY                 `idx_operator_id` (`operator_id`) USING BTREE,
    KEY                 `idx_operation_type` (`operation_type`) USING BTREE,
    KEY                 `idx_driver_id` (`driver_id`),
    KEY                 `idx_fleet_id` (`fleet_id`),
    KEY                 `idx_shipper_id` (`shipper_id`),
    KEY                 `idx_car_no` (`car_no`),
    KEY                 `idx_order_create_time` (`order_create_time`),
    KEY                 `idx_create_time` (`create_time`),
    KEY                 `idx_composite_query` (`order_no`,`operation_type`,`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='运单操作日志表';


-- ---------------------------- reconciliation 使用“对账”的专业术语
-- Table structure for sys_statement_relationship
-- ---------------------------- reconciliation 使用“对账”的专业术语
DROP TABLE IF EXISTS `sys_statement_relationship`;

CREATE TABLE `sys_statement_relationship`
(
    `id`                        BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `shipper_subject_id`        BIGINT                                                        DEFAULT NULL COMMENT '货主主体ID',
    `shipper_subject_name`      VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '货主主体名称',
    `sign_subject_id`           BIGINT                                                        DEFAULT NULL COMMENT '平台主体（签约主体）ID',
    `sign_subject_name`         VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '平台主体名称',
    `fleet_id`                  BIGINT                                                        DEFAULT NULL COMMENT '车队ID',
    `fleet_name`                VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '车队名称',
    `fleet_manage_subject_name` VARCHAR(255)                                                  DEFAULT NULL COMMENT '车队管理主体名称',
    `type`                      VARCHAR(10)  NOT NULL COMMENT '类型：01-平台货源模式，02-车队直签模式',
    `is_deleted`                VARCHAR(10)  NOT NULL                                         DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
    `create_by`                 BIGINT       NOT NULL COMMENT '创建人ID',
    `create_by_name`            VARCHAR(255) NOT NULL COMMENT '创建人姓名',
    `create_time`               DATETIME     NOT NULL                                         DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by`                 BIGINT COMMENT '更新人ID',
    `update_by_name`            VARCHAR(255) COMMENT '更新人姓名',
    `update_time`               DATETIME     NOT NULL                                         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX                       `idx_type` ( `type` ),
    INDEX                       `idx_is_deleted` ( `is_deleted` )
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '对账关系表';



-- ----------------------------
-- Table structure for sys_shipper_statement_rule
-- ----------------------------
DROP TABLE IF EXISTS `sys_shipper_statement_rule`;

CREATE TABLE `sys_shipper_statement_rule`
(
    `id`                            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `shipper_subject_id`            BIGINT       NOT NULL COMMENT '货主主体ID',
    `shipper_subject_name`          VARCHAR(255) NOT NULL COMMENT '货主主体名称',

    `bill_generate_basis`           VARCHAR(20)  NOT NULL COMMENT '账单生成时间依据：01-派单时间，02-装货时间，03-卸货时间',

    `extra_fee_calculation_status`  VARCHAR(20)  NOT NULL COMMENT '额外费用是否参与计算：01-参与，02-不参与',
    `loss_fee_calculation_status`   VARCHAR(20)  NOT NULL COMMENT '损耗费用是否参与计算：01-参与，02-不参与',
    `direct_dispatch_fee_rate`      DECIMAL(6, 4) COMMENT '调度服务费费率，如0.05表示5%',


    `extra_fee_tax_bearer`          VARCHAR(20)  NOT NULL COMMENT '额外费用税费承担方：01-平台承担，02-货主承担',
    `extra_fee_bear_percentage`     DECIMAL(6, 4) COMMENT '承担额外费用的百分比',

    `loss_fee_calculation_mode`     VARCHAR(20) COMMENT '损耗费用整体计算模式：01-否（按单计算），02-是（整体计算）',
    `loss_fee_deduction_type`       VARCHAR(20)           DEFAULT NULL COMMENT '损耗费用扣款类型：01-全扣，02-不扣，03-按吨位扣，04-按比例扣',
    `loss_deduction_tonnage`        DECIMAL(12, 4)        DEFAULT NULL COMMENT '按吨位扣的吨位值（单位：吨）',
    `loss_deduction_ratio`          DECIMAL(6, 4)         DEFAULT NULL COMMENT '按比例扣的比例值（如0.05表示5%）',

    `rounding_fee_calculation_mode` VARCHAR(20) COMMENT '抹零费用整体计算模式：01-否（按单计算），02-是（整体计算）',
    `rounding_settlement_type`      VARCHAR(20)           DEFAULT NULL COMMENT '结算抹零方式：01-不抹零，02-抹零',
    `rounding_threshold`            DECIMAL(12, 2)        DEFAULT NULL COMMENT '抹零阈值（单位：元），如5表示少于5元时抹零',

    `freight_calculation_mode`      VARCHAR(20) COMMENT '运价整体计算模式：01-否（按单计算），02-是（整体计算）',
    `loss_tonnage_calculation_mode` VARCHAR(20) COMMENT '亏吨整体计算模式：01-否（按单计算），02-是（整体计算）',
    `settlement_quantity_type`      VARCHAR(20)           DEFAULT NULL COMMENT '结算数量计算方式：01-以装货数量结算，02-以卸货数量结算，03-以数量少的结算',


    `generate_rule_type`            VARCHAR(20)  NOT NULL COMMENT '对账生成规则类型：01-时间节点，02-运单间隔',
    `time_rule_type`                VARCHAR(20) COMMENT '时间规则类型：01-每日，02-每周，03-每月',
    `execute_time`                  VARCHAR(100) COMMENT '执行时间点（HH:mm:ss）',

    `weekly_days`                   VARCHAR(100)          DEFAULT '' COMMENT '每周执行日/基准日：JSON数组[1,2]，1=周一',
    `weekly_days_desc`              VARCHAR(100)          DEFAULT NULL COMMENT '每周执行日描述',
    `weekly_range_config`           VARCHAR(2000) COMMENT '每周范围配置：JSON格式，key为基准日(1-7)，value为选中的日期数组(-7到7，负数表示上周，正数表示本周)',
    `monthly_days`                  VARCHAR(100)          DEFAULT '' COMMENT '每月执行日/基准日：JSON数组[1,15,25]，1-31号',
    `monthly_days_desc`             VARCHAR(100)          DEFAULT NULL COMMENT '每月描述',
    `monthly_generate_type`         VARCHAR(20) COMMENT '每月生成范围类型：01-上个月自然日整月，02-截止生成时间30天内，03-指定时间范围',

    `monthly_time_ranges`           TEXT COMMENT '每月起始/结束时间范围：当monthly_generate_type=03时有效，JSON数组格式(-31到31，负数表示上月，正数表示本月) [[-2,-11],[-24,-26],[-29,-31],[-20,-20],[-28,-28]] ',
    `monthly_range_desc`            VARCHAR(500)          DEFAULT NULL COMMENT '每月范围描述',

    `order_interval_days`           INT COMMENT '货主若间隔多少天未产生新运单，则自动生成对账单',


    -- 逻辑删除建议使用 TINYINT(1) 或 DATETIME 软删除（记录删除时间）。用 VARCHAR 且默认值 '0' 会浪费空间且查询效率低。
    `is_deleted`                    TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0-否 1-是',
    `create_by`                     BIGINT       NOT NULL COMMENT '创建人ID',
    `create_by_name`                VARCHAR(255) NOT NULL COMMENT '创建人姓名',
    `create_time`                   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by`                     BIGINT COMMENT '更新人ID',
    `update_by_name`                VARCHAR(255) COMMENT '更新人姓名',
    `update_time`                   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_shipper_active` ( `shipper_subject_id`, `is_deleted` ) COMMENT '唯一约束',
    INDEX                           `idx_execute_time` ( `execute_time`, `is_deleted` )
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '货主对账规则配置表';



-- ----------------------------
-- Table structure for sys_fleet_statement_rule
-- ----------------------------
DROP TABLE IF EXISTS `sys_fleet_statement_rule`;

CREATE TABLE `sys_fleet_statement_rule`
(
    `id`                            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `fleet_id`                      BIGINT       NOT NULL COMMENT '车队ID',
    `fleet_name`                    VARCHAR(255)          DEFAULT NULL COMMENT '车队名称',
    `fleet_manage_subject_name`     VARCHAR(255)          DEFAULT NULL COMMENT '车队管理主体名称',

    `bill_generate_basis`           VARCHAR(20)  NOT NULL COMMENT '账单生成时间依据：01-派单时间，02-装货时间，03-卸货时间',

    `extra_fee_bill_generate`       VARCHAR(20) COMMENT '额外费用账单是否生成：01-不生成（否），02-生成（是）',
    `extra_fee_calculation_status`  VARCHAR(20)  NOT NULL COMMENT '额外费用是否参与计算：01-参与，02-不参与',
    `loss_fee_calculation_status`   VARCHAR(20)  NOT NULL COMMENT '损耗费用是否参与计算：01-参与，02-不参与',
    `direct_dispatch_fee_rate`      DECIMAL(6, 4) COMMENT '调度服务费费率，如0.05表示5%',


    `extra_fee_tax_bearer`          VARCHAR(20)  NOT NULL COMMENT '额外费用税费承担方：01-平台承担，02-车队承担',
    `extra_fee_bear_percentage`     DECIMAL(6, 4) COMMENT '承担额外费用的百分比',

    `loss_fee_calculation_mode`     VARCHAR(20) COMMENT '损耗费用整体计算模式：01-否（按单计算），02-是（整体计算）',
    `loss_fee_deduction_type`       VARCHAR(20)           DEFAULT NULL COMMENT '损耗费用扣款类型：01-全扣，02-不扣，03-按吨位扣，04-按比例扣',
    `loss_deduction_tonnage`        DECIMAL(12, 4)        DEFAULT NULL COMMENT '按吨位扣的吨位值（单位：吨）',
    `loss_deduction_ratio`          DECIMAL(6, 4)         DEFAULT NULL COMMENT '按比例扣的比例值（如0.05表示5%）',

    `rounding_fee_calculation_mode` VARCHAR(20) COMMENT '抹零费用整体计算模式：01-否（按单计算），02-是（整体计算）',
    `rounding_settlement_type`      VARCHAR(20)           DEFAULT NULL COMMENT '结算抹零方式：01-不抹零，02-抹零',
    `rounding_threshold`            DECIMAL(12, 2)        DEFAULT NULL COMMENT '抹零阈值（单位：元），如5表示少于5元时抹零',


    `freight_calculation_mode`      VARCHAR(20) COMMENT '运价整体计算模式：01-否（按单计算），02-是（整体计算）',
    `loss_tonnage_calculation_mode` VARCHAR(20) COMMENT '亏吨整体计算模式：01-否（按单计算），02-是（整体计算）',
    `settlement_quantity_type`      VARCHAR(20)           DEFAULT NULL COMMENT '结算数量计算方式：01-以装货数量结算，02-以卸货数量结算，03-以数量少的结算',


    `generate_rule_type`            VARCHAR(20)  NOT NULL COMMENT '对账生成规则类型：01-时间节点，02-运单间隔',
    `time_rule_type`                VARCHAR(20) COMMENT '时间规则类型：01-每日，02-每周，03-每月',
    `execute_time`                  VARCHAR(100) COMMENT '执行时间点（HH:mm:ss）',

    `weekly_days`                   VARCHAR(100)          DEFAULT '' COMMENT '每周执行日/基准日：JSON数组[1,2]，1=周一',
    `weekly_days_desc`              VARCHAR(100)          DEFAULT NULL COMMENT '每周执行日描述',
    `weekly_range_config`           VARCHAR(2000) COMMENT '每周范围配置：JSON格式，key为基准日(1-7)，value为选中的日期数组(-7到7，负数表示上周，正数表示本周)',
    `monthly_days`                  VARCHAR(100)          DEFAULT '' COMMENT '每月执行日/基准日：JSON数组[1,15,25]，1-31号',
    `monthly_days_desc`             VARCHAR(100)          DEFAULT NULL COMMENT '每月描述',
    `monthly_generate_type`         VARCHAR(20) COMMENT '每月生成范围类型：01-上个月自然日整月，02-截止生成时间30天内，03-指定时间范围',

    `monthly_time_ranges`           TEXT COMMENT '每月起始/结束时间范围：当monthly_generate_type=03时有效，JSON数组格式(-31到31，负数表示上月，正数表示本月) [[-2,-11],[-24,-26],[-29,-31],[-20,-20],[-28,-28]] ',
    `monthly_range_desc`            VARCHAR(500)          DEFAULT NULL COMMENT '每月范围描述',

    `order_interval_days`           INT COMMENT '货主若间隔多少天未产生新运单，则自动生成对账单',


    `follow_shipper_period`         VARCHAR(20)           DEFAULT NULL COMMENT '是否按货主周期：01-否：全部按车队周期走，02-是：部分按货主周期走',
    `except_shipper_ids`            TEXT                  DEFAULT NULL COMMENT '部分货主主体ID列表，JSON数组格式，如[1001,1002,1003]',
    `except_shipper_names`          TEXT                  DEFAULT NULL COMMENT '部分货主主体名称列表，JSON数组格式',


    `is_deleted`                    TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除 0-否 1-是',
    `create_by`                     BIGINT       NOT NULL COMMENT '创建人ID',
    `create_by_name`                VARCHAR(255) NOT NULL COMMENT '创建人姓名',
    `create_time`                   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by`                     BIGINT COMMENT '更新人ID',
    `update_by_name`                VARCHAR(255) COMMENT '更新人姓名',
    `update_time`                   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_fleet_active` ( `fleet_id`, `is_deleted` ) COMMENT '唯一约束',
    INDEX                           `idx_execute_time` ( `execute_time`, `is_deleted` ),
    INDEX                           `idx_follow_period` ( `follow_shipper_period`, `is_deleted` )
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '车队对账规则配置表';



-- ----------------------------
-- Table structure for sys_statement_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_statement_operation_log`;

CREATE TABLE `sys_statement_operation_log`
(
    `id`                bigint                                                        NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `statement_id`      bigint                                                        DEFAULT NULL COMMENT '对账单ID',
    `statement_no`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '对账单编号',
    `statement_type`    varchar(10)                                                   DEFAULT NULL COMMENT '对账单类型 01:货主对账 02:车主对账',

    -- 业务标识
    `biz_type`          varchar(20)                                                   DEFAULT NULL COMMENT '业务类型：01-对账单，02-对账关系，03-货主对账规则，04-车队对账规则',
    `biz_id`            bigint                                                        DEFAULT NULL COMMENT '业务ID',
    `biz_no`            varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务编号（如对账单号）',

    -- 运单关联信息
    `related_order_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '关联的运单ID列表（JSON数组格式）',
    `related_order_nos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '关联的运单编号列表（JSON数组格式）',

    -- 操作信息
    `operation_type`    smallint                                                      NOT NULL COMMENT '操作类型：1-创建 2-修改 3-确认 4-签章 5-开票 6-回款 7-审核 8-状态变更 9-作废 10-完成 11-运单关联 12-运单解除',
    `operation_name`    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型名称',
    `operation_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '操作内容详情（JSON格式，包含变更前后状态、字段值等）',
    `operation_summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作摘要',

    -- 操作人信息
    `operator_id`       bigint                                                        NOT NULL COMMENT '操作人ID',
    `operator_name`     varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作人姓名',
    `operator_role`     varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  DEFAULT NULL COMMENT '操作人角色',

    `create_time`       datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '创建/操作时间',

    PRIMARY KEY (`id`) USING BTREE,
    -- 核心业务查询索引
    KEY                 `idx_statement_id` (`statement_id`) USING BTREE,
    KEY                 `idx_statement_no` (`statement_no`) USING BTREE,
    KEY                 `idx_create_time` (`create_time`) USING BTREE,

    -- 操作人相关索引
    KEY                 `idx_operator_id` (`operator_id`) USING BTREE,

    -- 操作类型分析索引
    KEY                 `idx_operation_type` (`operation_type`) USING BTREE,

    -- 复合查询索引（常用查询场景）
    KEY                 `idx_statement_operator` (`statement_id`, `operator_id`) USING BTREE,
    KEY                 `idx_time_operation` (`create_time`, `operation_type`) USING BTREE,
    KEY                 `idx_statement_type_time` (`statement_type`, `create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='对账单相关业务操作日志表';



-- ----------------------------
-- Table structure for sys_order_discrepancy  运单差错表  waybill_discrepancy
-- ----------------------------
DROP TABLE IF EXISTS `sys_order_discrepancy`;

CREATE TABLE `sys_order_discrepancy`
(
    `id`               BIGINT                                                       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `discrepancy_no`   VARCHAR(64)                                                  NOT NULL COMMENT '差错单号',

    `order_id`         BIGINT                                                       NOT NULL COMMENT '运单ID',
    `order_no`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运单号',

    `discrepancy_type` VARCHAR(10)  DEFAULT NULL COMMENT '差错类型：01-重量差错，02-费用差错，03-财务差错',

    `before_data`      TEXT COMMENT '修改前数据快照',
    `after_data`       TEXT COMMENT '修改后数据',
    `change_fields`    TEXT COMMENT '需要修改的字段及新值（JSON格式）',

    -- 描述信息
    `description`      TEXT COMMENT '详细问题描述',

    -- 申请信息
    `apply_by`         BIGINT                                                       NOT NULL COMMENT '申请人ID',
    `apply_name`       VARCHAR(100) COMMENT '申请人姓名',
    --   `apply_time` DATETIME NOT NULL COMMENT '申请时间',
    `apply_reason`     TEXT COMMENT '申请原因/理由',
    --   `apply_data_before` JSON COMMENT '申请前数据快照',
--   `apply_data_after` JSON COMMENT '申请后数据',
    `apply_remark`     TEXT COMMENT '申请备注',

    -- 审核信息
    `audit_status`     TINYINT      DEFAULT 0 COMMENT '审核状态：0-待审核，1-审核通过，2-审核驳回',
    `audit_time`       DATETIME     DEFAULT NULL COMMENT '审核时间',
    `audit_by`         BIGINT       DEFAULT NULL COMMENT '审核人ID',
    `audit_name`       VARCHAR(100) DEFAULT NULL COMMENT '审核人姓名',
    `audit_opinion`    TEXT COMMENT '审核意见（如驳回原因）',

    -- 租户隔离（若系统支持多租户）
    `tenant_id`        BIGINT       DEFAULT NULL COMMENT '租户ID',
    `is_deleted`       TINYINT      DEFAULT 0 COMMENT '是否删除：0-否, 1-是',
    `create_time`      DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建/申请时间',
    `update_time`      DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`id`) USING BTREE,
    -- 核心业务查询索引

    UNIQUE KEY `uk_discrepancy_no` (`discrepancy_no`),
    KEY                `idx_order_id` ( `order_id` ) USING BTREE,
    KEY                `idx_order_no` (`order_no`) USING BTREE,


    KEY                `idx_audit_status` (`audit_status`),
    KEY                `idx_is_deleted` (`is_deleted`),
    KEY                `idx_create_time` (`create_time`) USING BTREE
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '运单差错表';


-- ----------------------------
-- Table structure for sys_release_version
-- ----------------------------
DROP TABLE IF EXISTS `sys_release_version`;
CREATE TABLE `sys_release_version`
(
    `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键，唯一标识一条版本记录',
    `version`        VARCHAR(50)  NOT NULL COMMENT '版本号，推荐格式：主版本号.次版本号.修订号 (例如 1.0.0)',
    `platform`       varchar(30)  NOT NULL DEFAULT 'web' COMMENT '发布平台：web（PC网页）、ios（iOS App）、android（Android App）、harmony（鸿蒙）、miniprogram_wechat（微信小程序）、miniprogram_alipay（支付宝小程序）、desktop_win（Windows桌面）、desktop_mac（Mac桌面）、server（后端服务）',
    `release_date`   datetime     NOT NULL COMMENT '发布日期时间（UTC）',
    `release_type`   varchar(20)  NOT NULL COMMENT '发布类型：initial（初始版）、major（主版本）、minor（次版本）、patch（补丁）、hotfix（热修复）、beta（测试版）',
    `is_mandatory`   TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否为强制更新版本，1: 强制更新, 0: 非强制（可忽略或建议更新）',
    `download_url`   VARCHAR(500)          DEFAULT NULL COMMENT '新版本的下载地址，可为空（例如不需要下载的场景）',
    `description`    VARCHAR(200) NOT NULL COMMENT '版本描述，简要说明本次更新的内容',
    `release_notes`  TEXT COMMENT '更详细的版本更新日志或发布说明，可包含变更点、影响范围、相关 Issue 链接等',
    `status`         varchar(20)           DEFAULT 'released' COMMENT '状态：planned（计划中）、released（已发布）、archived（归档）',
    `is_deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除: 0-否, 1-是',
    `create_by`      BIGINT       NOT NULL COMMENT '创建人ID',
    `create_by_name` VARCHAR(255) NOT NULL COMMENT '创建人姓名',
    `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by`      BIGINT COMMENT '更新人ID',
    `update_by_name` VARCHAR(255) COMMENT '更新人姓名',
    `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_version_platform` (`version`, `platform`),
    KEY              `idx_platform_release_date` (`platform`, `release_date`),
    KEY              `idx_status_deleted` (`status`, `is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统应用版本发布日志表';
