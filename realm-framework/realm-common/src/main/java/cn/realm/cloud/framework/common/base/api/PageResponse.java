package cn.realm.cloud.framework.common.base.api;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Collections;
import java.util.List;

/**
 * 与 MyBatis Plus 的兼容性，又提供了清晰的分页响应结构
 *
 * @author qig
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageResponse<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    // 分页数据列表
    private List<T> records = Collections.emptyList();

    // 总记录数
    private long total;

    // 每页显示条数
    private long size;

    // 当前页
    private long current;

    // 总页数
    private long pages;

    // 是否有上一页
    private boolean hasPrevious;

    // 是否有下一页
    private boolean hasNext;

    /**
     * 从 MyBatis Plus Page 对象构建分页响应
     */
//    public static <T> PageResponse<T> from(com.baomidou.mybatisplus.extension.plugins.pagination.Page<T> page) {
//        PageResponse<T> response = new PageResponse<>();
//        response.setRecords(page.getRecords());
//        response.setTotal(page.getTotal());
//        response.setSize(page.getSize());
//        response.setCurrent(page.getCurrent());
//        response.setPages(calculateTotalPages(page.getTotal(), page.getSize()));
//        response.setHasPrevious(page.getCurrent() > 1);
//        response.setHasNext(page.getCurrent() < response.getPages());
//        return response;
//    }

    /**
     * 计算总页数
     */
    private static long calculateTotalPages(long total, long size) {
        if (size == 0) {
            return 0;
        }
        return (total + size - 1) / size;
    }

    /**
     * 空分页响应
     */
    public static <T> PageResponse<T> empty() {
        PageResponse<T> response = new PageResponse<>();
        response.setPages(0);
        response.setHasPrevious(false);
        response.setHasNext(false);
        return response;
    }
}
