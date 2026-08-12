package cn.realm.cloud.system.server.module.role.model.entity;

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
 * 角色信息表
 * </p>
 *
 * @author QI Guang
 */
@Getter
@Setter
@ToString
@TableName("system_role")
@Schema(name = "Role", description = "角色信息表")
public class Role implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 角色ID
     */
    @Schema(description = "角色ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 角色名称
     */
    @TableField("name")
    @Schema(description = "角色名称")
    private String name;

    /**
     * 角色权限字符串
     */
    @TableField("code")
    @Schema(description = "角色权限字符串")
    private String code;

    /**
     * 显示顺序
     */
    @TableField("sort")
    @Schema(description = "显示顺序")
    private Integer sort;

    /**
     * 数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）
     */
    @TableField("data_scope")
    @Schema(description = "数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）")
    private Byte dataScope;

    /**
     * 数据范围(指定部门数组)
     */
    @TableField("data_scope_dept_ids")
    @Schema(description = "数据范围(指定部门数组)")
    private String dataScopeDeptIds;

    /**
     * 角色状态（0正常 1停用）
     */
    @TableField("status")
    @Schema(description = "角色状态（0正常 1停用）")
    private Byte status;

    /**
     * 角色类型
     */
    @TableField("type")
    @Schema(description = "角色类型")
    private Byte type;

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
