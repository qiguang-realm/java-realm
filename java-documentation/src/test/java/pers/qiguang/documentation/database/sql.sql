-- https://dev.mysql.com/doc/refman/5.7/en/select.html

-- // SQL 必知必会 https://www.nowcoder.com/exam/oj?page=1&tab=SQL%E7%AF%87&topicId=199&fromPut=pc_kol_wenqlgd

-- 【MySQL】官网文档学习之查询语句sql注意事项  https://blog.csdn.net/chenghan_yang/article/details/125233169

-- SQL 教程  https://www.w3school.com.cn/sql/index.asp

-- SQL 代码规范  https://www.lsjlt.com/courses/2.html

-- Mysql如何适当的添加索引介绍

-- SQL开发中为什么要尽量避免使用 IN 和 NOT IN 呢？

-- 数据库优化以及sql语句优化的30种方法

-- SQL优化13连问

-- 要精通 SQL 优化？那就学一学 explain 吧！

-- 为什么 99% 的程序员都做不好 SQL 优化？

-- 为什么你总是做不好 SQL 优化，这篇文章告诉你答案  https://my.oschina.net/jiagoushi/blog/8570219

-- 如何搞定 MySQL 锁（全局锁、表级锁、行级锁）？

-- 【建议收藏】15755 字，讲透 MySQL 性能优化（包含 MySQL 架构、存储引擎、调优工具、SQL、索引、建议等等）  https://my.oschina.net/jiagoushi/blog/5593246

-- sql语句中关于group by，order by 和limit书写的先后顺序

-- MySQL 索引失效跑不出这 8 个场景

-- 教你如何定位不合理的 SQL？并优化之

-- 【非广告】常用 SQL 语句，看这篇就够了  https://my.oschina.net/u/4047016/blog/4724808

-- 设计数据库时是设计表越少越好，还是越多越好？  https://www.oschina.net/question/1181223_174135

-- 在MySQL数据库中，这4种方式可以避免重复的插入数据！

-- Mysql大量插入时如何过滤掉重复数据？  https://blog.csdn.net/weixin_69084736/article/details/125413556?spm=1001.2014.3001.5502


-- MySQL_4 常见函数汇总及演示  https://developer.aliyun.com/article/1246748?spm=a2c6h.12883283.index.139.29964307nwg8gL


-- 1.8w 字的 SQL 优化大全  https://toutiao.io/k/9bmtrfk


-- 提供一个网站，详细说明了mysql解析过程：
--
-- https://www.cnblogs.com/annsshadow/p/5037667.html


-- 如何使用MySQL查询逗号分隔的数据（详细教程）

-- mysql按日、周、月、年分别统计数据

-- mysql两个表如何进行数据统计？


-- 处理坐标距离<200km

SELECT*
FROM (
         SELECT id,
                scenic_spot_name,
                scenic_spot_img,
                scenic_spot_address,
                longitude,
                latitude,
                illustrated_handbook,
                scenic_sort,
                scenic_type,
                STATUS,
                creator,
                create_time,
                (
                    SELECT get_distance('32.758199', '106.998687', LATITUDE, LONGITUDE) / 1000 FROM DUAL) AS distance
         FROM `st_scenic_spot`
         WHERE `status` = '01'
           AND scenic_type = '02') sce
WHERE sce.distance < 200
ORDER BY scenic_sort ASC, distance ASC

-- 处理坐标距离

CREATE
DEFINER=`kyc_cle`@`%` FUNCTION `get_distance`(lat1 DECIMAL(20,10),
lng1 DECIMAL(20,10),
lat2 DECIMAL(20,10),
lng2 DECIMAL(20,10)) RETURNS decimal(20,2)
BEGIN
if
lat1=0 || lng1=0
THEN
RETURN (10000000);
ELSE
RETURN (round(6378.138*2*asin(sqrt(pow(sin((lat1*pi()/180-lat2*pi()/180)/2),2)+cos(lat1*pi()/180)*cos(lat2*pi()/180)*pow(sin((lng1*pi()/180-lng2*pi()/180)/2),2)))*1000));
end IF;
end

--
<if test="ew.latitude != null and '' != ew.latitude and ew.longitude != null and '' != ew.longitude ">
            ,(select get_distance(#{ew.latitude,jdbcType=VARCHAR},#{ew.longitude,jdbcType=VARCHAR},LATITUDE,LONGITUDE) /1000 from dual)
            as distance
        </if>





-- Mysql 三元表达式、MySQL case when、MySQL 导出Excel

SELECT m.NICK_NAME AS '用户昵称', m.MOBILE AS '用户手机号', v.VEHICLE_NUMBER AS '车牌号码', (
    CASE
        d.VEHICLE_TYPE
        WHEN '1' THEN
            '客车一类'
        WHEN '2' THEN
            '客车二类'
        WHEN '3' THEN
            '客车三类'
        WHEN '4' THEN
            '客车四类'
        WHEN '11' THEN
            '货车一类'
        WHEN '12' THEN
            '货车二类'
        WHEN '13' THEN
            '货车三类'
        WHEN '14' THEN
            '货车四类'
        WHEN '15' THEN
            '货车五类'
        WHEN '16' THEN
            '货车六类'
        WHEN '21' THEN
            '一型专项作业车'
        WHEN '22' THEN
            '二型专项作业车'
        WHEN '23' THEN
            '三型专项作业车'
        WHEN '24' THEN
            '四型专项作业车'
        WHEN '25' THEN
            '五型专项作业车'
        WHEN '26' THEN
            '六型专项作业车'
        ELSE '未知'
        END
    ) AS '车辆类型', (
    CASE
        v.LICENSE_PLATE_COLOR
        WHEN '01' THEN
            '黄色（大型货车/大型客车）'
        WHEN '02' THEN
            '蓝色（小型客车/小型货车）'
        WHEN '03' THEN
            '渐变绿色（小型新能源车）'
        WHEN '04' THEN
            '黄绿色（大型新能源车）'
        WHEN '0' THEN
            '蓝色'
        WHEN '1' THEN
            '黄色'
        WHEN '2' THEN
            '黑色'
        WHEN '3' THEN
            '白色'
        WHEN '4' THEN
            '渐变绿色'
        WHEN '5' THEN
            '黄绿双拼色'
        WHEN '6' THEN
            '蓝白渐变色'
        WHEN '7' THEN
            '临时牌照'
        WHEN '9' THEN
            '未确定'
        WHEN '11' THEN
            '绿色'
        WHEN '12' THEN
            '红色'
        ELSE '未知'
        END
    ) AS '车牌颜色', IF
    ( v.vehicle_ownership = '01', '公司', '个人' ) AS '车辆所属', v.corporate_name AS '公司名称', d.MILEAGE AS '里程数', v.CREATE_TIME AS '创建时间'
FROM ST_USER_VEHICLE uv
         LEFT JOIN ST_MEMBER m ON m.ID = uv.USER_ID
         LEFT JOIN ST_VEHICLE v ON v.VEHICLE_ID = uv.VEHICLE_ID
         LEFT JOIN st_vehicle_mileage d ON v.VEHICLE_NUMBER = d.vehicle_number
WHERE uv.`STATUS` = '01'
  AND v.`STATUS` = '01'
  AND m.`STATUS` = '1'
ORDER BY v.CREATE_TIME DESC



SELECT id AS '核销交易ID', user_name AS '会员昵称', user_phone AS '会员手机', license_plate_number AS '车牌号码', coupon_id AS '订单ID', coupon_name AS '券名称', trade_amount AS '消费总金额', coupon_price AS '优惠券金额', actual_payment_amount AS '返现金额', ( CASE trader_type WHEN '01' THEN '停车场' WHEN '02' THEN '充电站' END ) AS '交易类型', create_time AS '创建时间'
FROM st_write_off_trade
WHERE DATE (create_time) = '2024-04-01';
ORDER BY
    create_time DESC


SELECT m.NICK_NAME AS '会员昵称', m.MOBILE AS '会员手机', v.license_plate_number AS '车牌号码',(
    CASE
        v.license_plate_color
        WHEN '0' THEN
            '蓝色'
        WHEN '1' THEN
            '黄色'
        WHEN '2' THEN
            '黑色'
        WHEN '3' THEN
            '白色'
        WHEN '4' THEN
            '渐变绿'
        WHEN '5' THEN
            '黄绿双拼'
        WHEN '6' THEN
            '蓝白渐变色'
        END
    ) AS '车牌颜色',(
    CASE
        v.etc_flag
        WHEN '01' THEN
            '是'
        WHEN '00' THEN
            '否'
        END
    ) AS '是否外省ETC发行', v.obu_number AS 'OBU编号',(
    CASE
        v.isKeyAccount
        WHEN '1' THEN
            '是'
        WHEN '0' THEN
            '否'
        END
    ) AS '是否大客户', v.create_time AS '创建时间'
FROM st_vehicle v
         LEFT JOIN st_user_vehicle uv ON v.id = uv.vehicle_id
         LEFT JOIN st_member m ON m.ID = uv.user_id
WHERE v.`status` = '00'
  AND uv.`status` = '00'
  AND m.`STATUS` = 1
ORDER BY v.create_time DESC



SELECT ID,
       NAME,
       address,
       img,
       LONGITUDE,
       LATITUDE,
       STATUS,
       CREATE_TIME
FROM (
         SELECT ID,
                SERVICE_AREA_NAME    AS NAME,
                ADDRESS              AS address,
                SERVICE_AREA_PICTURE AS img,
                LONGITUDE,
                LATITUDE,
                STATUS,
                CREATE_TIME
         FROM st_service_area sa
         WHERE sa.ID IN (
             SELECT service_area_id
             FROM st_service_area_detail
             WHERE service_info_key = 'ETCservice'
               AND deleted = '01'
             UNION
             SELECT service_area_id
             FROM st_service_area_detail
             WHERE service_info_key = 'ring_city_network'
               AND deleted = '01'
         )
         UNION ALL
         SELECT ID,
                TOLL_STATION_NAME    AS NAME,
                TOLL_STATION_ADDRESS AS address,
                TOLL_STATION_IMG     AS img,
                LONGITUDE,
                LATITUDE,
                STATUS,
                CREATE_TIME
         FROM st_toll_station ts
         WHERE ts.ID IN (
             SELECT toll_station_id
             FROM st_toll_station_detail
             WHERE service_info_key = 'ETCservice'
               AND deleted = '01'
             UNION
             SELECT toll_station_id
             FROM st_toll_station_detail
             WHERE service_info_key = 'ring_city_network'
               AND deleted = '01'
         )
     ) asn
WHERE STATUS = '01'
GROUP BY ID;


SELECT SUM(veh.vehiclesNum) AS vehiclesNum, veh.corporateName, veh.createTime
FROM ((
          SELECT count(DISTINCT tp.vehicleNumber) AS vehiclesNum, tp.corporateName, tp.createTime
          FROM ((
                    SELECT ENTERPRISE_NAME      AS corporateName,
                           LICENSE_PLATE_NUMBER AS vehicleNumber,
                           CREATE_TIME          AS createTime
                    FROM st_promotion_user_management
                    WHERE LICENSE_PLATE_OWNER = '02'
                      AND `STATUS` = 0
                      AND ENTERPRISE_NAME IS NOT NULL)
                UNION ALL
                (
                    SELECT corporate_name AS corporateName, VEHICLE_NUMBER AS vehicleNumber, CREATE_TIME AS createTime
                    FROM st_vehicle
                    WHERE `STATUS` = '01'
                      AND vehicle_ownership = '01'
                      AND corporate_name IS NOT NULL)) tp
          GROUP BY tp.corporateName)
      UNION ALL
      (
          SELECT vehicles_num AS vehiclesNum, enterprise_name AS corporateName, create_time AS createTime
          FROM st_enterprise_vehicle_pseudo_data
          WHERE `STATUS` = '01'
            AND enterprise_name IS NOT NULL
          GROUP BY enterprise_name)) veh
WHERE NOT EXISTS(
        SELECT config_value FROM sys_config WHERE veh.corporateName = sys_config.config_value)
GROUP BY veh.corporateName
ORDER BY vehiclesNum DESC


-- MySQL查看版本
SELECT @@version

select version()
from dual;

-- FOR UPDATE

-- exist & in合理利用

-- MySQL DATE_SUB() 函数

-- MySQL DATE_ADD() 函数

-- MySQL CURDATE() 函数

-- MySQL DATE() 函数  SELECT NOW();

-- MySQL CURRENT_DATE() 函数  SELECT CURRENT_DATE();

-- MySQL NOW() 函数

-- MySQL DATETIME、TIMESTAMP、DATE、TIME、YEAR（日期和时间类型）

-- sql 查询统计数据，获取7天内数据  https://blog.csdn.net/u010267336/article/details/104007980/

-- mysql 统计每一个月的用户数量

-- mysql查询最近三天的数据

-- mysql 查询当天数据  https://blog.51cto.com/u_16213329/7130933

-- JAVA通过Map拼接SQL语句Insert Update语句  https://www.itxm.cn/post/26213.html  https://tool.4xseo.com/a/7697.html

-- SQLUtil:简单易用的sql语句拼接工具  https://github.com/huheman/SQLUtil/tree/master

-- SQL拼接工具包，支持Oracle/PostgreSQL/MySql

-- Java工具类拼接SQL；MessageFormat.format拼接SQL；  https://blog.csdn.net/HenryMrZ/article/details/88921665

-- Java拼接SQL语句工具类  使用 Mybatis自带SQL语句构造器拼接  https://mybatis.org/mybatis-3/zh/statement-builders.html

-- https://stackoverflow.com/questions/tagged/sql


-- MySQL拼接字符串，GROUP_CONCAT 值得拥有

-- 如何充分发挥 SQL 能力？  https://my.oschina.net/yunqi/blog/10139796


-- Mysql数据库的decimal类型 对应Java类型为 java.math.BigDecimal
-- JAVA与DM数据库类型的映射关系

-- MySQL中的LOCATE函数


SELECT *
FROM `st_city_weather`
where id like '61%'

DELETE
FROM `st_city_weather`
where id not like '61%'

DELETE
FROM `st_city_weather_record`
WHERE create_time <= '2023-08-27 02:30:10'

-- UPDATE

UPDATE st_toll_station
SET update_time    = NULL,
    operation_type = NULL
WHERE update_time is not null
  and operation_type = '02'

UPDATE 表名称
SET 列名称 = 新值
WHERE 列名称 = 某值

UPDATE st_toll_station
SET activity_data_source = NULL,
    activity_name        = NULL
WHERE ID = ' STA20230225114902327412152658468'

UPDATE st_vehicle
SET etc_card_number_failure = null
WHERE id in (
             'veh20240527164749771728288486368',
             'veh20240527165304047175505145723',
             'veh20240527221536508553236234503'
    );

-- 动态查询

<if test="null != condition and '' != condition ">
            AND CONCAT(pro.MINING_NAME,pro.COAL_NAME,pro.PLACE_ORIGIN,pro.CONTACTS_NAME) like
            CONCAT(CONCAT('%',#{condition,jdbcType=VARCHAR}),'%')
        </if>

        <if test="null != ew.nickName and '' != ew.nickName ">
            AND m.NICK_NAME like CONCAT(CONCAT('%',#{ew.nickName,jdbcType=VARCHAR}),'%')
        </if>

        <if test="null != ew.userId and '' != ew.userId ">
            AND uv.user_id = #{userId,jdbcType=VARCHAR}
        </if>

        <if test="null != ew.licensePlateNumber and '' != ew.licensePlateNumber ">
            AND v.license_plate_number = #{ew.licensePlateNumber,jdbcType=VARCHAR}
        </if>

        <if test="null != ew.startTime and '' != ew.startTime and 'null' != ew.startTime ">
            AND v.create_time &gt;
=#{ew.startTime}
        </if>

        <if test="null != ew.endTime and '' != ew.endTime and 'null' != ew.endTime ">
            AND v.create_time &lt;
=#{ew.endTime}
        </if>

        <if test="eventType == '01'">
            AND type_id IN ( '102', '104', '105', '110', '107', '108', '109', '111', '113', '114', '115' )
        </if>
        <if test="eventType == '02'">
            AND type_id IN ( '103', '106', '112' )
        </if>
        <if test="eventType == '03'">
            AND type_id = '101'
        </if>
        <if test="eventType == '04'">
            AND type_id IS NOT NULL
        </if>
        <if test="keywords != null and keywords != ''">
            AND CONCAT(type_name,road_name,event_desc) like
            CONCAT(CONCAT('%',#{keywords,jdbcType=VARCHAR}),'%')
        </if>
        <if test="startTime!=null and startTime!='' and startTime!='null' ">
            AND happen_time &gt;
=#{startTime}
        </if>
        <if test="endTime!=null and endTime!='' and endTime!='null' ">
            AND happen_time &lt;
=#{endTime}
        </if>

 <if test="ew.dataSources != null and ew.dataSources != '' and ew.dataSources == '01'">
            AND data_sources = #{ew.dataSources}
        </if>
        <if test="ew.dataSources != null and ew.dataSources != '' and ew.dataSources == '02'">
            AND data_sources is null
        </if>

-- ----------------------------
-- Table structure for pay_refund
-- ----------------------------
DROP TABLE IF EXISTS `pay_refund`;
CREATE TABLE `pay_refund`
(
    `id`                 bigint                                                         NOT NULL AUTO_INCREMENT COMMENT '支付退款编号',
    `merchant_id`        bigint                                                         NOT NULL COMMENT '商户编号',
    `app_id`             bigint                                                         NOT NULL COMMENT '应用编号',
    `channel_id`         bigint                                                         NOT NULL COMMENT '渠道编号',
    `channel_code`       varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT '渠道编码',
    `order_id`           bigint                                                         NOT NULL COMMENT '支付订单编号 pay_order 表id',
    `trade_no`           varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT '交易订单号 pay_extension 表no 字段',
    `merchant_order_id`  varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT '商户订单编号（商户系统生成）',
    `merchant_refund_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT '商户退款订单号（商户系统生成）',
    `notify_url`         varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '异步通知商户地址',
    `notify_status`      tinyint                                                        NOT NULL COMMENT '通知商户退款结果的回调状态',
    `status`             tinyint                                                        NOT NULL COMMENT '退款状态',
    `type`               tinyint                                                        NOT NULL COMMENT '退款类型(部分退款，全部退款)',
    `pay_amount`         bigint                                                         NOT NULL COMMENT '支付金额,单位分',
    `refund_amount`      bigint                                                         NOT NULL COMMENT '退款金额,单位分',
    `reason`             varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '退款原因',
    `user_ip`            varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户 IP',
    `channel_order_no`   varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT '渠道订单号，pay_order 中的channel_order_no 对应',
    `channel_refund_no`  varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '渠道退款单号，渠道返回',
    `channel_error_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '渠道调用报错时，错误码',
    `channel_error_msg`  varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '渠道调用报错时，错误信息',
    `channel_extras`     varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付渠道的额外参数',
    `expire_time`        datetime NULL DEFAULT NULL COMMENT '退款失效时间',
    `success_time`       datetime NULL DEFAULT NULL COMMENT '退款成功时间',
    `notify_time`        datetime NULL DEFAULT NULL COMMENT '退款通知时间',
    `creator`            varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`        datetime                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`            varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`        datetime                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`            bit(1)                                                         NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`          bigint                                                         NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款订单';



-- ----------------------------
-- Table structure for st_vehicle_appeal
-- ----------------------------
DROP TABLE IF EXISTS `st_vehicle_appeal`;
CREATE TABLE `st_vehicle_appeal`
(
    `id`                      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '唯一标识符ID',
    `plate_no`    VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号码',
    `license_plate_color`     VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车牌颜色',
    `vehicle_type`            VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车辆类型',
    `vehicle_owner_name`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车辆所属者姓名',
    `vehicle_owner_phone`     VARCHAR(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车辆所属者手机号（ETC办理预留手机号）',
    `id_card_homepage`        VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证主页',
    `id_card_subpage`         VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证副页',
    `driving_permit_homepage` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行驶证主页',
    `driving_permit_subpage`  VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行驶证副页',
    `description`             VARCHAR(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '申诉描述',
    `auditor`                 VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核人',
    `audit_opinions`          VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核意见',
    `audit_time`              VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核时间',
    `audit_status`            VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核状态',
    `remark`                  VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    `status`                  VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（00，正常 01，停用）',
    `creator`                 VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`             datetime                                                      NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '车辆申诉表';

-- ----------------------------
-- Table structure for st_road_condition_correction
-- ----------------------------
DROP TABLE IF EXISTS `st_road_condition_correction`;
CREATE TABLE `st_road_condition_correction`
(
    `id`                          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `toll_station_id`             VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收费站ID',
    `toll_station_name`           VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收费站名称',
    `original_operational_status` VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '原收费站运营状态：01 正常 02 关闭 03 入口关闭、出口正常 04 入口正常、出口关闭 05 管制',
    `location`                    VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '当前定位',
    `longitude`                   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '经度',
    `latitude`                    VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纬度',
    `submit_operational_status`   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提交运营状态：01 正常 02 关闭 03 入口关闭、出口正常 04 入口正常、出口关闭 05 管制',
    `image_url`                   VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '现场图片链接地址',
    `description`                 VARCHAR(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详情描述',
    `user_id`                     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户ID',
    `user_phone`                  VARCHAR(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户手机号',
    `auditor`                     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核人',
    `audit_opinions`              VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核意见',
    `audit_status`                VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核状态：01待审核，02同意，03拒绝，99作废',
    `audit_time`                  datetime NULL DEFAULT NULL COMMENT '审核时间',
    `status`                      VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`                     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者/提交人姓名',
    `create_time`                 datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER
SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '路况纠错申请表';


-- ----------------------------
-- Table structure for st_vehicle_unbind_record
-- ----------------------------
DROP TABLE IF EXISTS `st_vehicle_unbind_record`;
CREATE TABLE `st_vehicle_unbind_record`
(
    `id`                   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `user_id`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户ID',
    `user_name`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户姓名',
    `user_phone`           VARCHAR(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户手机号码',
    `ordinary_points`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '普通积分',
    `activity_points`      VARCHAR(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '活动积分',
    `license_plate_number` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车牌号码',
    `activity_id`          VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '当前活动ID',
    `status`               VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（00，正常 01，停用）',
    `creator`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`          datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER
SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '车辆解绑记录表';


-- ----------------------------
-- Table structure for st_user_vehicle
-- ----------------------------
DROP TABLE IF EXISTS `st_user_vehicle`;
CREATE TABLE `st_user_vehicle`
(
    `id`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `user_id`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户ID',
    `vehicle_id`  VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车辆ID',
    `status`      VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（00，正常 01，停用）',
    `creator`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time` datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户车辆表';


-- ----------------------------
-- Table structure for st_vehicle
-- ----------------------------
DROP TABLE IF EXISTS `st_vehicle`;
CREATE TABLE `st_vehicle`
(
    `id`                      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '主键ID',
    `license_plate_number`    VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号码',
    `license_plate_color`     VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车牌颜色',
    `vehicle_type`            VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车辆类型',
    `vehicle_owner_name`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车辆所属者姓名',
    `vehicle_owner_phone`     VARCHAR(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车辆所属者手机号（ETC办理预留手机号）',
    `driving_permit_homepage` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行驶证主页',
    `driving_permit_subpage`  VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行驶证副页',
    `channel`                 VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '渠道：00， pc 01， ios 02， android 03， applet',
    `status`                  VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（00，正常 01，停用）',
    `creator`                 VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`             datetime                                                      NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER
SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '车辆表';


-- ----------------------------
-- Table structure for st_parking_lot
-- ----------------------------
DROP TABLE IF EXISTS `st_parking_lot`;
CREATE TABLE `st_parking_lot`
(
    `id`                    VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '主键ID',
    `parking_lot_id`        VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '停车场ID',
    `name`                  VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '停车场名称',
    `license_plate_number`  VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号码',
    `license_plate_color`   VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '识别车牌颜色(车牌颜色2位数字:0-蓝色，1-黄色，2-黑色，3-白色，4-渐变绿色5-黄绿双拼色6-蓝白渐变色7-临时车牌9-未确定11-绿色12-红色)',
    `pay_type`              VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT
        '支付方式（-1-未支付，2-ETC支付,3-聚合支付,4-微信,5-支付宝,6-现金支付 7-免费车辆 8-白名单 9-年卡 10-月卡 11-黑名单 12-包时车 16-记账车 26-报备车）',
    `fee`                   VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '费用（分）',
    `parking_record_number` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '停车流水编号',
    `out_time`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出场时间',
    `status`                VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（00，正常 01，停用）',
    `creator`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`           datetime                                                      NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER
SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'etc停车场交易表';

-- ----------------------------
-- Table structure for st_charge_station
-- ----------------------------
DROP TABLE IF EXISTS `st_charge_station`;
CREATE TABLE `st_charge_station`
(
    `id`                 VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `station_id`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '充电站唯一ID',
    `station_name`       VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '充电站名称',
    `address`            VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '充电站地址',
    `station_lng`        VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '充电站坐标经度',
    `station_lat`        VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '充电站坐标纬度',
    `support_order`      VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否支持预约（0-不支持、1-支持）',
    `status`             VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`        datetime                                                     NOT NULL COMMENT '创建时间',
    `type`               VARCHAR(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型：01 内部； 02 外部',
    `operational_status` VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运营状态： 01 运营中； 02 待开业',
    `image_url`          VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片链接地址',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '充电站信息表';


-- ----------------------------
-- Table structure for st_charge_station_consume
-- ----------------------------
DROP TABLE IF EXISTS `st_charge_station_consume`;
CREATE TABLE `st_charge_station_consume`
(
    `id`                   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `license_plate_number` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号码',
    `license_plate_color`  VARCHAR(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车牌颜色（1-绿色；2-蓝色）',
    `station_name`         VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '消费站点（充电站名称）',
    `order_amount`         VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '消费金额',
    `charge_time`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '消费时间',
    `status`               VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`          datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER
SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '充电站消费记录表';


-- ----------------------------
-- Table structure for st_bank_branches
-- ----------------------------
DROP TABLE IF EXISTS `st_bank_branches`;
CREATE TABLE `st_bank_branches`
(
    `id`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `name`        VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分行名称',
    `bank_name`   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '银行网点名称',
    `address`     VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网点地址',
    `tel`         VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号码',

    `status`      VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time` datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER
SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'ETC办理网点表';

-- ----------------------------
-- Table structure for st_supermarket
-- ----------------------------
DROP TABLE IF EXISTS `st_supermarket`;
CREATE TABLE `st_supermarket`
(
    `id`                 VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `name`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
    `address`            VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
    `longitude`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '经度',
    `latitude`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纬度',
    `operational_status` VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运营状态',
    `picture`            VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
    `status`             VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`        datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商超表';

-- ----------------------------
-- Table structure for st_travel_stops
-- ----------------------------
DROP TABLE IF EXISTS `st_travel_stops`;
CREATE TABLE `st_travel_stops`
(
    `id`                 VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `name`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
    `type`               VARCHAR(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '类型：01 收费站； 02 服务区',
    `address`            VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
    `longitude`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '经度',
    `latitude`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纬度',
    `operational_status` VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运营状态： 01 运营中； 02 待开业',
    `picture`            VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
    `status`             VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`        datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '出行服务站点表';

-- ----------------------------
-- Table structure for st_service_area
-- ----------------------------
DROP TABLE IF EXISTS `st_service_area`;
CREATE TABLE `st_service_area`
(
    `id`                 VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `name`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
    `type`               VARCHAR(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型：01 收费站； 02 服务区; 03 司机之家',
    `address`            VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
    `longitude`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '经度',
    `latitude`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纬度',
    `operational_status` VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运营状态： 01 运营中； 02 待开业',
    `picture`            VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
    `status`             VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`        datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '服务区信息表';


-- ----------------------------
-- Table structure for st_driver_home
-- ----------------------------
DROP TABLE IF EXISTS `st_driver_home`;
CREATE TABLE `st_driver_home`
(
    `id`                 VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `name`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
    `type`               VARCHAR(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型：01 收费站； 02 服务区; 03 司机之家',
    `address`            VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
    `longitude`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '经度',
    `latitude`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纬度',
    `operational_status` VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '运营状态： 01 运营中； 02 待开业',
    `picture`            VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
    `status`             VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`        datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '司机之家信息表';


-- ----------------------------
-- Table structure for st_cancel_order
-- ----------------------------
DROP TABLE IF EXISTS `st_cancel_order`;
CREATE TABLE `st_cancel_order`
(
    `id`                    VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单ID',

    `trade_id`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '交易ID',
    `trade_name`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '交易名称',
    `trader_type`           VARCHAR(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '交易类型：01 停车场； 02 充电站',
    `license_plate_number`  VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号码',
    `fee`                   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '费用（元）',


    `product_id`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品ID',
    `product_name`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称',
    `product_price`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品价格',
    `product_type`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品类型： 01 虚拟； 02 实物',
    `product_validity_type` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品有效期类型',
    `product_validity`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品有效期',


    `coupon_id`             VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '券ID（原商品订单id）',
    `coupon_name`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '券名称',
    `coupon_price`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '券价格',
    `coupon_status`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '券状态: 01 待支付 02 已支付 03 待发货 04 待收货  05 待核销 06 已取消  07 已失效 08 已完成',
    `coupon_validity`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '券有效期',


    `user_id`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户ID',
    `user_name`             VARCHAR(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '用户姓名',
    `user_phone`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户手机号',
    `user_open_id`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户手机号',


    `status`                VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`           datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER
SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单核销表';


-- ----------------------------
-- Table structure for st_write_off_trade
-- ----------------------------
DROP TABLE IF EXISTS `st_write_off_trade`;
CREATE TABLE `st_write_off_trade`
(
    `id`                    VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消费核销交易ID',
    `trade_name`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '交易名称',
    `trader_type`           VARCHAR(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '交易类型：01 停车场； 02 充电站',
    `license_plate_number`  VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号码',
    `trade_amount`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '交易金额',
    `coupon_id`             VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '券ID（原商品订单id）',
    `coupon_name`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '券名称',
    `coupon_price`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '券价格',
    `user_id`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户ID',
    `user_name`             VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户姓名',
    `user_phone`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户手机号',
    `user_open_id`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户openid',
    `actual_payment_amount` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '实际支付金额',
    `status`                VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`           datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消费核销交易表';

-- ----------------------------
-- Table structure for st_pay_order
-- ----------------------------
DROP TABLE IF EXISTS `st_pay_order`;
CREATE TABLE `st_pay_order`
(
    `id`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '支付订单ID',
    `order_id`    VARCHAR(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单ID',


    `status`      VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time` datetime                                                       NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER
SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '支付订单表';

-- ----------------------------
-- Table structure for st_batch_transfer_order
-- ----------------------------
DROP TABLE IF EXISTS `st_batch_transfer_order`;
CREATE TABLE `st_batch_transfer_order`
(
    `id`                VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ID',
    `mchid`             VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户号',
    `out_batch_no`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商家批次单号',
    `batch_id`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '微信批次单号',
    `batch_status`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次状态',
    `appid`             VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户appid',
    `batch_name`        VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次名称',
    `batch_remark`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次备注',
    `total_amount`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '转账总金额',
    `total_num`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '转账总笔数',
    `close_reason`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次关闭原因',
    `transfer_scene_id` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '转账场景ID',
    `status`            VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`       datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER
SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家转账到零钱表';



-- ----------------------------
-- Table structure for st_transfer_detail_order
-- ----------------------------
DROP TABLE IF EXISTS `st_transfer_detail_order`;
CREATE TABLE `st_transfer_detail_order`
(
    `id`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ID',
    `mchid`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户号',
    `out_batch_no`    VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商家批次单号',
    `appid`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户appid',
    `out_detail_no`   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商家明细单号',
    `detail_id`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '微信明细单号',
    `detail_status`   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '明细状态',
    `transfer_amount` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '转账金额',
    `transfer_remark` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '转账备注',
    `openid`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收款用户openid',
    `user_name`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收款用户姓名',
    `fail_reason`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '明细失败原因',
    `status`          VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`     datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家转账到零钱明细表';


-- ----------------------------
-- Table structure for st_pay_trade
-- ----------------------------
DROP TABLE IF EXISTS `st_pay_trade`;
CREATE TABLE `st_pay_trade`
(
    `id`                 VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ID',
    `write_off_trade_id` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消费核销交易ID',
    `mchid`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户号',
    `out_batch_no`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商家批次单号',
    `batch_id`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '微信批次单号',
    `batch_status`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次状态',
    `appid`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户appid',
    `batch_name`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次名称',
    `batch_remark`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次备注',
    `total_amount`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '转账总金额',
    `total_num`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '转账总笔数',
    `close_reason`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次关闭原因',
    `transfer_scene_id`  VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '转账场景ID',
    `status`             VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`        datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '核销支付交易表';

-- ----------------------------
-- Table structure for st_pay_trade_detail
-- ----------------------------
DROP TABLE IF EXISTS `st_pay_trade_detail`;
CREATE TABLE `st_pay_trade_detail`
(
    `id`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ID',
    `mchid`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户号',
    `out_batch_no`    VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商家批次单号',
    `appid`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户appid',
    `out_detail_no`   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商家明细单号',
    `detail_id`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '微信明细单号',
    `detail_status`   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '明细状态',
    `transfer_amount` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '转账金额',
    `transfer_remark` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '转账备注',
    `openid`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收款用户openid',
    `user_name`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收款用户姓名',
    `fail_reason`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '明细失败原因',
    `status`          VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`     datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '核销支付交易明细表';

-- ----------------------------
-- Table structure for st_vehicle_bind_counter
-- ----------------------------
DROP TABLE IF EXISTS `st_vehicle_bind_counter`;
CREATE TABLE `st_vehicle_bind_counter`
(
    `id`                   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `license_plate_number` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号码',
    `counter`              INT ( 11 ) NOT NULL COMMENT '计数器',
    `status`               VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `create_time`          datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '车辆绑定计数表';

-- ----------------------------
-- Table structure for st_sms_verification_code
-- ----------------------------
DROP TABLE IF EXISTS `st_sms_verification_code`;
CREATE TABLE `st_sms_verification_code`
(
    `id`                VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `phone_number`      VARCHAR(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号',
    `verification_code` VARCHAR(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '验证码',
    `status`            VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 99，作废）',
    `create_time`       datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '短信验证码记录表';

-- ----------------------------
-- Table structure for st_etc_consumption_statistics
-- ----------------------------
DROP TABLE IF EXISTS `st_etc_consumption_statistics`;
CREATE TABLE `st_etc_consumption_statistics`
(
    `id`                       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `license_plate_number`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号码',
    `license_plate_color`      VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '车牌颜色',
    `electronic_tag`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '电子标签',
    `total_consumption_amount` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消费总金额',
    `status`                   VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 99，作废）',
    `create_time`              datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE,
    KEY                        `license_plate_number_index` (`license_plate_number`)
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'ETC消费数据统计信息表';

-- ----------------------------
-- Table structure for st_etc_consumption_statistics
-- ----------------------------
DROP TABLE IF EXISTS `st_etc_consumption_statistics`;
CREATE TABLE `st_etc_consumption_statistics`
(
    `license_plate_number`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号码',
    `license_plate_color`      VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '车牌颜色',
    `electronic_tag`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '电子标签',
    `total_consumption_amount` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消费总金额',
    PRIMARY KEY (`license_plate_number`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'ETC消费数据统计信息表';

-- ----------------------------
-- Table structure for st_cdk_codes
-- ----------------------------
DROP TABLE IF EXISTS `st_cdk_codes`;
CREATE TABLE `st_cdk_codes`
(
    `id`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '兑换码的唯一标识符',
    `name`             VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
    `code`             VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '兑换码',
    `type`             VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '类型： 01 长期有效； 02 限时有效',
    `total_count`      INT ( 11 ) NOT NULL COMMENT '总数量',
    `assign_count`     INT ( 11 ) NOT NULL COMMENT '已领取数量',
    `used_count`       INT ( 11 ) NOT NULL COMMENT '已使用数量',
    `received_at`      datetime                                                      NOT NULL COMMENT '领取时间',
    `used_at`          datetime                                                      NOT NULL COMMENT '使用时间',
    `valid_type`       VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '有效期类型： 01 固定有效期； 02 浮动有效期',
    `valid_start_time` datetime                                                      NOT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime                                                      NOT NULL COMMENT '有效期结束时间',
    `valid_period`     INT ( 11 ) NOT NULL COMMENT '浮动有效期（单位：天）',
    `code_status`      VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '兑换码状态: 01 未使用； 02 已使用； 03 已过期',
    `user_id`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '用户ID',
    `user_name`        VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '用户名称',
    `user_phone`       VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '用户手机号',
    `status`           VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`      datetime                                                      NOT NULL COMMENT '创建时间',
    `updater`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新者',
    `update_time`      datetime                                                      NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'cdk兑换码信息表';


-- ----------------------------
-- Table structure for st_cdk_codes
-- ----------------------------
DROP TABLE IF EXISTS `st_cdk_codes`;
CREATE TABLE `st_cdk_codes`
(
    `id`                    VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '兑换码的唯一标识符',
    `batch_id`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '批次单号',
    `wx_url`                VARCHAR(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '微信跳转小程序地址',
    `receive_time`          datetime                                                       NOT NULL COMMENT '领取时间',
    `points_before_receive` VARCHAR(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '领取前已消耗积分',
    `rights_expire_time`    datetime                                                       NOT NULL COMMENT '权益到期时间',
    `cancel_time`           datetime                                                       NOT NULL COMMENT '作废时间',
    `member_valid_type`     VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci    NOT NULL COMMENT '超级会员有效期类型： 01 长期有效； 02 限时有效',
    `member_expire_time`    datetime                                                       NOT NULL COMMENT '超级会员到期时间',
    `valid_start_time`      datetime                                                       NOT NULL COMMENT '兑换码有效期开始时间',
    `valid_end_time`        datetime                                                       NOT NULL COMMENT '兑换码有效期结束时间',
    `status`                VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '兑换码状态: 01 未使用； 02 已使用； 03 权益到期； 99 作废',
    `user_id`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '用户ID',
    `user_name`             VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '用户名称',
    `user_phone`            VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '用户手机号',
    `license_plate_number`  VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '车牌号码',
    `remark`                VARCHAR(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '备注',
    `creator`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`           datetime                                                       NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'cdk兑换码信息表';


-- ----------------------------
-- Table structure for st_oil_coupon
-- ----------------------------
DROP TABLE IF EXISTS `st_oil_coupon`;
CREATE TABLE `st_oil_coupon`
(
    `id`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '唯一标识符ID',
    `batch_id`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '批次单号',
    `order_id`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单ID',
    `code`             VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '券码',
    `amount`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优惠券的面值，表示优惠券可以抵扣的金额。',
    `valid_start_time` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优惠券有效期开始时间',
    `valid_end_time`   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优惠券有效期结束时间',
    `status`           VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '优惠券状态: 01 未使用； 02 已使用； 03 已过期； 99 作废',
    `issued_time`      datetime                                                     NOT NULL COMMENT '发行时间',
    `used_time`        datetime                                                     NOT NULL COMMENT '使用时间',
    `user_id`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户ID',
    `user_name`        VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名称',
    `user_phone`       VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户手机号',
    `remark`           VARCHAR(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    `creator`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`      datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '佳好佳加油券信息表';


-- ----------------------------
-- Table structure for st_integral_treasure_config
-- ----------------------------
DROP TABLE IF EXISTS `st_integral_treasure_config`;
CREATE TABLE `st_integral_treasure_config`
(
    `id`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID，唯一标识一条记录。',
    `activity_id`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '活动ID，用于记录积分夺宝活动的ID。',
    `activity_name`    VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '活动名称，用于记录积分夺宝活动的名称。',
    `prize_id`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '奖品ID，表示积分夺宝的奖品。',
    `prize_name`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '奖品名称，表示积分夺宝的奖品名称。',
    `prize_type`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '奖品类型，表示该奖品的类型。',
    `prize_image`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '奖品图片，表示该奖品的图片。',
    `winner_user_id`   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中奖用户ID，表示该期数的中奖用户。',
    `winner_user_name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中奖用户名称，表示该期数的中奖用户名称。',
    `period_id`        VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '期数ID，表示该奖品属于哪个期数。',
    `draw_num`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开奖券数，表示该期数需要多少张开奖券才能开奖。',
    `points`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '积分，表示兑换该奖品所需的积分。',
    `start_time`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '活动开始时间，表示该期数的活动开始时间。',
    `end_time`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '活动结束时间，表示该期数的活动结束时间。',
    `draw_status`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开奖状态（01：未开奖，02：已开奖）',
    `prize_status`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '奖品状态（01：启用，02：禁用）',
    `draw_time`        datetime NULL DEFAULT NULL COMMENT '开奖时间，表示该期数的开奖时间。',
    `status`           VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 99，作废）',
    `creator`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`      datetime                                                     NOT NULL COMMENT '创建时间，表示该奖品加入积分夺宝的时间。',
    `updater`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '更新者',
    `update_time`      datetime NULL DEFAULT NULL COMMENT '更新时间，表示该奖品信息的更新时间。',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '积分夺宝配置信息表';


-- ----------------------------
-- Table structure for st_integral_treasure_record
-- ----------------------------
DROP TABLE IF EXISTS `st_integral_treasure_record`;
CREATE TABLE `st_integral_treasure_record`
(
    `id`               VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `order_id`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单ID',
    `activity_id`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '活动ID，用于记录积分夺宝活动的ID。',
    `activity_name`    VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '活动名称，用于记录积分夺宝活动的名称。',
    `user_id`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户ID，表示参与积分夺宝的用户。',
    `user_name`        VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名称，表示参与积分夺宝的用户名称。',
    `user_phone`       VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户手机号，表示参与积分夺宝的用户手机号。',
    `winner_user_id`   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中奖用户ID，表示该期数的中奖用户。',
    `winner_user_name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中奖用户名称，表示该期数的中奖用户名称。',
    `prize_id`         VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '奖品ID，表示用户参与的奖品。',
    `prize_name`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '奖品名称，表示用户参与的奖品名称。',
    `prize_type`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '奖品类型，表示该奖品的类型。',
    `period_id`        VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '期数ID，表示用户参与的期数。',
    `points`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '积分，表示用户消耗的积分。',
    `winner_status`    VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中奖状态（01，已中奖 02，未中奖）',
    `status`           VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 99，作废）',
    `creator`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`      datetime                                                     NOT NULL COMMENT '创建时间，表示用户参与积分夺宝的时间。',
    `updater`          VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '更新者',
    `update_time`      datetime NULL DEFAULT NULL COMMENT '更新时间，表示用户积分夺宝状态的更新时间。',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '积分夺宝用户抽奖记录信息表';


-- ----------------------------
-- Table structure for st_wan_yue_equity
-- ----------------------------
DROP TABLE IF EXISTS `st_wan_yue_equity`;
CREATE TABLE `st_wan_yue_equity`
(
    `id`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '主键ID',
    `user_id`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '用户ID',
    `user_name`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '用户姓名',
    `user_phone`    VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '用户手机号',
    `order_id`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '订单ID',
    `platform_code` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '平台渠道码',
    `jump_url`      VARCHAR(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权益使用url',
    `is_use`        VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权益使用状态: false 未使用； true 已使用',
    `grant_status`  VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权益发放状态: false 未发放； true 已发放',
    `status`        VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 00，停用）',
    `creator`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`   datetime                                                       NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '万悦权益下单信息表';



-- ----------------------------
-- MySQL 详细设计关于抽奖模块的所有数据库表
-- ----------------------------

-- ----------------------------
-- Table structure for st_participant_roster
-- ----------------------------
DROP TABLE IF EXISTS `st_participant_roster`;
CREATE TABLE `st_participant_roster`
(
    `id`          bigint                                                       NOT NULL AUTO_INCREMENT COMMENT '编号',
    `mobile`      varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号',
    `type`        VARCHAR(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '类型：01 集团领导； 02 非集团领导',
    `status`      VARCHAR(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 99，作废）',
    `create_time` datetime                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uk_mobile`(`mobile` ASC) USING BTREE COMMENT '手机号'
) ENGINE = InnoDB AUTO_INCREMENT = 248 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '抽奖参与者名册';

-- ----------------------------
-- Table structure for st_lottery_records
-- ----------------------------
DROP TABLE IF EXISTS `st_lottery_records`;
CREATE TABLE `st_lottery_records`
(
    `id`            bigint   NOT NULL AUTO_INCREMENT COMMENT '编号',
    `member_id`     VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '会员ID',
    `nickname`      VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '会员昵称',
    `mobile`        VARCHAR(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '会员手机号',
    `winner_status` VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '中奖状态（01，已中奖 02，未中奖）',
    `winner_time`   datetime NOT NULL COMMENT '中奖时间',
    `status`        VARCHAR(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 99，作废）',
    `creator`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`   datetime NOT NULL COMMENT '创建时间/抽奖时间',
    `updater`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '更新者',
    `update_time`   datetime NULL DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '抽奖记录表';

-- ----------------------------
-- Table structure for st_reward_record
-- ----------------------------
DROP TABLE
    IF
    EXISTS `st_reward_record`;
CREATE TABLE `st_reward_record`
(
    `id`          VARCHAR(64) CHARACTER
        SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
    `order_id`    VARCHAR(64) CHARACTER
        SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单ID',
    `activity_id` VARCHAR(64) CHARACTER
        SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '活动ID',
    `user_id`     VARCHAR(64) CHARACTER
        SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户ID',
    `type`        VARCHAR(4) CHARACTER
        SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型：01 优先打卡完成30个收费站的会员奖励大礼包',
    `status`      VARCHAR(2) CHARACTER
        SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态：01，正常 99，作废',
    `creator`     VARCHAR(64) CHARACTER
        SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time` datetime                     NOT NULL COMMENT '创建时间',

) ENGINE = INNODB DEFAULT CHARACTER
SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '奖励记录表';



-- ----------------------------
-- Table structure for st_lane
-- ----------------------------

DROP TABLE IF EXISTS `st_lane`;
CREATE TABLE `st_lane`
(
    `id`                   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '唯一标识符ID',
    `lane_id`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '车道ID',
    `license_plate_number` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号',
    `exit_vehicle_type`    VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出口车型',
    `final_trade_amount`   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最终交易金额',
    `pay_type`             VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付方式',
    `exit_time`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出口时间',
    `original_file_name`   VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件的原始名称',
    `status`               VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 99，作废）',
    `creator`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `create_time`          datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '车道信息表';



-- ----------------------------
-- Table structure for st_rack
-- ----------------------------

DROP TABLE IF EXISTS `st_rack`;
CREATE TABLE `st_rack`
(
    `id`                   VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '唯一标识符ID',
    `pass_id`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '门架ID',
    `license_plate_number` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '车牌号',
    `billing_vehicle_type` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '计费车型',
    `billing_amount`       VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '计费金额',
    `rack_code`            VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '门架编号',
    `trade_time`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易时间',
    `original_file_name`   VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件的原始名称',
    `status`               VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 99，作废）',
    `creator`              VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `create_time`          datetime                                                     NOT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '门架信息表';

ALTER TABLE st_lane
    ADD INDEX index_lane_id (lane_id);

ALTER TABLE st_lane
    ADD INDEX index_license_plate_number (license_plate_number);

ALTER TABLE st_lane
    ADD INDEX index_exit_time (exit_time);

-- 创建唯一索引
CREATE UNIQUE INDEX unique_index ON st_lane (license_plate_number, exit_time);

ALTER TABLE st_rack
    ADD INDEX index_license_plate_number (license_plate_number);

ALTER TABLE st_rack
    ADD INDEX index_trade_time (trade_time);

ALTER TABLE st_rack
    ADD INDEX index_status (status);

-- 创建唯一索引
CREATE UNIQUE INDEX unique_index ON st_rack (license_plate_number, billing_amount, trade_time);


-- MySQL商城数据库88张表结构（51—60）  https://blog.csdn.net/2302_81239365/article/details/138277554


-- // 1.8w 字详解 SQL 优化  https://mp.weixin.qq.com/s/t4DamFNh10RRJOdEH3hWYg

-- Mysql的常用函数  https://mp.weixin.qq.com/s/7Jk5g3Ekst5OBnfqs0j-rQ


-- lane_type: 车道的类型，使用枚举类型表示，可以是'entry'（入口）、'exit'（出口）、'normal'（普通车


import -- 导入

export -- 导出

`amount` decimal(10,2) NOT NULL,


check Distance Requirement  检查距离要求

get Station Distance  获取站点距离

notify  通知

insert 插入

checkFields  校验 Field

validateFormExists  校验表单存在

verifyCode 校验验证码


popular_hotel_display  热门酒店展示

标签 label

subtitle 副标题

首页展示  Home page display

二维码  QR code


lotteryStatus 开奖状态

活动失效  activityFailure

status  valid 有效状态 invalid 无效状态

-- ---------------------------------------------------------------------------------------------------------------------

    `creator` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON
UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    `creator` VARCHAR (64) CHARACTER
SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time` datetime NOT NULL COMMENT '创建时间',
    `updater` VARCHAR (64) CHARACTER
SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新者',
    `update_time` datetime NOT NULL COMMENT '更新时间',

-- ---------------------------------------------------------------------------------------------------------------------

-- 【MySQL】MySQL表设计的经验（建议收藏）  https://juejin.cn/post/7308670902588702732

-- MySQL 将数据表中某字段设置为索引

ALTER TABLE 表名
    ADD INDEX 索引名 (字段名);

ALTER TABLE users
    ADD INDEX index_email (email);

ALTER TABLE users
    ADD INDEX email_index (email);

-- MySQL 创建唯一索引


ALTER TABLE users
    ADD UNIQUE INDEX idx_user_username(username);



-- 要将MySQL数据库中的某个字段设置为唯一索引，可以使用ALTER TABLE语句来完成。

-- 创建测试表
CREATE TABLE test_table
(
    id    INT PRIMARY KEY AUTO_INCREMENT,
    name  VARCHAR(50),
    email VARCHAR(100)
);

-- 添加唯一索引到email字段上
ALTER TABLE test_table
    ADD UNIQUE INDEX idx_unique_email (email);



-- 在MySQL中，可以使用ALTER TABLE语句来创建或修改表的联合唯一索引。
-- 添加联合唯一索引到已存在的表
-- 其中，constraint_name为约束名称，table_name为要操作的表名，(column1, column2)为需要包含在索引中的列名。
--
-- 注意事项：
--
-- 当创建联合唯一索引时，如果指定了多个列，则这些列组合必须保证每个值都不重复；
--
-- 对于已经存在数据的表，添加联合唯一索引会进行校验并确保新添加的记录符合该索引的限制条件。
ALTER TABLE table_name
    ADD CONSTRAINT constraint_name UNIQUE (column1, column2);

ALTER TABLE users
    ADD CONSTRAINT unique_user_email UNIQUE (username, email);



-- mysql在某一个字段后面增加一列
-- SQL ALTER TABLE 实例

alter table st_vehicle
    add column obu_number VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'OBU编号(车载电子标签)' after channel;

-- SQL SELECT 实例
select license_plate_number
from st_parking_lot
where license_plate_number in (select license_plate_number from st_vehicle where `status` = '00')

-- MySQL查询表中重复数据的方法及示例详解  https://blog.csdn.net/weixin_65846839/article/details/131527785
-- 使用MySQL查找重复数据的方法

SELECT column_name, COUNT(*) as count
FROM table_name
GROUP BY column_name
HAVING COUNT (*) >1;

SELECT name, bank_name, address, COUNT(*) as count
FROM st_bank_branches
where create_time > '2023-12-12 01:00:03'
GROUP BY name, bank_name, address
HAVING COUNT (*) > 1;

--

-- 查看某个数据库的表的用的字符集
SELECT TABLE_SCHEMA '数据库', TABLE_NAME '表', TABLE_COLLATION '原排序规则', CONCAT( 'ALTER TABLE ', TABLE_NAME, ' CHARACTER SET=utf8mb4,  COLLATE=utf8mb4_general_ci;' ) '修正SQL'
FROM information_schema.`TABLES`
WHERE TABLE_SCHEMA = 'transportation'
  AND TABLE_COLLATION != 'utf8mb4_general_ci';


-- 查看数据库中所有字段用的排序规则
SELECT TABLE_SCHEMA '数据库', TABLE_NAME '表', COLUMN_NAME '字段', CHARACTER_SET_NAME '原字符集', COLLATION_NAME '原排序规则', CONCAT(
    'ALTER TABLE ',
        TABLE_NAME,
        ' MODIFY COLUMN ',
        COLUMN_NAME,
        ' ',
        COLUMN_TYPE,
        -- - 设置新的编码和排序规则
        ' CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci',
        (CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE '' END),
        (CASE WHEN COLUMN_COMMENT = '' THEN ' ' ELSE concat(' COMMENT''', COLUMN_COMMENT, '''') END),
        ';'
    ) '修正SQL'
FROM information_schema.`COLUMNS`
WHERE
    -- -过滤正确排序规则
    COLLATION_NAME != 'utf8mb4_general_ci'
	-- -数据库名称
	AND TABLE_SCHEMA = 'transportation';


-- MySQL 的 IN 子句来查询基于字符串分割的值，但发现无法获取数据

-- MySQL使用FIND_IN_SET函数：

SELECT *
FROM `sys_operate_log`
where MODULE IN ('广告位', '会员管理', '车辆管理')

SELECT *
FROM `sys_operate_log`
where FIND_IN_SET(MODULE,'广告位,车辆管理');
-- 系统配置值为：广告位,车辆管理
SELECT *
FROM `sys_operate_log`
where FIND_IN_SET(MODULE,(SELECT config_value FROM sys_config where config_key = 'operation_log_search_fields'));

explain
SELECT *
FROM `sys_operate_log`
where FIND_IN_SET(MODULE,(SELECT config_value FROM sys_config where config_key = 'operation_log_search_fields'));


-- MySQL 根据创建时间、主键id降序排序

SELECT *
FROM `sys_operate_log`
ORDER BY create_time DESC, id DESC;

SELECT *
FROM table_name
ORDER BY create_time DESC, id DESC;

-- MySQL日期时间函数和操作总结  https://mp.weixin.qq.com/s/LzokvwgOoyoBgsJWe-y5Dg


-- DELETE IN

select *
from st_user_vehicle
where user_id = 'M2023121152321702278510512'

select *
from st_user_vehicle
where vehicle_id = 'veh20240425183841167031824762461'

select *
from st_vehicle
where id = 'veh20231211151529085583501172766'

select *
from st_vehicle
where license_plate_number = '宁D65009'



DELETE
FROM `st_user_vehicle`
where vehicle_id IN
      ('veh20240410182033036205744770226', 'veh20240410182043030502838668806', 'veh20240410182055710401055222555');
DELETE
FROM `st_vehicle`
where id IN
      ('veh20240410182033036205744770226', 'veh20240410182043030502838668806', 'veh20240410182055710401055222555');

DELETE
FROM `st_user_vehicle`
where vehicle_id IN ('veh20240426133357043460286135510', 'veh20240426133357383010145730813');
DELETE
FROM `st_vehicle`
where id IN ('veh20240426133357043460286135510', 'veh20240426133357383010145730813');


DELETE
FROM `st_user_vehicle`
where vehicle_id = 'veh20240416092142587226261077012';
DELETE
FROM `st_vehicle`
where id = 'veh20240416092142587226261077012';



SELECT license_plate_number, COUNT(license_plate_number) AS count
FROM st_vehicle
WHERE `status`='00'
GROUP BY license_plate_number
HAVING COUNT (license_plate_number)> 1;


SELECT name, COUNT(name) AS count
FROM st_etc_parking_lot
WHERE `status`='01'
GROUP BY name
HAVING COUNT (name)> 1;

SELECT event_id, COUNT(event_id) AS count
FROM st_travel_event
WHERE `data_status`='01'
GROUP BY event_id
HAVING COUNT (event_id)> 1;


-- MySQL 统计用户中奖次数

SELECT user_id, COUNT(*) AS win_count
FROM lottery_records
WHERE is_win = 1
GROUP BY user_id;


-- 请求号 Request Number   requestNo


-- 查询车辆类型不符

select b.vehicle_type as real_type
     , a.VEHICLE_NUMBER
     , a.vehicle_type
     , a.create_time
from st_vehicle a
         left join st_vehicle_mileage b on a.VEHICLE_NUMBER = b.vehicle_number
where b.vehicle_type is not null
  and a.VEHICLE_TYPE != b.vehicle_type


select b.vehicle_type as real_type
     , a.VEHICLE_NUMBER
     , a.vehicle_type
     , a.create_time
from st_vehicle a
         left join st_vehicle_mileage b on a.VEHICLE_NUMBER = b.vehicle_number
where b.vehicle_type is null

--     MySQL DATE_FORMAT() 函数


-- MySQL 查询当天数据

SELECT *
FROM 表名
WHERE DATE (时间字段) = CURDATE();

-- MySQL 按日期统计数据

SELECT DATE (create_time) AS date, COUNT (*) AS daily_count
FROM your_table_name
GROUP BY DATE (create_time)
ORDER BY date;

-- MySQL 按月统计数据

SELECT YEAR (create_time) AS year, MONTH (create_time) AS month, COUNT (*) AS count
FROM your_table_name
GROUP BY YEAR (create_time), MONTH (create_time)
ORDER BY year, month;

-- MySQL 按季度统计数据

SELECT YEAR (create_time) AS year, QUARTER(create_time) AS quarter, COUNT (*) AS count
FROM your_table_name
GROUP BY YEAR (create_time), QUARTER(create_time)
ORDER BY year, quarter;

-- MySQL 按年统计数据

SELECT YEAR (create_time) AS year, COUNT (*) AS count
FROM your_table_name
GROUP BY YEAR (create_time)
ORDER BY year;


-- SQL查找是否"存在"，别再count了！ https://mp.weixin.qq.com/s/EWAiVYv38QphIGmUFjO2lA


-- ##### SQL写法:
-- SELECT 1 FROM table WHERE a = 1 AND b = 2 LIMIT 1
--
-- ##### Java写法:
-- Integer exist = xxDao.existXxxxByXxx(params);
-- if ( exist != NULL ) {
--     //当存在时，执行这里的代码
-- } else {
--     //当不存在时，执行这里的代码
-- }


-- MySQL 统计一张表有多少条数据，最好的sql

SELECT COUNT(*)
FROM table_name;


-- Total mileage  总里程

-- 刷新数据  refresh data

SELECT *
FROM (SELECT vehicleNumber AS vehicle_number, SUM(mileage) AS total_mileage
      FROM new_road_sum
      GROUP BY vehicle_number) vm
ORDER BY vm.total_mileage DESC LIMIT 50000;


SELECT m.NICK_NAME AS '用户昵称', m.MOBILE AS '手机号', v.VEHICLE_NUMBER AS '车牌号', d.MILEAGE AS '总里程'
FROM ST_USER_VEHICLE uv
         LEFT JOIN ST_MEMBER m ON m.ID = uv.USER_ID
         LEFT JOIN ST_VEHICLE v ON v.VEHICLE_ID = uv.VEHICLE_ID
         LEFT JOIN st_vehicle_mileage d ON v.VEHICLE_NUMBER = d.vehicle_number
WHERE uv.`STATUS` = '01'
  AND v.`STATUS` = '01'
  AND m.`STATUS` = '1'
  AND d.VEHICLE_TYPE IN (11, 12, 13, 14, 15, 16, 21, 22, 23, 24, 25, 26)
  AND v.CREATE_TIME >= '2023-11-01 00:00:00'
ORDER BY v.CREATE_TIME DESC


-- 在SQL表中查找重复值  Finding duplicate values in a SQL table  https://stackoverflow.com/questions/2594829/finding-duplicate-values-in-a-sql-table

SELECT column_name, COUNT(column_name)
FROM table_name
GROUP BY column_name
HAVING COUNT(column_name) > 1;


SELECT column1, column2, COUNT(*) as count
FROM table
GROUP BY column1, column2
HAVING COUNT (*) > 1;

SELECT vehicleNumber,
       vehicleColor,
       COUNT(*) AS CountOf
FROM st_etc_user_data
GROUP BY vehicleNumber, vehicleColor
HAVING COUNT(*) > 1


SELECT *
FROM st_etc_user_data
WHERE id NOT IN (
    SELECT MIN(id)
    FROM st_etc_user_data
    GROUP BY vehicleNumber, vehicleColor
);


-- GROUP_CONCAT()函数

SELECT vehicleNumber, GROUP_CONCAT(id)
FROM st_etc_user_data
GROUP BY vehicleNumber
HAVING COUNT(vehicleNumber) > 1;


SELECT y.id,
       y.vehicleNumber,
       y.vehicleColor
FROM st_etc_user_data y
         INNER JOIN (SELECT vehicleNumber,
                            vehicleColor,
                            COUNT(*) AS CountOf
                     FROM st_etc_user_data
                     GROUP BY vehicleNumber, vehicleColor
                     HAVING COUNT(*) > 1
) dt ON y.vehicleNumber = dt.vehicleNumber AND y.vehicleColor = dt.vehicleColor

-- 高效处理MySQL表中重复数据的方法  https://cloud.tencent.com/developer/article/2317614

-- 清除重复数据：MySQL中的去重技巧和策略  https://baijiahao.baidu.com/s?id=1774435130995014381&wfr=spider&for=pc

-- 如何正确的使用一条SQL删除重复数据  https://cloud.tencent.com/developer/article/2013578

SELECT vehicleNumber,
       vehicleColor,
       COUNT(*) AS CountOf
FROM st_etc_user_data
GROUP BY vehicleNumber, vehicleColor
HAVING COUNT(*) > 1


DELETE
FROM st_etc_user_data
WHERE (vehicleNumber, vehicleColor) IN (SELECT vehicleNumber, vehicleColor
                                        FROM st_etc_user_data
                                        GROUP BY vehicleNumber, vehicleColor
                                        HAVING count(*) > 1)
  AND id NOT IN (SELECT min(id) FROM st_etc_user_data GROUP BY vehicleNumber, vehicleColor HAVING count(*) > 1);



SELECT a.*
FROM st_etc_user_data a,
     (SELECT vehicleNumber, vehicleColor, MAX(id) id
      FROM st_etc_user_data
      GROUP BY vehicleNumber, vehicleColor
      HAVING COUNT(*) > 1) b
WHERE a.vehicleNumber = b.vehicleNumber
  AND a.vehicleColor = b.vehicleColor
  AND a.id <> b.id


DELETE
a
FROM
	st_etc_user_data a,
	( SELECT vehicleNumber, vehicleColor, MAX( id ) id FROM st_etc_user_data GROUP BY vehicleNumber, vehicleColor HAVING COUNT(*)> 1 ) b
WHERE
	a.vehicleNumber = b.vehicleNumber
	AND a.vehicleColor = b.vehicleColor
	AND a.id <> b.id


-- 如何最快复制一张上百万条数据的表

CREATE TABLE new_table AS
SELECT *
FROM old_table;

-- 复制一张包含上百万条数据的表，并添加一个自增列但不作为主键，最快，最好的方法

-- 艹！就写了个 insert into select ，居然被开了  https://juejin.cn/post/6931890118538199048

-- Primary Key ID  主键ID  primary_key_id

-- seq_id

-- SQL MIN() 语法

-- MIN 和 MAX 也可用于文本列，以获得按字母顺序排列的最高或最低值。

-- SQL MAX() 语法

-- MySQL中的IN关键字可以接受数字、字符串和NULL值。


-- photos  images  pictures

-- contact phone

-- UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值

-- SQL优化IN子句的方法

-- MySQL中的Join用法  https://cloud.tencent.com/developer/article/1744780

-- 一张图看懂 SQL 的各种 JOIN 用法  https://www.runoob.com/w3cnote/sql-join-image-explain.html

-- MySQL字段的字符类型该如何选择?千万数据下varchar和char性能竟然相差30%🚀  https://cloud.tencent.com/developer/article/2426547

-- 麦斯蔻（MySQL）的一生  https://cloud.tencent.com/developer/article/2417217

-- SQL SELECT… FOR UPDATE 锁的释放  https://geek-docs.com/sql/sql-ask-answer/791_sql_release_of_a_select_for_update_lock.html

-- UNION ALL


/*

 SELECT...GROUP BY 前后字段必须保持一直吗？

 SELECT...GROUP BY前后字段不一定要保持一致。

在使用GROUP BY时，通常需要遵守一些原则来确保查询的语义正确性。按照标准SQL的要求，SELECT子句中的所有非聚合列必须出现在GROUP BY子句中。
 然而，实际应用中，这一规则并非绝对。在MySQL等某些数据库系统中，可以通过设置sql_mode来放宽或严格实施这一规定。
 如果sql_mode设置为ONLY_FULL_GROUP_BY，那么所有非聚合列都必须出现在GROUP BY中；如果不包含ONLY_FULL_GROUP_BY模式，则可以更灵活地使用GROUP BY。

List去重是GROUP BY吗？

List去重并不是GROUP BY，这两者在概念和实现上有所不同。

List去重是一个编程概念，通常指的是从一个列表中移除重复的元素，最终得到一个只含唯一元素的新列表。这可以通过多种方法实现，例如使用集合（set）数据结构或者遍历列表并检查元素是否已出现过等方法。List去重是作用于单一的数据结构内部，不涉及数据库查询或数据处理。

相比之下，GROUP BY是SQL语言中的一个子句，用于将具有相同值的行分组到一起，以便对每个组应用聚合函数，如COUNT、SUM、AVG等。GROUP BY通常用于对数据库表中的数据进行汇总和分析。

简而言之，list去重是编程中处理数据集合的一种常见操作，而GROUP BY是SQL查询中用于数据分组和分析的一种方法。两者都可用于去除重复的数据，但应用场景和具体实现方式不同。

 */


-- MySQL中的GROUP BY和DISTINCT：去重的效果与用法解析  https://cloud.tencent.com/developer/article/2354531

-- 毫秒级时间戳一般为13位。

-- SQL 往数据库表里面添加一个时间字段，该字段设置为int类型自动插入的13位毫秒级时间戳

ALTER TABLE 表名
    ADD COLUMN timestamp int(13) NOT NULL DEFAULT UNIX_TIMESTAMP(CURRENT_TIMESTAMP) * 1000;





SELECT *
FROM st_member
WHERE `STATUS` = 1
  AND ID IN (
    SELECT userId
    FROM (
             SELECT DISTINCT m.ID AS userId
             FROM st_user_vehicle uv
                      LEFT JOIN st_member m ON m.ID = uv.USER_ID
                      LEFT JOIN st_vehicle v ON v.VEHICLE_ID = uv.VEHICLE_ID
             WHERE m.`STATUS` = 1
               AND v.`STATUS` = '01'
               AND uv.`STATUS` = '01'
               AND v.VEHICLE_ID IN
                   ('VIE2023021017285773031652', 'VIE20230224114236312183482078818', 'VIE20230224114236078875082113645')
             UNION ALL
             SELECT DISTINCT user_id AS userId
             FROM st_enterprise_vehicles
             WHERE ID IN ('VIE2023021017285773031652', 'VIE20230224114236312183482078818',
                          'VIE20230224114236078875082113645')) us
)

SELECT *
FROM st_member
WHERE `STATUS` = 1
  AND ID IN (
    SELECT userId
    FROM (
             SELECT DISTINCT m.ID AS userId
             FROM st_user_vehicle uv
                      LEFT JOIN st_member m ON m.ID = uv.USER_ID
                      LEFT JOIN st_vehicle v ON v.VEHICLE_ID = uv.VEHICLE_ID
             WHERE m.`STATUS` = 1
               AND v.`STATUS` = '01'
               AND uv.`STATUS` = '01'


               AND v.VEHICLE_ID IN
        <foreach item="item" index="index" collection="vehicleIds" open="(" close=")" separator=",">
            #{item}
        </foreach>

             UNION ALL
             SELECT DISTINCT
                 user_id AS userId
             FROM
                 st_enterprise_vehicles
             WHERE
                 ID IN
                 <foreach item="item" index ="index" collection="vehicleIds" open ="(" close =")" separator=","
                 >
                 #{item}
                 </foreach
                 >
         ) us
)


--   在MySQL中，OR查询用于从表中检索满足至少一个条件的行。

SELECT *
FROM employees
WHERE (name = 'John' OR age = 30)
  AND department = 'IT';


-- 在MySQL中，OR和AND用于组合多个条件进行查询。


-- mybatis 动态sql like, or 联合查询


<
select id = "findUsers" parameterType="map" resultType="User">
SELECT *
FROM user
WHERE 1 = 1
          < if test="name != null and name != ''">
        AND (name LIKE CONCAT('%', #{name}, '%') OR nickname LIKE CONCAT('%', #{name}, '%'))
    </if>
    <if test="age != null">
        AND age = #{age}
    </if>
    <if test="gender != null">
        AND gender = #{gender}
    </if>
</
select>


--       limit  限制


-- SQL分页查询详解  https://developer.aliyun.com/article/1348255

-- 乐观锁
update table
set version = version + 1
where id = #{id} and version = #{version}


-- SQL查询手机号中间四位脱敏
SELECT CONCAT(SUBSTRING(phone_number, 1, 3), '****', SUBSTRING(phone_number, 8)) AS masked_phone_number
FROM your_table;

-- SQL 根据条件修改多个字段值语法
UPDATE table_name
SET column1 = value1,
    column2 = value2, ...
    WHERE condition;
-- 修改多个字段值，可以使用逗号分隔每个字段和值对，并在WHERE子句中指定条件。
UPDATE employees
SET salary = salary * 1.1,
    name   = 'Low Salary'
WHERE salary < 5000;

UPDATE students
SET grade = 'senior',
    age   = age - 2
WHERE age > 18;



select DISTINCT v.VEHICLE_NUMBER, v.vehicle_type, sp.vehicle_type as real_vehicle_typ
from st_vehicle v
         LEFT JOIN st_plat_vehicle_mileage_info sp on v.VEHICLE_NUMBER = sp.vehicle_number
where v.vehicle_type = '1'
  and v.vehicle_type != sp.vehicle_type


-- result 结果  data_sources  数据来源  channel 渠道  sign  签名  label 标签  mark 作记号  tag 标签 flag 标示  Convert storage 转换存储 construct Data 构建数据 assembly Data 装配数据

-- detection station  检测站

-- EverSQL向左，PawSQL向右  https://cloud.tencent.com/developer/article/2446625

-- 如何安全有效的将SQL语句中的IN和NOT IN替换

-- 在SQL查询时，如果需要在结果集中添加一个不存在于数据库表中的字段

-- 在SQL查询时，如果需要在结果集中添加两个不存在于数据库表中的字段，一个默认字符串‘01’ 一个默认为‘’

SELECT column1, column2, '01' AS default_string, '' AS default_empty_string
FROM your_table;

-- 写union all的sql时，最好保证两部分的字段顺序，类型，名称，大小写等等全部一致。

-- UNION 查询两个字段名不一致时返回的结果以第一个SELECT为准

-- 当使用UNION ALL或UNION合并两张表时，如果返回的结果中字段的位置不正确，可能是因为：
--
-- 1.两张表中对应的字段名或者字段类型不一致，导致合并时无法正确对应字段。
--
-- 2.查询语句中字段选择顺序不一致。
--
-- 解决方法：
--
-- 1.确保两张表中要合并的字段具有相同的名称和数据类型。
--
-- 2.在每个查询语句中明确指定字段的顺序，以保证它们在两个查询中的位置相匹配。

-- 示例：
--
-- 假设有两张表table1和table2，它们都有字段id, name, age。
--
-- 错误的查询示例：
--
-- SELECT id, name, age FROM table1
-- UNION ALL
-- SELECT id, age, name FROM table2;
-- 正确的查询示例：
--
-- SELECT id, name, age FROM table1
-- UNION ALL
-- SELECT id, name, age FROM table2;
-- 或者在每个查询中明确指定字段名称：
--
-- SELECT id, name, age FROM table1
-- UNION ALL
-- SELECT id, name, age FROM table2;
-- 确保每个查询中字段的顺序和数据类型都与其他查询保持一致。


-- SQL中的UNION和UNION ALL详解  https://cloud.tencent.com/developer/article/2351408

-- What is the difference between UNION and UNION ALL?  https://stackoverflow.com/questions/49925/what-is-the-difference-between-union-and-union-all?r=SearchResults


-- 写union all的sql时，如果两张表的字段都不一样，怎么写？

-- 在SQL中，UNION ALL操作符用于合并两个或多个SELECT语句的结果集。如果两张表的字段不一样，我们需要确保每个SELECT语句选择相同的列数和类型。然后，我们可以使用NULL值来填充缺失的列，以便结果集的结构保持一致。
--
-- 假设我们有两个表，table1有字段A、B，table2有字段C、D，我们可以这样写：
--
--

-- SELECT A, B, NULL AS C, NULL AS D FROM table1
-- UNION ALL
-- SELECT NULL AS A, NULL AS B, C, D FROM table2;
--
--
-- 这里，我们在第一个SELECT语句中使用了NULL值来填充table1中不存在的字段C和D，同样地，在第二个SELECT语句中，我们使用了NULL值来填充table2中不存在的字段A和B。这样，两个结果集就可以正确地合并在一起。


-- SQL中的UNION和UNION ALL哪个比较好


-- 在SQL中，UNION和UNION ALL都是用于合并两个或多个SELECT语句的结果集。它们的主要区别在于处理重复记录的方式：
--
-- UNION：会自动去除结果集中的重复记录。这意味着，如果你的两个SELECT语句返回了相同的行，那么在最终的结果集中只会保留一行。
-- UNION ALL：不会去除结果集中的重复记录。这意味着，如果两个SELECT语句返回了相同的行，那么这些行都会包含在最终的结果集中。
-- 关于哪个更好，这取决于你的具体需求：
--
-- 如果你不希望结果集中包含重复的记录，你应该使用UNION。
-- 如果你希望保留所有的重复记录，包括那些在不同SELECT语句中返回的相同行，你应该使用UNION ALL。
-- 从性能的角度来看，UNION ALL通常比UNION更快，因为它不需要执行额外的去重操作。但是，这种性能差异通常只有在处理大量数据时才会变得显著。

-- SQL 最有效安全的查询某个字段不为null且不为空字符串

SELECT *
FROM table_name
WHERE column_name IS NOT NULL
  AND column_name <> '';

-- 在 MyBatis 中，<> 符号用于表示 SQL 语句中的不等于操作符。

<
select id = "findUsersByNameNotEqual" parameterType="string" resultType="User">
SELECT *
FROM users
WHERE name <> #{name}
</
select>


-- SQL 如何最有效安全的 统计每个公司的车辆数量

SELECT company_id, COUNT(*) as vehicle_count
FROM company_vehicles
GROUP BY company_id;


SELECT company_name, COUNT(vehicle_id) AS vehicle_count
FROM vehicles
GROUP BY company_name;


-- MySQL  UNION统计三张不同表的企业车辆榜

SELECT company_name, SUM(vehicle_count) AS total_vehicles
FROM (
         SELECT company_name, vehicle_count
         FROM table1
         UNION ALL
         SELECT company_name, vehicle_count
         FROM table2
         UNION ALL
         SELECT company_name, vehicle_count
         FROM table3
     ) AS combined_table
GROUP BY company_name
ORDER BY total_vehicles DESC;

-- 企业车辆榜（可视化大屏）

SELECT enterpriseName,
       SUM(vehicleNum) AS vehicleNum
FROM (
         SELECT corporate_name AS enterpriseName, COUNT(VEHICLE_ID) as vehicleNum
         FROM st_vehicle
         WHERE `STATUS` = '01'
           AND vehicle_ownership = '01'
           AND corporate_name IS NOT NULL
           AND corporate_name <> ''
         GROUP BY enterpriseName

         UNION ALL

         SELECT ENTERPRISE_NAME AS enterpriseName, COUNT(ID) as vehicleNum
         FROM st_promotion_user_management
         WHERE LICENSE_PLATE_OWNER = '02'
           AND `STATUS` = 0
           AND ENTERPRISE_NAME IS NOT NULL
           AND ENTERPRISE_NAME <> ''
         GROUP BY enterpriseName

         UNION ALL

         SELECT enterprise_name AS enterpriseName, COUNT(ID) as vehicleNum
         FROM st_enterprise_vehicles
         WHERE `status` = '01'
           AND enterprise_name IS NOT NULL
           AND enterprise_name <> ''
         GROUP BY enterpriseName

         UNION ALL

         SELECT enterprise_name AS enterpriseName, vehicles_num AS vehicleNum
         FROM st_enterprise_vehicle_pseudo_data
         WHERE `STATUS` = '01'
           AND enterprise_name IS NOT NULL
           AND enterprise_name <> ''
         GROUP BY enterpriseName
     ) AS combined_table

WHERE NOT EXISTS(SELECT config_value FROM sys_config WHERE combined_table.enterpriseName = sys_config.config_value)

  AND enterpriseName = '陕西交通控股集团靖富分公司'

GROUP BY enterpriseName
ORDER BY vehicleNum DESC

-- 企业车辆榜

SELECT enterpriseName,
       SUM(vehicleNum) AS vehicleNum,
       createTime
FROM (
         SELECT corporate_name AS enterpriseName, COUNT(VEHICLE_ID) as vehicleNum, CREATE_TIME AS createTime
         FROM st_vehicle
         WHERE `STATUS` = '01'
           AND vehicle_ownership = '01'
           AND corporate_name IS NOT NULL
           AND corporate_name != ''
         GROUP BY enterpriseName

         UNION ALL

         SELECT ENTERPRISE_NAME AS enterpriseName, COUNT (ID) as vehicleNum, CREATE_TIME AS createTime
         FROM st_promotion_user_management
         WHERE LICENSE_PLATE_OWNER='02'
           AND `STATUS`=0
           AND ENTERPRISE_NAME IS NOT NULL
           AND ENTERPRISE_NAME != ''
         GROUP BY enterpriseName

         UNION ALL

         SELECT enterprise_name AS enterpriseName, COUNT (ID) as vehicleNum, create_time AS createTime
         FROM st_enterprise_vehicles
         WHERE `status`= '01'
           AND enterprise_name IS NOT NULL
           AND enterprise_name != ''
         GROUP BY enterpriseName

         UNION ALL

         SELECT enterprise_name AS enterpriseName, vehicles_num AS vehicleNum, create_time AS createTime
         FROM st_enterprise_vehicle_pseudo_data
         WHERE `STATUS` = '01'
           AND enterprise_name IS NOT NULL
           AND enterprise_name != ''
         GROUP BY enterpriseName
     ) AS combined_table

WHERE NOT EXISTS(SELECT config_value FROM sys_config WHERE combined_table.enterpriseName = sys_config.config_value)

-- AND enterpriseName = '陕西交通控股集团靖富分公司'

GROUP BY enterpriseName
ORDER BY vehicleNum DESC

--

SELECT enterpriseName,
       plate_number
FROM (
         SELECT corporate_name AS enterpriseName,
                VEHICLE_NUMBER AS plate_number
         FROM st_vehicle
         WHERE corporate_name = '河南雷特预应力有限公司'
           AND `STATUS` = '01'
           AND vehicle_ownership = '01'

         UNION ALL

         SELECT ENTERPRISE_NAME      AS enterpriseName,
                LICENSE_PLATE_NUMBER AS plate_number
         FROM st_promotion_user_management
         WHERE enterprise_name = '河南雷特预应力有限公司'
           AND LICENSE_PLATE_OWNER = '02'
           AND `status` = 0

         UNION ALL

         SELECT enterprise_name AS enterpriseName,
                vehicle_number  AS plate_number
         FROM st_enterprise_vehicles
         WHERE enterprise_name = '河南雷特预应力有限公司'
           AND `status` = '01'
     ) AS combined_table

--

SELECT plate_number
FROM (
         SELECT corporate_name AS enterpriseName,
                VEHICLE_NUMBER AS plate_number
         FROM st_vehicle
         WHERE `STATUS` = '01'
           AND vehicle_ownership = '01'

         UNION ALL

         SELECT ENTERPRISE_NAME      AS enterpriseName,
                LICENSE_PLATE_NUMBER AS plate_number
         FROM st_promotion_user_management
         WHERE LICENSE_PLATE_OWNER = '02'
           AND `status` = 0

         UNION ALL

         SELECT enterprise_name AS enterpriseName,
                vehicle_number  AS plate_number
         FROM st_enterprise_vehicles
         WHERE `status` = '01'
     ) AS combined_table
WHERE enterpriseName = '河南雷特预应力有限公司'
--

SELECT plate_number
FROM (
         SELECT VEHICLE_NUMBER AS plate_number
         FROM st_vehicle
         WHERE corporate_name = '河南雷特预应力有限公司'
           AND `STATUS` = '01'
           AND vehicle_ownership = '01'

         UNION ALL

         SELECT LICENSE_PLATE_NUMBER AS plate_number
         FROM st_promotion_user_management
         WHERE enterprise_name = '河南雷特预应力有限公司'
           AND LICENSE_PLATE_OWNER = '02'
           AND `status` = 0

         UNION ALL

         SELECT vehicle_number AS plate_number
         FROM st_enterprise_vehicles
         WHERE enterprise_name = '河南雷特预应力有限公司'
           AND `status` = '01'
     ) AS temporary_table

--

SELECT enterpriseName
FROM (
         SELECT enterpriseName,
                SUM(vehicleNum) AS vehicleNum
         FROM (
                  SELECT corporate_name AS enterpriseName, COUNT(VEHICLE_ID) as vehicleNum
                  FROM st_vehicle
                  WHERE `STATUS` = '01'
                    AND vehicle_ownership = '01'
                    AND corporate_name IS NOT NULL
                    AND corporate_name <> ''
                  GROUP BY enterpriseName

                  UNION ALL

                  SELECT ENTERPRISE_NAME AS enterpriseName, COUNT(ID) as vehicleNum
                  FROM st_promotion_user_management
                  WHERE LICENSE_PLATE_OWNER = '02'
                    AND `STATUS` = 0
                    AND ENTERPRISE_NAME IS NOT NULL
                    AND ENTERPRISE_NAME <> ''
                  GROUP BY enterpriseName

                  UNION ALL

                  SELECT enterprise_name AS enterpriseName, COUNT(ID) as vehicleNum
                  FROM st_enterprise_vehicles
                  WHERE `status` = '01'
                    AND enterprise_name IS NOT NULL
                    AND enterprise_name <> ''
                  GROUP BY enterpriseName
              ) AS combined_table

         WHERE NOT EXISTS(SELECT config_value
                          FROM sys_config
                          WHERE combined_table.enterpriseName = sys_config.config_value)

           AND enterpriseName = '河南雷特预应力有限公司'

         GROUP BY enterpriseName
         ORDER BY vehicleNum DESC LIMIT 30
     ) AS tab

--

SELECT enterpriseName,
       SUM(vehicleNum) AS vehicleNum
FROM (
         SELECT corporate_name AS enterpriseName, COUNT(VEHICLE_ID) as vehicleNum
         FROM st_vehicle
         WHERE `STATUS` = '01'
           AND vehicle_ownership = '01'
           AND corporate_name IS NOT NULL
           AND corporate_name <> ''
         GROUP BY enterpriseName

         UNION ALL

         SELECT ENTERPRISE_NAME AS enterpriseName, COUNT(ID) as vehicleNum
         FROM st_promotion_user_management
         WHERE LICENSE_PLATE_OWNER = '02'
           AND `STATUS` = 0
           AND ENTERPRISE_NAME IS NOT NULL
           AND ENTERPRISE_NAME <> ''
         GROUP BY enterpriseName

         UNION ALL

         SELECT enterprise_name AS enterpriseName, COUNT(ID) as vehicleNum
         FROM st_enterprise_vehicles
         WHERE `status` = '01'
           AND enterprise_name IS NOT NULL
           AND enterprise_name <> ''
         GROUP BY enterpriseName
     ) AS combined_table

WHERE NOT EXISTS(SELECT config_value FROM sys_config WHERE combined_table.enterpriseName = sys_config.config_value)

GROUP BY enterpriseName
ORDER BY vehicleNum DESC LIMIT 30


-- 总积分

SELECT SUM(INTEGRAL) AS total_points
from st_integral_detail
WHERE VEHICLE_NUMBER IN (
    SELECT plate_number
    FROM (
             SELECT corporate_name AS enterpriseName,
                    VEHICLE_NUMBER AS plate_number
             FROM st_vehicle
             WHERE `STATUS` = '01'
               AND vehicle_ownership = '01'
             UNION ALL
             SELECT ENTERPRISE_NAME      AS enterpriseName,
                    LICENSE_PLATE_NUMBER AS plate_number
             FROM st_promotion_user_management
             WHERE LICENSE_PLATE_OWNER = '02'
               AND `status` = 0
             UNION ALL
             SELECT enterprise_name AS enterpriseName,
                    vehicle_number  AS plate_number
             FROM st_enterprise_vehicles
             WHERE `status` = '01'
         ) AS combined_table
    WHERE enterpriseName = '礼泉海螺水泥有限责任公司'
)

  AND CREATE_TIME >= '2024-01-01 00:00:00'
  AND CREATE_TIME <= '2024-12-31 23:59:59'
  AND MODE = '01'

--

SELECT ID AS total_points
from st_integral_detail
WHERE VEHICLE_NUMBER IN (
    SELECT plate_number
    FROM (
             SELECT VEHICLE_NUMBER AS plate_number
             FROM st_vehicle
             WHERE corporate_name = '河南雷特预应力有限公司'
               AND `STATUS` = '01'
               AND vehicle_ownership = '01'

             UNION ALL

             SELECT LICENSE_PLATE_NUMBER AS plate_number
             FROM st_promotion_user_management
             WHERE enterprise_name = '河南雷特预应力有限公司'
               AND LICENSE_PLATE_OWNER = '02'
               AND `status` = 0

             UNION ALL

             SELECT vehicle_number AS plate_number
             FROM st_enterprise_vehicles
             WHERE enterprise_name = '河南雷特预应力有限公司'
               AND `status` = '01'
         ) AS temporary_table
)

  AND CREATE_TIME >= '2024-01-01 00:00:00'
  AND CREATE_TIME <= '2024-12-31 23:59:59'
  AND MODE = '01'



-- 如何在MyBatis XML文件中正确处理特殊符号


--  develop


--  ====================================================================================================================

-- MySQL 设计缴费金额兑换积分比例表
-- ----------------------------
-- Table structure for st_payment_to_points_ratio
-- ----------------------------

DROP TABLE IF EXISTS `st_payment_to_points_ratio`;
CREATE TABLE `st_payment_to_points_ratio`
(
    `id`           VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '唯一标识符ID',
    `min_amount`   DECIMAL(10, 2) NULL DEFAULT NULL COMMENT '最小缴费金额',
    `max_amount`   DECIMAL(10, 2) NULL DEFAULT NULL COMMENT '最大缴费金额',
    `points_ratio` DECIMAL(10, 2)                                               NOT NULL COMMENT '兑换积分比例',
    `status`       VARCHAR(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态（01，正常 99，作废）',
    `remarks`      VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    `creator`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
    `create_time`  datetime                                                     NOT NULL COMMENT '创建时间',
    `updater`      VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新者',
    `update_time`  datetime                                                     NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `min_amount_max_amount_unique`(`min_amount`, `max_amount`) USING BTREE COMMENT '缴费金额'
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '缴费金额兑换积分比例表';

-- 缴费金额在0到100之间，兑换比例为1:10（即每缴费1元，获得10积分）。
-- 缴费金额在100到500之间，兑换比例为1:5（即每缴费1元，获得5积分）。
-- 缴费金额在500以上，兑换比例为1:2（即每缴费1元，获得2积分）。


INSERT INTO `gzb`.`st_payment_to_points_ratio` (`id`, `min_amount`, `max_amount`, `points_ratio`, `status`, `remarks`,
                                                `creator`, `create_time`, `updater`, `update_time`)
VALUES ('1', 0.00, 100.00, 10.00, '01', '每缴费1元，获得10积分', '系统管理员', '2023-10-01 10:00:00', '系统管理员', '2023-10-01 10:00:00');
INSERT INTO `gzb`.`st_payment_to_points_ratio` (`id`, `min_amount`, `max_amount`, `points_ratio`, `status`, `remarks`,
                                                `creator`, `create_time`, `updater`, `update_time`)
VALUES ('2', 100.00, 500.00, 5.00, '01', '每缴费1元，获得5积分', '系统管理员', '2023-10-01 10:05:00', '系统管理员', '2023-10-01 10:05:00');
INSERT INTO `gzb`.`st_payment_to_points_ratio` (`id`, `min_amount`, `max_amount`, `points_ratio`, `status`, `remarks`,
                                                `creator`, `create_time`, `updater`, `update_time`)
VALUES ('3', 500.00, 99999999.99, 2.00, '01', '每缴费1元，获得2积分', '系统管理员', '2023-10-01 10:10:00', '系统管理员',
        '2023-10-01 10:10:00');


-- 计算逻辑：对于每个区间，我们计算积分的方法是：积分=(支付金额−最小金额+1)×积分比例  假设用户有一个缴费金额为250元，我们需要计算其可以获得多少积分：
SELECT SUM(CASE
               WHEN amount >= min_amount AND amount <= max_amount THEN (amount - min_amount + 1) * points_ratio
               ELSE 0 END) AS total_points
FROM st_payment_to_points_ratio,
     (SELECT 250 AS amount) AS user_payment;

-- 字段均为：VARCHAR
SELECT SUM(CASE
               WHEN CAST(amount AS DECIMAL(10, 2)) >= CAST(min_amount AS DECIMAL(10, 2)) AND
                    CAST(amount AS DECIMAL(10, 2)) <= CAST(max_amount AS DECIMAL(10, 2)) THEN
                       (CAST(amount AS DECIMAL(10, 2)) - CAST(min_amount AS DECIMAL(10, 2)) + 1) *
                       CAST(points_ratio AS DECIMAL(5, 2))
               ELSE 0
    END) AS total_points
FROM st_payment_to_points_ratio,
     (SELECT '250' AS amount) AS user_payment;

--
SELECT SUM(CASE
               WHEN amount >= min_amount AND amount <= max_amount THEN amount * points_ratio
               ELSE 0 END) AS total_points
FROM st_payment_to_points_ratio,
     (SELECT 250 AS amount) AS user_payment;

--
SELECT `points_ratio`
FROM `st_payment_to_points_ratio`


--  ====================================================================================================================
-- MySQL 逐月用户绑车数量

SELECT DATE_FORMAT(bind_date, '%Y-%m') AS month,
    COUNT(*) AS bind_count
FROM
    user_vehicles
GROUP BY
    DATE_FORMAT(bind_date, '%Y-%m')
ORDER BY
    month;


SELECT DATE_FORMAT(CREATE_TIME, '%Y-%m') AS month,
    COUNT(*) AS bind_count
FROM
    st_vehicle
WHERE `STATUS` = '01' AND CREATE_TIME >= '2024-05-28 00:00:00' AND CREATE_TIME<= '2024-10-31 23:59:59'
GROUP BY
    DATE_FORMAT(CREATE_TIME, '%Y-%m')
ORDER BY
    month;


-- SQL如何确保数据唯一性？  https://developer.aliyun.com/article/1323783

-- MySQL 表整行数据唯一性设置  https://developer.aliyun.com/article/1619587


-- 用户签到表 (user_check_in)

-- 创建用户签到表
CREATE TABLE user_check_in (
                               user_id INT PRIMARY KEY AUTO_INCREMENT, -- 用户唯一标识符，自增主键
                               user_name VARCHAR(50) NOT NULL, -- 用户名，不允许为空
                               email VARCHAR(100) NOT NULL, -- 用户邮箱，不允许为空
                               phone_number VARCHAR(20), -- 用户电话号码，可以为空
                               check_in_date DATE NOT NULL, -- 签到日期，不允许为空
                               check_in_time TIME NOT NULL, -- 签到时间，不允许为空
                               check_in_status TINYINT NOT NULL DEFAULT 0, -- 签到状态，默认值为0（未签到）
                               reward_points INT NOT NULL DEFAULT 0, -- 奖励积分，默认值为0
                               total_check_ins INT NOT NULL DEFAULT 0, -- 总签到次数，默认值为0
                               streak_days INT NOT NULL DEFAULT 0, -- 连续签到天数，默认值为0
                               last_check_in_date DATE, -- 上次签到日期，可以为空
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 记录创建时间，默认值为当前时间戳
                               updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 记录更新时间，默认值为当前时间戳，并在更新时自动更新为当前时间戳
);



-- 插入示例数据到用户签到表中
INSERT INTO user_check_in (user_name, email, phone_number, check_in_date, check_in_time, check_in_status, reward_points, total_check_ins, streak_days, last_check_in_date)
VALUES
    ('Alice', 'alice@example.com', '1234567890', '2023-10-01', '08:30:00', 1, 10, 1, 1, '2023-09-30'), -- Alice的签到记录
    ('Bob', 'bob@example.com', '0987654321', '2023-10-01', '09:15:00', 1, 15, 2, 2, '2023-09-30'), -- Bob的签到记录
    ('Charlie', 'charlie@example.com', '1122334455', '2023-10-01', '10:00:00', 1, 20, 3, 3, '2023-09-30'); -- Charlie的签到记录



-- 更新用户签到状态和奖励积分
UPDATE user_check_in
SET check_in_status = 1, reward_points = reward_points + 10, total_check_ins = total_check_ins + 1, streak_days = streak_days + 1, last_check_in_date = CURDATE()
WHERE user_id = 1 AND check_in_date = CURDATE();


-- 在 MySQL 中，如果你需要根据手机号的前三位和后四位来查询记录，可以使用 LIKE 运算符结合通配符来实现。

SELECT * FROM users
WHERE phone_number LIKE '123%' AND phone_number LIKE '%4567';


-- SQL设计一张多级菜单表，并且能够获取任意一级以下或以上的菜单

-- ----------------------------
-- Table structure for st_road_menu
-- ----------------------------
DROP TABLE IF EXISTS `st_road_menu`;
CREATE TABLE `st_road_menu`
(
    `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单ID',
    `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
    `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '父菜单ID',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = INNODB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '各省路段菜单表';
