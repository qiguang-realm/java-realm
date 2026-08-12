package cn.realm.cloud.system.server.module.menu.model.entity;

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
 * 菜单权限表
 * </p>
 *
 * @author QI Guang
 */
@Getter
@Setter
@ToString
@TableName("system_menu")
@Schema(name = "Menu", description = "菜单权限表")
public class Menu implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 菜单ID
     */
    @Schema(description = "菜单ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 菜单名称
     */
    @TableField("name")
    @Schema(description = "菜单名称")
    private String name;

    /**
     * 权限标识
     */
    @TableField("permission")
    @Schema(description = "权限标识")
    private String permission;

    /**
     * 菜单类型
     */
    @TableField("type")
    @Schema(description = "菜单类型")
    private Byte type;

    /**
     * 显示顺序
     */
    @TableField("sort")
    @Schema(description = "显示顺序")
    private Integer sort;

    /**
     * 父菜单ID
     */
    @TableField("parent_id")
    @Schema(description = "父菜单ID")
    private Long parentId;

    /**
     * 路由地址
     */
    @TableField("path")
    @Schema(description = "路由地址")
    private String path;

    /**
     * 菜单图标
     */
    @TableField("icon")
    @Schema(description = "菜单图标")
    private String icon;

    /**
     * 组件路径
     */
    @TableField("component")
    @Schema(description = "组件路径")
    private String component;

    /**
     * 组件名
     */
    @Schema(description = "组件名")
    @TableField("component_name")
    private String componentName;

    /**
     * 菜单状态
     */
    @TableField("status")
    @Schema(description = "菜单状态")
    private Byte status;

    /**
     * 是否可见
     */
    @TableField("visible")
    @Schema(description = "是否可见")
    private Boolean visible;

    /**
     * 是否缓存
     */
    @TableField("keep_alive")
    @Schema(description = "是否缓存")
    private Boolean keepAlive;

    /**
     * 是否总是显示
     */
    @TableField("always_show")
    @Schema(description = "是否总是显示")
    private Boolean alwaysShow;

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
}
