package cn.realm.cloud.system.server.module.post.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * <p>
 * 岗位信息表
 * </p>
 *
 * @author QI Guang
 */
@Getter
@Setter
@ToString
@TableName("system_post")
@Schema(name = "Post", description = "岗位信息表")
public class Post implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 岗位ID
     */
    @Schema(description = "岗位ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 岗位编码
     */
    @TableField("code")
    @Schema(description = "岗位编码")
    private String code;

    /**
     * 岗位名称
     */
    @TableField("name")
    @Schema(description = "岗位名称")
    private String name;

    /**
     * 显示顺序
     */
    @TableField("sort")
    @Schema(description = "显示顺序")
    private Integer sort;

    /**
     * 状态（0正常 1停用）
     */
    @TableField("status")
    @Schema(description = "状态（0正常 1停用）")
    private Byte status;

    /**
     * 备注
     */
    @TableField("remark")
    @Schema(description = "备注")
    private String remark;

    /**
     * 创建者
     */
    @TableField("creator")
    @Schema(description = "创建者")
    private String creator;

    /**
     * 创建时间
     */
    @TableField("create_time")
    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    /**
     * 更新者
     */
    @TableField("updater")
    @Schema(description = "更新者")
    private String updater;

    /**
     * 更新时间
     */
    @TableField("update_time")
    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

    /**
     * 是否删除
     */
    @TableField("deleted")
    @Schema(description = "是否删除")
    private Boolean deleted;

    /**
     * 租户编号
     */
    @TableField("tenant_id")
    @Schema(description = "租户编号")
    private Long tenantId;
}
