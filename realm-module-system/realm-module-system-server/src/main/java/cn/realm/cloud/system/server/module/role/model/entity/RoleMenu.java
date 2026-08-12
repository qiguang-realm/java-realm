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
 * 角色和菜单关联表
 * </p>
 *
 * @author QI Guang
 */
@Getter
@Setter
@ToString
@TableName("system_role_menu")
@Schema(name = "RoleMenu", description = "角色和菜单关联表")
public class RoleMenu implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 自增编号
     */
    @Schema(description = "自增编号")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 角色ID
     */
    @TableField("role_id")
    @Schema(description = "角色ID")
    private Long roleId;

    /**
     * 菜单ID
     */
    @TableField("menu_id")
    @Schema(description = "菜单ID")
    private Long menuId;

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
