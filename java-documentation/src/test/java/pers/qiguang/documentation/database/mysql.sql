
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
