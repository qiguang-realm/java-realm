package pers.qiguang.documentation;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * On Java 8
 * https://github.com/BruceEckel/OnJava8-Examples
 *
 * @author qig
 * @since 2022-09-19
 **/
@SpringBootApplication
//@MapperScan("pers.qiguang.documentation.mapper")  //@MapperScan 注解，扫描 Mapper 文件夹
public class JavaPlatformApplication {
    public static void main(String[] args) {
        SpringApplication.run(JavaPlatformApplication.class, args);
    }
}
