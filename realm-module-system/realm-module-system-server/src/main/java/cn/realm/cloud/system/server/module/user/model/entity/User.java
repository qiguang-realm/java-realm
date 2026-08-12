package cn.realm.cloud.system.server.module.user.model.entity;

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
 * 用户信息表
 * </p>
 *
 * @author QI Guang
 */
@Getter
@Setter
@ToString
@TableName("system_user")
@Schema(name = "User", description = "用户信息表")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 用户ID
     */
    @Schema(description = "用户ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 用户账号
     */
    @TableField("username")
    @Schema(description = "用户账号")
    private String username;

    /**
     * 密码
     */
    @TableField("password")
    @Schema(description = "密码")
    private String password;

    /**
     * 用户昵称
     */
    @TableField("nickname")
    @Schema(description = "用户昵称")
    private String nickname;

    /**
     * 备注
     */
    @TableField("remark")
    @Schema(description = "备注")
    private String remark;

    /**
     * 部门ID
     */
    @TableField("dept_id")
    @Schema(description = "部门ID")
    private Long deptId;

    /**
     * 岗位编号数组
     */
    @TableField("post_ids")
    @Schema(description = "岗位编号数组")
    private String postIds;

    /**
     * 用户邮箱
     */
    @TableField("email")
    @Schema(description = "用户邮箱")
    private String email;

    /**
     * 手机号码
     */
    @TableField("mobile")
    @Schema(description = "手机号码")
    private String mobile;

    /**
     * 用户性别
     */
    @TableField("sex")
    @Schema(description = "用户性别")
    private Byte sex;

    /**
     * 头像地址
     */
    @TableField("avatar")
    @Schema(description = "头像地址")
    private String avatar;

    /**
     * 帐号状态（0正常 1停用）
     */
    @TableField("status")
    @Schema(description = "帐号状态（0正常 1停用）")
    private Byte status;

    /**
     * 最后登录IP
     */
    @TableField("login_ip")
    @Schema(description = "最后登录IP")
    private String loginIp;

    /**
     * 最后登录时间
     */
    @TableField("login_date")
    @Schema(description = "最后登录时间")
    private LocalDateTime loginDate;

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
