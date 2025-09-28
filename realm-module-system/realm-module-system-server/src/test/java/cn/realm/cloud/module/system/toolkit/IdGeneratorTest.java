package cn.realm.cloud.module.system.toolkit;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.toolkit.Constants;
import com.baomidou.mybatisplus.core.toolkit.IdWorker;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class IdGeneratorTest {
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


}
