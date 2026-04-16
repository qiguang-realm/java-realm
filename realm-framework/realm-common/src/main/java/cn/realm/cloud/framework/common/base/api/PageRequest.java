package cn.realm.cloud.framework.common.base.api;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.io.Serializable;

/**
 * 分页请求参数
 *
 * @author Qi
 */
@Data
public class PageRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 默认页码
     */
    public static final int DEFAULT_PAGE_NO = 1;

    /**
     * 默认每页条数
     */
    public static final int DEFAULT_PAGE_SIZE = 10;

    /**
     * 最大每页条数（防止恶意请求过大分页导致性能问题）
     */
    public static final int MAX_PAGE_SIZE = 100;

    /**
     * 不分页标志
     */
    public static final int PAGE_SIZE_NONE = -1;

    /**
     * 当前页码
     */
    @NotNull(message = "页码不能为空")
    @Min(value = 1, message = "页码最小值为 1")
    private Integer pageNum = DEFAULT_PAGE_NO;

    /**
     * 每页条数
     * 当值为 {@link #PAGE_SIZE_NONE} 时表示不分页，查询所有数据
     */
    @NotNull(message = "每页条数不能为空")
    @Min(value = PAGE_SIZE_NONE, message = "每页条数最小值为 " + PAGE_SIZE_NONE)
    @Max(value = MAX_PAGE_SIZE, message = "每页条数最大值为 " + MAX_PAGE_SIZE)
    private Integer pageSize = DEFAULT_PAGE_SIZE;
}
