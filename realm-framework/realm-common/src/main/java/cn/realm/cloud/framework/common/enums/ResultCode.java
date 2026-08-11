package cn.realm.cloud.framework.common.enums;

/**
 * 统一响应状态码枚举
 *
 * @author QI Guang
 */
public enum ResultCode {

    // ==================== 枚举值 ====================
    SUCCESS(200, "成功"),
    BAD_REQUEST(400, "请求参数错误"),
    UNAUTHORIZED(401, "未登录或登录已过期"),
    FORBIDDEN(403, "无操作权限"),
    NOT_FOUND(404, "请求资源不存在"),
    INTERNAL_SERVER_ERROR(500, "服务器内部错误");

    // ==================== 字段 ====================
    private final int code;          // int，避免空指针
    private final String message;

    // ==================== 构造方法 ====================
    ResultCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    // ==================== Getter ====================
    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    // ==================== 静态解析方法（借鉴 Spring） ====================

    /**
     * 根据 code 值解析枚举，若不存在则返回 null
     */
    public static ResultCode resolve(int code) {
        for (ResultCode value : values()) {
            if (value.code == code) {
                return value;
            }
        }
        return null;
    }

    /**
     * 根据 code 值解析枚举，若不存在则抛出异常
     */
    public static ResultCode valueOf(int code) {
        ResultCode result = resolve(code);
        if (result == null) {
            throw new IllegalArgumentException("No matching constant for [" + code + "]");
        }
        return result;
    }

    // ==================== 分类判断方法（借鉴 Spring） ====================

    public boolean is2xxSuccess() {
        return this == SUCCESS;  // 当前只有 200 是成功，如扩展可改为 code >= 200 && code < 300
    }

    public boolean is4xxClientError() {
        return code >= 400 && code < 500;
    }

    public boolean is5xxServerError() {
        return code >= 500 && code < 600;
    }

    public boolean isError() {
        return is4xxClientError() || is5xxServerError();
    }

    // ==================== 辅助方法 ====================

    @Override
    public String toString() {
        return code + " " + name();
    }
}
