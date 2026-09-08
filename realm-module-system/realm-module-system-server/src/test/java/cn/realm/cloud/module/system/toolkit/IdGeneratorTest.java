package cn.realm.cloud.module.system.toolkit;

import cn.hutool.core.lang.Snowflake;
import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.toolkit.Constants;
import com.baomidou.mybatisplus.core.toolkit.IdWorker;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.atomic.AtomicLong;

class IdGeneratorTest {

    private static final Logger logger = LoggerFactory.getLogger(IdGeneratorTest.class);

    @Test
    public void generatorTest() {
        // —— 原有代码 ——
        long id = IdWorker.getId();
        logger.info("id:{}", id);

        String timeId = IdWorker.getTimeId();
        logger.info("timeId:{}", timeId);

        long snowflakeNextId = IdUtil.getSnowflakeNextId();
        logger.info("snowflakeNextId:{}", snowflakeNextId);


        // —— Hutool 的 IdUtil.getSnowflake() 已经实现了完整的雪花算法，无需自己造轮子。 ——

        // —— 新增：IdUtil.getSnowflake() 完整测试 ——

        // 1. 自定义 workerId 和 datacenterId（支持 0~31）
        Snowflake snowflake = IdUtil.getSnowflake(1, 1);  // 机器ID=1，数据中心ID=1
        long customId1 = snowflake.nextId();
        long customId2 = snowflake.nextId();
        logger.info("自定义雪花(workerId=1, datacenterId=1) 生成ID1: {}", customId1);
        logger.info("自定义雪花(workerId=1, datacenterId=1) 生成ID2: {}", customId2);

        // 2. 不指定参数，使用默认配置（随机生成 workerId，依赖系统环境）
        Snowflake defaultSnowflake = IdUtil.getSnowflake();  // 内部会尝试从系统变量或随机数生成workerId
        long defaultId1 = defaultSnowflake.nextId();
        long defaultId2 = defaultSnowflake.nextId();
        logger.info("默认雪花（自动分配workerId）生成ID1: {}", defaultId1);
        logger.info("默认雪花（自动分配workerId）生成ID2: {}", defaultId2);

        // 3. 批量生成（演示性能，可循环）
        for (int i = 0; i < 5; i++) {
            long batchId = snowflake.nextId();
            logger.info("批量生成[{}]: {}", i, batchId);
        }

        // 4. 验证ID趋势递增（雪花算法保证在同一毫秒内递增）
        long prev = snowflake.nextId();
        for (int i = 0; i < 3; i++) {
            long curr = snowflake.nextId();
            logger.info("递增验证: 前一个={}, 当前={}, 是否递增: {}", prev, curr, curr > prev);
            prev = curr;
        }

        // 建议策略：两者都不要在生产中使用，而应使用带外部化配置的“定制方案”。

        // 提供最佳实践：环境变量/配置中心 + 自定义显式初始化。
    }

    @Test
    public void constantsTest() {

        // TODO: ...

        String md5 = Constants.MD5;

        String at = Constants.AT;

    }

    private static final String PREFIX = "6867";
    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");
    private static final AtomicLong COUNTER = new AtomicLong(0);
    private static final int MACHINE_ID = Integer.getInteger("machine.id", 1); // 默认机器ID=1

    public static String generate() {
        String time = LocalDateTime.now().format(TIME_FORMAT);
        long seq = COUNTER.getAndIncrement() % 100_000_000L; // 8位序列号
        return PREFIX + time + String.format("%02d", MACHINE_ID) + String.format("%08d", seq);
    }

    // 测试
    public static void main(String[] args) {
        for (int i = 0; i < 5; i++) {
            System.out.println(generate());
        }
    }


}
