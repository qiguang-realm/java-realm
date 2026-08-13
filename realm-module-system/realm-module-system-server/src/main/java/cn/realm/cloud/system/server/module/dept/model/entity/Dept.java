package cn.realm.cloud.system.server.module.dept.model.entity;

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
 * 部门表
 * </p>
 *
 * @author QI Guang
 */
@Getter
@Setter
@ToString
@TableName("system_dept")
@Schema(name = "Dept", description = "部门表")
public class Dept implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 部门id
     */
    @Schema(description = "部门id")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 部门名称
     */
    @TableField("name")
    @Schema(description = "部门名称")
    private String name;

    /**
     * 父部门id
     */
    @TableField("parent_id")
    @Schema(description = "父部门id")
    private Long parentId;

    /**
     * 显示顺序
     */
    @TableField("sort")
    @Schema(description = "显示顺序")
    private Integer sort;

    /**
     * 负责人
     */
    @Schema(description = "负责人")
    @TableField("leader_user_id")
    private Long leaderUserId;

    /**
     * 联系电话
     */
    @TableField("phone")
    @Schema(description = "联系电话")
    private String phone;

    /**
     * 邮箱
     */
    @TableField("email")
    @Schema(description = "邮箱")
    private String email;

    /**
     * 部门状态（0正常 1停用）
     */
    @TableField("status")
    @Schema(description = "部门状态（0正常 1停用）")
    private Byte status;

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
