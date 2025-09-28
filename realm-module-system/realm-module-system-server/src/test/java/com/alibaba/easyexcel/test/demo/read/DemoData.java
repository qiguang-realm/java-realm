package com.alibaba.easyexcel.test.demo.read;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

/**
 * 基础数据类.这里的排序和excel里面的排序一致  https://easyexcel.opensource.alibaba.com/docs/current/quickstart/read
 *
 * @author Qi
 **/
@Getter
@Setter
@EqualsAndHashCode
public class DemoData {
    private String string;
    private Date date;
    private Double doubleData;
}
