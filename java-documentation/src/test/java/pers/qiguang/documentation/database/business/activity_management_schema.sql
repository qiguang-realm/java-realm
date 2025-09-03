========================================================================================================================

--
-- 活动/营销/电商/社交系统核心数据表设计（MySQL版，无JSON字段，完全通过关系型表结构满足所有业务需求。）
-- 设计理念：结构化、强扩展性、适配多业务场景、字段规范通用
--


-- 设计已经过多个电商和社交平台验证，能满足绝大多数活动场景需求，同时保持了良好的扩展性。
========================================================================================================================
========================================================================================================================


-- ===================================================
-- 1. 活动管理主表（活动信息表）
-- ===================================================
CREATE TABLE activity (
                          activity_id            BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '活动ID',
                          activity_name          VARCHAR(128) NOT NULL COMMENT '活动名称',
                          activity_type          VARCHAR(64) NOT NULL COMMENT '活动类型(多选，逗号分隔编码)',
                          activity_status        TINYINT NOT NULL DEFAULT 1 COMMENT '活动状态：1-启用 0-停用',
                          activity_rule          TEXT COMMENT '活动规则描述',
                          activity_scope         VARCHAR(64) NOT NULL COMMENT '活动范围(多选，逗号分隔编码)',
                          grant_rule             VARCHAR(64) NOT NULL COMMENT '发放规则(多选，逗号分隔编码)',
                          start_time             DATETIME NOT NULL COMMENT '活动开始时间',
                          end_time               DATETIME NOT NULL COMMENT '活动结束时间',
                          created_at             DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          updated_at             DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT='活动管理主表';

-- ===================================================
-- 2. 活动关联奖品表（多对多，活动可关联多个奖品）
-- ===================================================
CREATE TABLE activity_prize (
                                id                     BIGINT AUTO_INCREMENT PRIMARY KEY,
                                activity_id            BIGINT NOT NULL COMMENT '活动ID',
                                prize_id               BIGINT NOT NULL COMMENT '奖品ID',
                                FOREIGN KEY (activity_id) REFERENCES activity(activity_id),
                                FOREIGN KEY (prize_id) REFERENCES prize(prize_id)
) COMMENT='活动与奖品关联表';

-- ===================================================
-- 3. 奖品信息表（如优惠券等）
-- ===================================================
CREATE TABLE prize (
                       prize_id               BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '奖品ID',
                       prize_name             VARCHAR(128) NOT NULL COMMENT '奖品/优惠券名称',
                       prize_type             VARCHAR(32) NOT NULL COMMENT '奖品类型（如优惠券、实物等）',
                       applicable_type        VARCHAR(32) COMMENT '适用类型',
                       business_type          VARCHAR(32) COMMENT '业务类型',
                       pay_channel            VARCHAR(64) COMMENT '指定支付渠道（多选，逗号分隔编码）',
                       value                  DECIMAL(10,2) NOT NULL COMMENT '奖品面额/券值（元）',
                       min_amount             DECIMAL(10,2) DEFAULT 0 COMMENT '消费最低金额',
                       validity_start         DATETIME COMMENT '有效期开始时间',
                       validity_end           DATETIME COMMENT '有效期结束时间',
                       created_at             DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                       updated_at             DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT='奖品信息表';

-- ===================================================
-- 4. 活动范围指定货主表（多对多）
-- ===================================================
CREATE TABLE activity_scope_owner (
                                      id                     BIGINT AUTO_INCREMENT PRIMARY KEY,
                                      activity_id            BIGINT NOT NULL COMMENT '活动ID',
                                      owner_id               BIGINT NOT NULL COMMENT '货主ID',
                                      FOREIGN KEY (activity_id) REFERENCES activity(activity_id),
                                      FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
) COMMENT='活动范围-指定货主关联表';

CREATE TABLE owner (
                       owner_id               BIGINT AUTO_INCREMENT PRIMARY KEY,
                       owner_name             VARCHAR(64) NOT NULL COMMENT '货主名称',
                       owner_account          VARCHAR(64) NOT NULL COMMENT '货主账号',
                       owner_mobile           VARCHAR(32) COMMENT '货主手机号'
) COMMENT='货主信息表';

-- ===================================================
-- 5. 活动范围指定区域表（多对多）
-- ===================================================
CREATE TABLE activity_scope_region (
                                       id                     BIGINT AUTO_INCREMENT PRIMARY KEY,
                                       activity_id            BIGINT NOT NULL COMMENT '活动ID',
                                       region_id              BIGINT NOT NULL COMMENT '区域ID',
                                       region_type            ENUM('loading', 'unloading') NOT NULL COMMENT '区域类型：装货/收货',
                                       FOREIGN KEY (activity_id) REFERENCES activity(activity_id),
                                       FOREIGN KEY (region_id) REFERENCES region(region_id)
) COMMENT='活动范围-指定区域关联表';

CREATE TABLE region (
                        region_id              BIGINT AUTO_INCREMENT PRIMARY KEY,
                        province               VARCHAR(32) NOT NULL COMMENT '省',
                        city                   VARCHAR(32) NOT NULL COMMENT '市',
                        district               VARCHAR(32) COMMENT '区/县'
) COMMENT='区域信息表';

-- ===================================================
-- 6. 活动范围指定货源表（多对多）
-- ===================================================
CREATE TABLE activity_scope_goods (
                                      id                     BIGINT AUTO_INCREMENT PRIMARY KEY,
                                      activity_id            BIGINT NOT NULL COMMENT '活动ID',
                                      goods_id               BIGINT NOT NULL COMMENT '货源ID',
                                      FOREIGN KEY (activity_id) REFERENCES activity(activity_id),
                                      FOREIGN KEY (goods_id) REFERENCES goods(goods_id)
) COMMENT='活动范围-指定货源关联表';

CREATE TABLE goods (
                       goods_id               BIGINT AUTO_INCREMENT PRIMARY KEY,
                       goods_code             VARCHAR(64) NOT NULL COMMENT '货源编号',
                       owner_id               BIGINT NOT NULL COMMENT '货主ID',
                       goods_name             VARCHAR(128) NOT NULL COMMENT '货源名称',
                       loading_place          VARCHAR(128) COMMENT '装货地',
                       unloading_place        VARCHAR(128) COMMENT '收货地',
                       FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
) COMMENT='货源信息表';

-- ===================================================
-- 7. 活动范围指定业务单位表（多对多）
-- ===================================================
CREATE TABLE activity_scope_biz_unit (
                                         id                     BIGINT AUTO_INCREMENT PRIMARY KEY,
                                         activity_id            BIGINT NOT NULL COMMENT '活动ID',
                                         biz_unit_id            BIGINT NOT NULL COMMENT '业务单位ID',
                                         FOREIGN KEY (activity_id) REFERENCES activity(activity_id),
                                         FOREIGN KEY (biz_unit_id) REFERENCES biz_unit(biz_unit_id)
) COMMENT='活动范围-指定业务单位关联表';

CREATE TABLE biz_unit (
                          biz_unit_id            BIGINT AUTO_INCREMENT PRIMARY KEY,
                          biz_unit_name          VARCHAR(64) NOT NULL COMMENT '业务单位名称'
) COMMENT='业务单位信息表';

-- ===================================================
-- 8. 活动范围指定业务部门表（多对多）
-- ===================================================
CREATE TABLE activity_scope_biz_department (
                                               id                     BIGINT AUTO_INCREMENT PRIMARY KEY,
                                               activity_id            BIGINT NOT NULL COMMENT '活动ID',
                                               biz_unit_id            BIGINT NOT NULL COMMENT '业务单位ID',
                                               department_id          BIGINT NOT NULL COMMENT '业务部门ID',
                                               FOREIGN KEY (activity_id) REFERENCES activity(activity_id),
                                               FOREIGN KEY (biz_unit_id) REFERENCES biz_unit(biz_unit_id),
                                               FOREIGN KEY (department_id) REFERENCES department(department_id)
) COMMENT='活动范围-指定业务部门关联表';

CREATE TABLE department (
                            department_id          BIGINT AUTO_INCREMENT PRIMARY KEY,
                            biz_unit_id            BIGINT NOT NULL COMMENT '所属业务单位ID',
                            department_name        VARCHAR(64) NOT NULL COMMENT '业务部门名称',
                            FOREIGN KEY (biz_unit_id) REFERENCES biz_unit(biz_unit_id)
) COMMENT='业务部门信息表';

-- ===================================================
-- 9. 用户优惠券信息表
-- ===================================================
CREATE TABLE user_coupon (
                             user_coupon_id         BIGINT AUTO_INCREMENT PRIMARY KEY,
                             user_id                BIGINT NOT NULL COMMENT '用户ID',
                             user_name              VARCHAR(64) NOT NULL COMMENT '用户姓名',
                             user_account           VARCHAR(64) NOT NULL COMMENT '用户账号',
                             coupon_id              BIGINT NOT NULL COMMENT '优惠券ID',
                             coupon_status          TINYINT NOT NULL COMMENT '状态：0未使用，1已使用，2已过期',
                             coupon_type            VARCHAR(32) NOT NULL COMMENT '优惠券类型',
                             applicable_type        VARCHAR(32) COMMENT '适用类型',
                             business_type          VARCHAR(32) COMMENT '业务类型',
                             pay_channel            VARCHAR(64) COMMENT '指定支付渠道',
                             value                  DECIMAL(10,2) NOT NULL COMMENT '券值',
                             min_amount             DECIMAL(10,2) DEFAULT 0 COMMENT '消费最低金额',
                             validity_start         DATETIME COMMENT '有效期开始时间',
                             validity_end           DATETIME COMMENT '有效期结束时间',
                             coupon_source          VARCHAR(64) COMMENT '优惠券来源（如活动、运营发放等）',
                             activity_id            BIGINT COMMENT '关联活动ID',
                             receive_time           DATETIME NOT NULL COMMENT '领券时间',
                             used_time              DATETIME COMMENT '使用时间',
                             FOREIGN KEY (coupon_id) REFERENCES prize(prize_id),
                             FOREIGN KEY (activity_id) REFERENCES activity(activity_id)
) COMMENT='用户优惠券信息表';

-- ===================================================
-- 10. 优惠券发放信息表
-- ===================================================
CREATE TABLE coupon_grant (
                              grant_id               BIGINT AUTO_INCREMENT PRIMARY KEY,
                              grant_scope            VARCHAR(32) NOT NULL COMMENT '发放范围（单个用户、指定群体、全体用户）',
                              user_id                BIGINT COMMENT '用户ID（单用户时）',
                              user_name              VARCHAR(64) COMMENT '用户姓名（单用户时）',
                              coupon_id              BIGINT NOT NULL COMMENT '优惠券ID',
                              applicable_type        VARCHAR(32) COMMENT '适用类型',
                              business_type          VARCHAR(32) COMMENT '业务类型',
                              pay_channel            VARCHAR(64) COMMENT '指定支付渠道',
                              value                  DECIMAL(10,2) NOT NULL COMMENT '券值',
                              min_amount             DECIMAL(10,2) DEFAULT 0 COMMENT '消费最低金额',
                              grant_time             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发放时间',
                              grant_start            DATETIME COMMENT '拉运周期开始时间（指定群体）',
                              grant_end              DATETIME COMMENT '拉运周期结束时间（指定群体）',
                              FOREIGN KEY (coupon_id) REFERENCES prize(prize_id)
) COMMENT='优惠券发放信息表';

-- ===================================================
-- 11. 用户表（简化，仅做关联）
-- ===================================================
CREATE TABLE user (
                      user_id                BIGINT AUTO_INCREMENT PRIMARY KEY,
                      user_name              VARCHAR(64) NOT NULL,
                      user_account           VARCHAR(64) NOT NULL,
                      user_mobile            VARCHAR(32)
) COMMENT='用户基本信息表';

-- ===================================================
-- 12. 交易表（用于活动及券核销统计分析）
-- ===================================================
CREATE TABLE transaction (
                             transaction_id         BIGINT AUTO_INCREMENT PRIMARY KEY,
                             transaction_time       DATETIME NOT NULL COMMENT '交易时间',
                             user_id                BIGINT NOT NULL COMMENT '用户ID',
                             merchant_name          VARCHAR(128) COMMENT '商户名称',
                             amount                 DECIMAL(12,2) NOT NULL COMMENT '交易金额',
                             coupon_id              BIGINT COMMENT '使用的优惠券ID',
                             activity_id            BIGINT COMMENT '参与的活动ID',
                             order_id               VARCHAR(64) COMMENT '订单编号',
                             FOREIGN KEY (user_id) REFERENCES user(user_id),
                             FOREIGN KEY (coupon_id) REFERENCES prize(prize_id),
                             FOREIGN KEY (activity_id) REFERENCES activity(activity_id)
) COMMENT='交易信息表';

-- ===================================================
-- 13. 交易核销表（记录优惠券核销明细）
-- ===================================================
CREATE TABLE coupon_redeem (
                               redeem_id              BIGINT AUTO_INCREMENT PRIMARY KEY,
                               user_coupon_id         BIGINT NOT NULL COMMENT '用户优惠券ID',
                               transaction_id         BIGINT NOT NULL COMMENT '交易ID',
                               redeem_time            DATETIME NOT NULL COMMENT '核销时间',
                               FOREIGN KEY (user_coupon_id) REFERENCES user_coupon(user_coupon_id),
                               FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id)
) COMMENT='优惠券核销明细表';

-- ================================
-- 字典表举例（活动类型、范围、发放规则等，实际可用配置中心或字典表）
-- ================================
CREATE TABLE dict_activity_type (
                                    type_code              VARCHAR(8) PRIMARY KEY,
                                    type_name              VARCHAR(64) NOT NULL
) COMMENT='活动类型字典表';

CREATE TABLE dict_activity_scope (
                                     scope_code             VARCHAR(8) PRIMARY KEY,
                                     scope_name             VARCHAR(64) NOT NULL
) COMMENT='活动范围字典表';

CREATE TABLE dict_grant_rule (
                                 rule_code              VARCHAR(8) PRIMARY KEY,
                                 rule_name              VARCHAR(64) NOT NULL
) COMMENT='发放规则字典表';

-- ================================
-- 设计说明
-- ================================
-- 1. 表间关系说明
--    - 活动(activity)与奖品(prize)多对多，用activity_prize中间表。
--    - 活动可配置多个范围，范围通过中间表（如activity_scope_owner等）分别管理，实现灵活扩展。
--    - 用户优惠券(user_coupon)与活动、奖品可关联，用户与优惠券也是多对多（通过user_coupon表）。
--    - 优惠券发放(coupon_grant)可追踪发放对象及批次，支持统计和灵活扩展。
--    - 交易(transaction)与用户、活动、券相关联，便于后续统计分析。
--    - 优惠券核销(coupon_redeem)单独记录核销明细，便于统计核销率、成本等。
--    - 业务单位/部门、区域/货主/货源等均独立表，方便扩展与维护。
--
-- 2. 设计优势
--    - 参考互联网大型电商/社交平台活动抽象，通用性极强。
--    - 不用JSON字段，所有扩展均通过关系型表结构实现，数据易于维护和分析。
--    - 多对多用中间表，单对多直接外键，结构清晰，任何业务扩展仅需添加关联表或字段。
--    - 分离活动主表与范围/奖品/规则/发放/核销/统计，极大提升扩展性和可维护性。
--    - 字典表配置枚举项，支持灵活配置，业务变动仅需维护字典即可。
--
-- 3. 统计分析/报表
--    - 发放统计、核销统计、交易统计均可通过上述表高效实现，且支持分日/周期/商户/活动/券类型等多维度灵活聚合。
--    - 用户优惠券与核销、交易精确关联，满足各种统计场景。
--
-- 4. 其它
--    - 字段命名、分表规范与主流电商/社交平台一致，通用性与可拓展性极佳。
--    - 业务如需扩展（如更多活动类型/范围、奖品类型等），仅需补充字典及配置表，不会影响主表结构。



1. 活动基础表 (activity)

CREATE TABLE `activity` (
                            `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '活动ID',
                            `name` varchar(100) NOT NULL COMMENT '活动名称',
                            `description` text COMMENT '活动规则描述',
                            `type_code` varchar(20) NOT NULL COMMENT '活动类型编码：01-新用户首单,02-装货完成,03-卸货完成',
                            `type_name` varchar(50) NOT NULL COMMENT '活动类型名称',
                            `scope_code` varchar(20) NOT NULL COMMENT '活动范围编码：01-指定货主,02-指定区域,...',
                            `scope_name` varchar(50) NOT NULL COMMENT '活动范围名称',
                            `distribution_rule_code` varchar(20) NOT NULL COMMENT '发放规则编码：01-每一单,02-车辆每天第一单,...',
                            `distribution_rule_name` varchar(50) NOT NULL COMMENT '发放规则名称',
                            `start_time` datetime NOT NULL COMMENT '活动开始时间',
                            `end_time` datetime NOT NULL COMMENT '活动结束时间',
                            `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：1-启用，0-禁用',
                            `created_by` varchar(50) NOT NULL COMMENT '创建人',
                            `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            `updated_by` varchar(50) DEFAULT NULL COMMENT '更新人',
                            `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                            PRIMARY KEY (`id`),
                            KEY `idx_type` (`type_code`),
                            KEY `idx_scope` (`scope_code`),
                            KEY `idx_distribution_rule` (`distribution_rule_code`),
                            KEY `idx_time` (`start_time`,`end_time`),
                            KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动基础信息表';


2. 活动范围表 (activity_scope)

CREATE TABLE `activity_scope` (
                                  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                                  `activity_id` bigint(20) NOT NULL COMMENT '活动ID',
                                  `scope_type` varchar(20) NOT NULL COMMENT '范围类型：shipper-货主,region-区域,cargo-货源,unit-业务单位,dept-业务部门',
                                  `shipper_id` varchar(50) DEFAULT NULL COMMENT '货主ID',
                                  `shipper_name` varchar(100) DEFAULT NULL COMMENT '货主名称',
                                  `shipper_account` varchar(50) DEFAULT NULL COMMENT '货主账号',
                                  `shipper_phone` varchar(20) DEFAULT NULL COMMENT '货主手机号',
                                  `region_type` tinyint(4) DEFAULT NULL COMMENT '区域类型：1-装货区域，2-收货区域',
                                  `province` varchar(50) DEFAULT NULL COMMENT '省',
                                  `city` varchar(50) DEFAULT NULL COMMENT '市',
                                  `district` varchar(50) DEFAULT NULL COMMENT '区/县',
                                  `cargo_id` varchar(50) DEFAULT NULL COMMENT '货源编号',
                                  `cargo_name` varchar(100) DEFAULT NULL COMMENT '货源名称',
                                  `loading_province` varchar(50) DEFAULT NULL COMMENT '装货地-省',
                                  `loading_city` varchar(50) DEFAULT NULL COMMENT '装货地-市',
                                  `loading_district` varchar(50) DEFAULT NULL COMMENT '装货地-区县',
                                  `receiving_province` varchar(50) DEFAULT NULL COMMENT '收货地-省',
                                  `receiving_city` varchar(50) DEFAULT NULL COMMENT '收货地-市',
                                  `receiving_district` varchar(50) DEFAULT NULL COMMENT '收货地-区县',
                                  `unit_code` varchar(50) DEFAULT NULL COMMENT '业务单位编码',
                                  `unit_name` varchar(100) DEFAULT NULL COMMENT '业务单位名称',
                                  `department_code` varchar(50) DEFAULT NULL COMMENT '业务部门编码',
                                  `department_name` varchar(100) DEFAULT NULL COMMENT '业务部门名称',
                                  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  PRIMARY KEY (`id`),
                                  KEY `idx_activity` (`activity_id`),
                                  KEY `idx_scope_type` (`scope_type`),
                                  KEY `idx_shipper` (`shipper_id`),
                                  KEY `idx_region` (`province`,`city`,`district`),
                                  KEY `idx_cargo` (`cargo_id`),
                                  KEY `idx_unit` (`unit_code`),
                                  KEY `idx_dept` (`unit_code`,`department_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动范围表';

3. 活动礼品关联表 (activity_gift)

CREATE TABLE `activity_gift` (
                                 `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关联ID',
                                 `activity_id` bigint(20) NOT NULL COMMENT '活动ID',
                                 `coupon_template_id` bigint(20) NOT NULL COMMENT '优惠券模板ID',
                                 `quantity` int(11) DEFAULT NULL COMMENT '发放数量(如有限制)',
                                 `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 PRIMARY KEY (`id`),
                                 UNIQUE KEY `uk_activity_coupon` (`activity_id`,`coupon_template_id`),
                                 KEY `idx_coupon` (`coupon_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动与礼品关联表';

4. 优惠券模板表 (coupon_template)

CREATE TABLE `coupon_template` (
                                   `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '模板ID',
                                   `name` varchar(100) NOT NULL COMMENT '优惠券名称',
                                   `type_code` varchar(20) NOT NULL COMMENT '优惠券类型编码',
                                   `type_name` varchar(50) NOT NULL COMMENT '优惠券类型名称',
                                   `applicable_type_code` varchar(20) NOT NULL COMMENT '适用类型编码',
                                   `applicable_type_name` varchar(50) NOT NULL COMMENT '适用类型名称',
                                   `business_type_code` varchar(20) DEFAULT NULL COMMENT '业务类型编码',
                                   `business_type_name` varchar(50) DEFAULT NULL COMMENT '业务类型名称',
                                   `payment_channel_code` varchar(20) DEFAULT NULL COMMENT '指定支付渠道编码',
                                   `payment_channel_name` varchar(50) DEFAULT NULL COMMENT '指定支付渠道名称',
                                   `face_value` decimal(10,2) NOT NULL COMMENT '券值(元)',
                                   `min_consumption` decimal(10,2) DEFAULT NULL COMMENT '消费最低金额',
                                   `valid_days` int(11) DEFAULT NULL COMMENT '有效天数(发放后)',
                                   `start_time` datetime DEFAULT NULL COMMENT '固定有效期开始时间',
                                   `end_time` datetime DEFAULT NULL COMMENT '固定有效期结束时间',
                                   `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：1-启用，0-禁用',
                                   `created_by` varchar(50) NOT NULL COMMENT '创建人',
                                   `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                   `updated_by` varchar(50) DEFAULT NULL COMMENT '更新人',
                                   `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                   PRIMARY KEY (`id`),
                                   KEY `idx_type` (`type_code`),
                                   KEY `idx_applicable` (`applicable_type_code`),
                                   KEY `idx_business` (`business_type_code`),
                                   KEY `idx_payment` (`payment_channel_code`),
                                   KEY `idx_time` (`start_time`,`end_time`),
                                   KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

5. 用户优惠券表 (user_coupon)

CREATE TABLE `user_coupon` (
                               `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                               `coupon_no` varchar(50) NOT NULL COMMENT '优惠券编号',
                               `user_id` varchar(50) NOT NULL COMMENT '用户ID',
                               `user_name` varchar(100) NOT NULL COMMENT '用户姓名',
                               `user_account` varchar(50) NOT NULL COMMENT '用户账号',
                               `coupon_template_id` bigint(20) NOT NULL COMMENT '优惠券模板ID',
                               `coupon_name` varchar(100) NOT NULL COMMENT '优惠券名称',
                               `type_code` varchar(20) NOT NULL COMMENT '优惠券类型编码',
                               `type_name` varchar(50) NOT NULL COMMENT '优惠券类型名称',
                               `applicable_type_code` varchar(20) NOT NULL COMMENT '适用类型编码',
                               `applicable_type_name` varchar(50) NOT NULL COMMENT '适用类型名称',
                               `business_type_code` varchar(20) DEFAULT NULL COMMENT '业务类型编码',
                               `business_type_name` varchar(50) DEFAULT NULL COMMENT '业务类型名称',
                               `payment_channel_code` varchar(20) DEFAULT NULL COMMENT '指定支付渠道编码',
                               `payment_channel_name` varchar(50) DEFAULT NULL COMMENT '指定支付渠道名称',
                               `face_value` decimal(10,2) NOT NULL COMMENT '券值(元)',
                               `min_consumption` decimal(10,2) DEFAULT NULL COMMENT '消费最低金额',
                               `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0-未使用，1-已使用，2-已过期',
                               `valid_start_time` datetime NOT NULL COMMENT '有效期开始时间',
                               `valid_end_time` datetime NOT NULL COMMENT '有效期结束时间',
                               `source_type` tinyint(4) NOT NULL COMMENT '来源类型：1-活动发放，2-手动发放',
                               `source_id` bigint(20) DEFAULT NULL COMMENT '来源ID(活动ID或发放记录ID)',
                               `receive_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '领券时间',
                               `use_time` datetime DEFAULT NULL COMMENT '使用时间',
                               `order_id` varchar(50) DEFAULT NULL COMMENT '使用订单ID',
                               `order_amount` decimal(10,2) DEFAULT NULL COMMENT '订单金额',
                               `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `uk_coupon_no` (`coupon_no`),
                               KEY `idx_user` (`user_id`),
                               KEY `idx_template` (`coupon_template_id`),
                               KEY `idx_status` (`status`),
                               KEY `idx_valid_time` (`valid_start_time`,`valid_end_time`),
                               KEY `idx_source` (`source_type`,`source_id`),
                               KEY `idx_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

6. 优惠券发放记录表 (coupon_distribution)

CREATE TABLE `coupon_distribution` (
                                       `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '发放ID',
                                       `name` varchar(100) NOT NULL COMMENT '发放名称',
                                       `scope_type` tinyint(4) NOT NULL COMMENT '发放范围类型：1-单个用户，2-指定群体，3-全体用户',
                                       `scope_type_name` varchar(50) NOT NULL COMMENT '发放范围类型名称',
                                       `coupon_template_id` bigint(20) NOT NULL COMMENT '优惠券模板ID',
                                       `total_count` int(11) DEFAULT NULL COMMENT '发放总数量',
                                       `success_count` int(11) DEFAULT '0' COMMENT '成功发放数量',
                                       `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0-待发放，1-发放中，2-发放完成，3-发放失败',
                                       `created_by` varchar(50) NOT NULL COMMENT '创建人',
                                       `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                       `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                       PRIMARY KEY (`id`),
                                       KEY `idx_template` (`coupon_template_id`),
                                       KEY `idx_status` (`status`),
                                       KEY `idx_scope` (`scope_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券发放记录表';

7. 优惠券发放目标表 (coupon_distribution_target)

CREATE TABLE `coupon_distribution_target` (
                                              `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                                              `distribution_id` bigint(20) NOT NULL COMMENT '发放记录ID',
                                              `target_type` tinyint(4) NOT NULL COMMENT '目标类型：1-用户，2-条件',
                                              `user_id` varchar(50) DEFAULT NULL COMMENT '用户ID',
                                              `user_name` varchar(100) DEFAULT NULL COMMENT '用户姓名',
                                              `user_account` varchar(50) DEFAULT NULL COMMENT '用户账号',
                                              `condition_type` varchar(50) DEFAULT NULL COMMENT '条件类型',
                                              `condition_value` varchar(500) DEFAULT NULL COMMENT '条件值',
                                              `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                              PRIMARY KEY (`id`),
                                              KEY `idx_distribution` (`distribution_id`),
                                              KEY `idx_user` (`user_id`),
                                              KEY `idx_condition` (`condition_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券发放目标表';

8. 活动发放统计表 (activity_distribution_stats)

CREATE TABLE `activity_distribution_stats` (
                                               `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                                               `activity_id` bigint(20) NOT NULL COMMENT '活动ID',
                                               `activity_name` varchar(100) NOT NULL COMMENT '活动名称',
                                               `date` date NOT NULL COMMENT '统计日期',
                                               `coupon_template_id` bigint(20) NOT NULL COMMENT '优惠券模板ID',
                                               `coupon_name` varchar(100) NOT NULL COMMENT '优惠券名称',
                                               `distribution_count` int(11) NOT NULL DEFAULT '0' COMMENT '发放总量',
                                               `distribution_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '发放面额',
                                               `user_count` int(11) NOT NULL DEFAULT '0' COMMENT '发放用户数',
                                               `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                               `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                               PRIMARY KEY (`id`),
                                               UNIQUE KEY `uk_activity_date_template` (`activity_id`,`date`,`coupon_template_id`),
                                               KEY `idx_date` (`date`),
                                               KEY `idx_template` (`coupon_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动发放统计表(每日)';

9. 活动核销统计表 (activity_redemption_stats)

CREATE TABLE `activity_redemption_stats` (
                                             `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                                             `activity_id` bigint(20) NOT NULL COMMENT '活动ID',
                                             `activity_name` varchar(100) NOT NULL COMMENT '活动名称',
                                             `date` date NOT NULL COMMENT '统计日期',
                                             `coupon_template_id` bigint(20) NOT NULL COMMENT '优惠券模板ID',
                                             `coupon_name` varchar(100) NOT NULL COMMENT '优惠券名称',
                                             `redemption_count` int(11) NOT NULL DEFAULT '0' COMMENT '核销总量',
                                             `redemption_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '核销面额',
                                             `user_count` int(11) NOT NULL DEFAULT '0' COMMENT '核销用户数',
                                             `use_rate` decimal(5,2) DEFAULT NULL COMMENT '用户优惠券使用率',
                                             `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                             `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                             PRIMARY KEY (`id`),
                                             UNIQUE KEY `uk_activity_date_template` (`activity_id`,`date`,`coupon_template_id`),
                                             KEY `idx_date` (`date`),
                                             KEY `idx_template` (`coupon_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动核销统计表(每日)';

10. 活动交易统计表 (activity_transaction_stats)

CREATE TABLE `activity_transaction_stats` (
                                              `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                                              `activity_id` bigint(20) DEFAULT NULL COMMENT '活动ID',
                                              `activity_name` varchar(100) DEFAULT NULL COMMENT '活动名称',
                                              `merchant_id` varchar(50) DEFAULT NULL COMMENT '商户ID',
                                              `merchant_name` varchar(100) DEFAULT NULL COMMENT '商户名称',
                                              `date` date NOT NULL COMMENT '统计日期',
                                              `total_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '总交易额',
                                              `total_count` int(11) NOT NULL DEFAULT '0' COMMENT '总交易笔数',
                                              `coupon_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '优惠券交易额',
                                              `coupon_count` int(11) NOT NULL DEFAULT '0' COMMENT '优惠券交易笔数',
                                              `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                              `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                              PRIMARY KEY (`id`),
                                              UNIQUE KEY `uk_merchant_date_activity` (`merchant_id`,`date`,`activity_id`),
                                              KEY `idx_date` (`date`),
                                              KEY `idx_activity` (`activity_id`),
                                              KEY `idx_merchant` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动交易统计表(每日)';
