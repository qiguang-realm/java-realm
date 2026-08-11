package cn.realm.cloud.gateway;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 网关服务启动类
 *
 * @author QI Guang
 */
@SpringBootApplication
public class GatewayServerApplication {
    private static final Logger logger = LoggerFactory.getLogger(GatewayServerApplication.class);

    public static void main(String[] args) {
        SpringApplication.run(GatewayServerApplication.class, args);
        logger.info("(*^▽^*)网关启动成功!!!(〃'▽'〃)");
    }

}
