package cn.realm.cloud.module.system.toolkit;

import cn.realm.cloud.module.system.core.toolkit.FileUtil;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class FileTest {

    private static final Logger logger = LoggerFactory.getLogger(FileTest.class);

    @Test
    public void getAbsolutePathTest() {

        String filePath = FileUtil.getAbsolutePath("static/input.txt");
        logger.info("文件路径: {}", filePath);

    }

}
