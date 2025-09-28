package com.alibaba.easyexcel.test.demo.read;

import cn.idev.excel.EasyExcel;
import cn.idev.excel.FastExcelFactory;
import cn.idev.excel.read.listener.PageReadListener;
import com.alibaba.fastjson.JSON;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

/**
 * 读的常见写法
 *
 * @author Qi
 */

@Slf4j
public class ReadTest {

    @Test
    public void simpleRead() {

        // 写法1：JDK8+ ,不用额外写一个DemoDataListener
        // since: 3.0.0-beta1

//        String fileName = "your-file.xlsx";

        String fileName = "D:\\qiguang\\workspace\\git_workspace\\java-realm\\realm-module-system\\realm-module-system-server\\src\\test\\java\\com\\alibaba\\easyexcel\\test\\demo\\write\\demo.xlsx";

        // 这里 需要指定读用哪个class去读，然后读取第一个sheet 文件流会自动关闭
        // 这里默认每次会读取100条数据 然后返回过来 直接调用使用数据就行
        // 具体需要返回多少行可以在`PageReadListener`的构造函数设置

        EasyExcel.read(fileName, DemoData.class, new PageReadListener<DemoData>(dataList -> {
            for (DemoData demoData : dataList) {
                log.info("读取到一条数据{}", JSON.toJSONString(demoData));
                // 这里可以处理数据，比如插入数据库
            }
        })).sheet().doRead();

    }

    @Test
    public void read() {


    }


}
