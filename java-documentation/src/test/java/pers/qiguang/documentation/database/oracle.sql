-- 在Oracle数据库中，复制一个一模一样的表通常指的是创建一个具有相同结构（包括数据类型、列名、列顺序等）和数据的表。

CREATE TABLE new_table AS SELECT * FROM KYC_VEHICLE_USER;


CREATE TABLE sys_user_license (
                                  id VARCHAR2(64) NOT NULL,
                                  user_id VARCHAR2(64) NOT NULL,
                                  user_name VARCHAR2(100),
                                  user_phone VARCHAR2(200),
                                  license_id VARCHAR2(64) NOT NULL,
                                  license_type VARCHAR2(64) NOT NULL,
                                  license_version VARCHAR2(50) NOT NULL,
                                  accept_time DATE NOT NULL,
                                  ip_address VARCHAR2(50),
                                  device_info VARCHAR2(200),
                                  CONSTRAINT pk_sys_user_license PRIMARY KEY (id)
);

COMMENT ON TABLE sys_user_license IS '系统用户协议接受记录表';

-- 列注释
COMMENT ON COLUMN sys_user_license.id IS '主键ID';
COMMENT ON COLUMN sys_user_license.user_id IS '用户ID';
COMMENT ON COLUMN sys_user_license.user_name IS '用户名称';
COMMENT ON COLUMN sys_user_license.user_phone IS '用户手机号';
COMMENT ON COLUMN sys_user_license.license_id IS '协议ID';
COMMENT ON COLUMN sys_user_license.license_type IS '协议类型(与sys_license_agreement.type对应)';
COMMENT ON COLUMN sys_user_license.license_version IS '协议版本号';
COMMENT ON COLUMN sys_user_license.accept_time IS '接受时间';
COMMENT ON COLUMN sys_user_license.ip_address IS '接受时的IP地址';
COMMENT ON COLUMN sys_user_license.device_info IS '设备信息';

-- 创建索引
CREATE INDEX idx_sul_user_license ON sys_user_license(user_id, license_id);
CREATE INDEX idx_sul_user_phone ON sys_user_license(user_phone);
CREATE INDEX idx_sul_license_type_version ON sys_user_license(license_type, license_version);


-- 创建用户合同签署信息表
CREATE TABLE kyc_contract_signatures (
                                         id VARCHAR2 ( 64 ) NOT NULL,

                                         contract_id VARCHAR2 ( 64 ) DEFAULT NULL,
                                         contract_number VARCHAR2 ( 64 ) DEFAULT NULL,
                                         contract_type VARCHAR2 ( 64 ) DEFAULT NULL,
                                         contract_name VARCHAR2 ( 64 ) DEFAULT NULL,
                                         contract_version VARCHAR2 ( 64 ) DEFAULT NULL,

                                         signature_method VARCHAR2 ( 64 ) DEFAULT NULL,
                                         signature_time DATE DEFAULT NULL,
                                         signature_file_path CLOB DEFAULT NULL,
                                         signature_file_url VARCHAR2 ( 255 ) DEFAULT NULL,
                                         contract_file_url VARCHAR2 ( 255 ) DEFAULT NULL,

                                         start_time VARCHAR2 ( 64 ) DEFAULT NULL,
                                         end_time VARCHAR2 ( 64 ) DEFAULT NULL,

                                         user_id VARCHAR2 ( 255 ) DEFAULT NULL,
                                         user_name VARCHAR2 ( 255 ) DEFAULT NULL,
                                         user_phone VARCHAR2 ( 255 ) DEFAULT NULL,
                                         user_identity VARCHAR2 ( 255 ) DEFAULT NULL,

                                         account_id VARCHAR2 ( 255 ) DEFAULT NULL,
                                         file_path VARCHAR2 ( 255 ) DEFAULT NULL,

                                         status VARCHAR2 ( 64 ) DEFAULT NULL,
                                         create_time DATE NOT NULL,
                                         creator_id VARCHAR2 ( 64 ) DEFAULT NULL,
                                         creator_name VARCHAR2 ( 255 ) DEFAULT NULL,
                                         update_time DATE DEFAULT NULL,
                                         updater_id VARCHAR2 ( 64 ) DEFAULT NULL,
                                         updater_name VARCHAR2 ( 255 ) DEFAULT NULL,
                                         CONSTRAINT pk_kyc_contract_signatures PRIMARY KEY ( id )
);

-- 创建索引以提高查询性能

CREATE INDEX idx_kyc_signatures_contract_id ON kyc_contract_signatures(contract_id);
CREATE INDEX idx_kyc_signatures_user_id ON kyc_contract_signatures(user_id);
CREATE INDEX idx_kyc_signatures_status ON kyc_contract_signatures(status);

-- 表注释
COMMENT ON TABLE kyc_contract_signatures IS '用户合同签署信息表';

-- 字段注释
COMMENT ON COLUMN kyc_contract_signatures.id IS '主键ID';
COMMENT ON COLUMN kyc_contract_signatures.contract_id IS '合同ID';
COMMENT ON COLUMN kyc_contract_signatures.contract_number IS '合同编号';
COMMENT ON COLUMN kyc_contract_signatures.contract_type IS '合同类型';
COMMENT ON COLUMN kyc_contract_signatures.contract_name IS '合同名称';
COMMENT ON COLUMN kyc_contract_signatures.contract_version IS '合同版本号';

COMMENT ON COLUMN kyc_contract_signatures.signature_method IS '签署方式(1:手写签名 2:电子签章 3:生物识别)';
COMMENT ON COLUMN kyc_contract_signatures.signature_time IS '签署时间';
COMMENT ON COLUMN kyc_contract_signatures.signature_file_path IS '签名文件存储路径Base64';
COMMENT ON COLUMN kyc_contract_signatures.signature_file_url IS '签名文件访问URL';
COMMENT ON COLUMN kyc_contract_signatures.contract_file_url IS '合同文件访问URL';

COMMENT ON COLUMN kyc_contract_signatures.start_time IS '合同生效时间';
COMMENT ON COLUMN kyc_contract_signatures.end_time IS '合同结束时间';

COMMENT ON COLUMN kyc_contract_signatures.user_id IS '用户ID';
COMMENT ON COLUMN kyc_contract_signatures.user_name IS '用户姓名';
COMMENT ON COLUMN kyc_contract_signatures.user_phone IS '用户手机号';
COMMENT ON COLUMN kyc_contract_signatures.user_identity IS '用户身份证号';

COMMENT ON COLUMN kyc_contract_signatures.account_id IS 'e签宝账号ID';
COMMENT ON COLUMN kyc_contract_signatures.file_path IS 'e签宝签名文件路径';

COMMENT ON COLUMN kyc_contract_signatures.status IS '状态( 01:待签署 02:已签署 03:已过期 04:已作废)';
COMMENT ON COLUMN kyc_contract_signatures.create_time IS '创建时间';
COMMENT ON COLUMN kyc_contract_signatures.creator_id IS '创建人ID';
COMMENT ON COLUMN kyc_contract_signatures.creator_name IS '创建人姓名';
COMMENT ON COLUMN kyc_contract_signatures.update_time IS '更新时间';
COMMENT ON COLUMN kyc_contract_signatures.updater_id IS '更新人ID';
COMMENT ON COLUMN kyc_contract_signatures.updater_name IS '更新人姓名';




-- 创建车主合同模板表
CREATE TABLE kyc_car_owner_template (
                                        id VARCHAR2(64) NOT NULL,                          -- 主键ID
                                        name VARCHAR2(255) NOT NULL,                       -- 模板名称
                                        code VARCHAR2(64) NOT NULL,                        -- 模板编码
                                        version VARCHAR2(32) NOT NULL,                     -- 版本号
                                        type VARCHAR2(32) NOT NULL,                        -- 类型(TRANSPORT:运输,LEASE:租赁,COOPERATION:合作)
                                        content CLOB,                                      -- 合同内容
                                        file_url VARCHAR2(512),                            -- 文件URL
                                        effective_date TIMESTAMP,                          -- 生效日期
                                        expire_date TIMESTAMP,                             -- 失效日期
                                        is_default NUMBER(1) DEFAULT 0,                    -- 是否默认(0:否,1:是)
                                        status VARCHAR2(32) DEFAULT 'ACTIVE',              -- 状态(ACTIVE:生效,INACTIVE:未生效)
                                        remarks VARCHAR2(512),                             -- 备注
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 创建时间
                                        created_by VARCHAR2(64),                           -- 创建人
                                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 更新时间
                                        updated_by VARCHAR2(64),                           -- 更新人

    -- 主键约束
                                        CONSTRAINT pk_kyc_car_owner_template PRIMARY KEY (id),

    -- 唯一约束
                                        CONSTRAINT uk_code_version UNIQUE (code, version)
);

-- 添加表注释
COMMENT ON TABLE kyc_car_owner_template IS '车主合同模板表';

-- 添加列注释
COMMENT ON COLUMN kyc_car_owner_template.id IS '主键ID';
COMMENT ON COLUMN kyc_car_owner_template.name IS '模板名称';
COMMENT ON COLUMN kyc_car_owner_template.code IS '模板编码';
COMMENT ON COLUMN kyc_car_owner_template.version IS '版本号';
COMMENT ON COLUMN kyc_car_owner_template.type IS '类型(TRANSPORT:运输,LEASE:租赁,COOPERATION:合作)';
COMMENT ON COLUMN kyc_car_owner_template.content IS '合同内容';
COMMENT ON COLUMN kyc_car_owner_template.file_url IS '文件URL';
COMMENT ON COLUMN kyc_car_owner_template.effective_date IS '生效日期';
COMMENT ON COLUMN kyc_car_owner_template.expire_date IS '失效日期';
COMMENT ON COLUMN kyc_car_owner_template.is_default IS '是否默认(0:否,1:是)';
COMMENT ON COLUMN kyc_car_owner_template.status IS '状态(ACTIVE:生效,INACTIVE:未生效)';
COMMENT ON COLUMN kyc_car_owner_template.remarks IS '备注';
COMMENT ON COLUMN kyc_car_owner_template.created_at IS '创建时间';
COMMENT ON COLUMN kyc_car_owner_template.created_by IS '创建人';
COMMENT ON COLUMN kyc_car_owner_template.updated_at IS '更新时间';
COMMENT ON COLUMN kyc_car_owner_template.updated_by IS '更新人';

-- 创建索引
CREATE INDEX idx_type ON kyc_car_owner_template(type);
CREATE INDEX idx_status ON kyc_car_owner_template(status);
CREATE INDEX idx_default ON kyc_car_owner_template(is_default);

-- 防止同一用户重复签署同一合同版本的约束
ALTER TABLE kyc_car_owner_contract
    ADD CONSTRAINT uk_car_owner_contract_user UNIQUE (user_id, contract_id, contract_version);



SELECT
    s.ID,
    s.SPACE_NAME,
    s.TYPE,
    s.PLATFORM,
    s.POSITION,
    s.STATUS,
    s.CREATE_TIME,
    s.CREATOR_ID,
    s.CREATOR_NAME,
    s.UPDATE_TIME,
    s.UPDATER_ID,
    s.UPDATER_NAME,
    c.ID AS adId,
    c.AD_TYPE,
    c.IMAGE_URL,
    c.TEXT_CONTENT,
    c.LINK_TYPE,
    c.LINK_URL,
    c.APPID,
    c.ORIGINAL_ID,
    c.SORT_ORDER,
    sc.ID AS adSpaceId,
    -- 添加位置排序权重字段
    CASE s.POSITION
        WHEN '01' THEN 1  -- 货源列表
        WHEN '02' THEN 2  -- 运单列表
        WHEN '03' THEN 3  -- 油气列表
        WHEN '04' THEN 4  -- 抢单
        WHEN '05' THEN 5  -- 装车
        WHEN '06' THEN 6  -- 卸车
        WHEN '07' THEN 7  -- 提现
        ELSE 8           -- 其他位置
        END AS position_order
FROM
    kyc_ad_space s
        JOIN kyc_ad_space_content sc ON s.id = sc.space_id
        JOIN kyc_ad_content c ON sc.ad_id = c.id
WHERE
        sc.STATUS = '01'
  AND c.STATUS = '01'
    <if test="null!=ew.status and ew.status!=''">
        AND s.STATUS = #{ew.status,jdbcType=VARCHAR}
    </if>
    <if test="null!=ew.platform and ew.platform!=''">
        AND s.PLATFORM = #{ew.platform,jdbcType=VARCHAR}
    </if>
    <if test="null!=ew.position and ew.position!=''">
        AND s.POSITION = #{ew.position,jdbcType=VARCHAR}
    </if>
    <if test="null!=ew.spaceName and ew.spaceName!=''">
        AND REGEXP_LIKE(s.SPACE_NAME, #{ew.spaceName,jdbcType=VARCHAR}, 'i')
    </if>
    <if test="null!=ew.startTime">
        AND s.CREATE_TIME >= TO_DATE(#{ew.startTime,jdbcType=VARCHAR}, 'YYYY-MM-DD HH24:MI:SS')
    </if>
    <if test="null!=ew.endTime">
        AND s.CREATE_TIME <![CDATA[<=]]> TO_DATE(#{ew.endTime,jdbcType=VARCHAR}, 'YYYY-MM-DD HH24:MI:SS')
    </if>
ORDER BY
    position_order ASC,  -- 第一维度：广告位置按指定顺序排序
    c.SORT_ORDER ASC,    -- 第二维度：sortOrder升序
    sc.CREATE_TIME DESC  -- 第三维度：创建时间降序




-- 车主运输合同白名单表


CREATE TABLE kyc_car_owner_whitelist (
                                         id VARCHAR2 ( 64 ) NOT NULL,
                                         user_phone VARCHAR2 ( 64 ) NOT NULL,
                                         status VARCHAR2 ( 64 ) NOT NULL,
                                         create_time DATE NOT NULL,
                                         CONSTRAINT pk_kyc_car_owner_whitelist PRIMARY KEY ( id )

);

COMMENT ON TABLE kyc_car_owner_whitelist IS '车主运输合同白名单表';
COMMENT ON COLUMN kyc_car_owner_whitelist.id IS '主键ID';
COMMENT ON COLUMN kyc_car_owner_whitelist.user_phone IS '用户手机号';
COMMENT ON COLUMN kyc_car_owner_whitelist.status IS '状态：01-启用，02-禁用，99-作废';
COMMENT ON COLUMN kyc_car_owner_whitelist.create_time IS '创建时间';
CREATE INDEX idx_car_owner_whitelist_phone ON kyc_car_owner_whitelist ( user_phone );










