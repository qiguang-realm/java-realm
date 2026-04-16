package cn.realm.cloud.module.system.toolkit;

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

        long id = IdWorker.getId();
        logger.info("id:{}", id);

        String timeId = IdWorker.getTimeId();
        logger.info("timeId:{}", timeId);

        long snowflakeNextId = IdUtil.getSnowflakeNextId();
        logger.info("snowflakeNextId:{}", snowflakeNextId);

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
