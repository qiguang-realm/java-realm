package cn.realm.cloud.module.system;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author qig
 */
@Slf4j
@SpringBootApplication
public class SystemServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(SystemServerApplication.class, args);
        log.info("(*^▽^*)启动成功!!!(〃'▽'〃)");
    }

}
