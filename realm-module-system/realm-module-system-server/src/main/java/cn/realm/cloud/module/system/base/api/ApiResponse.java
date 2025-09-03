package cn.realm.cloud.module.system.base.api;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.io.Serializable;

/**
 * 构建服务统一的响应体类
 *
 * @author qig
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ApiResponse<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    private int code;
    private String message;
    private T data;
    private long timestamp;

    public ApiResponse(int code, String message, T data) {
        this.code = code;
        this.message = message != null ? message : "";
        this.data = data;
        this.timestamp = System.currentTimeMillis();
    }

    // 链式调用方法
    public ApiResponse<T> code(int code) {
        this.code = code;
        return this;
    }

    public ApiResponse<T> message(String message) {
        this.message = message;
        return this;
    }

    public ApiResponse<T> data(T data) {
        this.data = data;
        return this;
    }

    // 成功响应方法
    public static <T> ApiResponse<T> success() {
        return new ApiResponse<>(HttpStatus.OK.value(), "操作成功", null);
    }

    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(HttpStatus.OK.value(), "操作成功", data);
    }

    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(HttpStatus.OK.value(), message, data);
    }

    // 错误响应方法
    public static <T> ApiResponse<T> error() {
        return new ApiResponse<>(HttpStatus.INTERNAL_SERVER_ERROR.value(), "操作失败", null);
    }

    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(HttpStatus.INTERNAL_SERVER_ERROR.value(), message, null);
    }

    public static <T> ApiResponse<T> error(int code, String message) {
        return new ApiResponse<>(code, message, null);
    }

    // 常用HTTP状态快捷方法
    public static <T> ApiResponse<T> badRequest(String message) {
        return new ApiResponse<>(HttpStatus.BAD_REQUEST.value(), message, null);
    }

    public static <T> ApiResponse<T> unauthorized(String message) {
        return new ApiResponse<>(HttpStatus.UNAUTHORIZED.value(), message, null);
    }

    public static <T> ApiResponse<T> notFound(String message) {
        return new ApiResponse<>(HttpStatus.NOT_FOUND.value(), message, null);
    }

    public static <T> ApiResponse<T> forbidden(String message) {
        return new ApiResponse<>(HttpStatus.FORBIDDEN.value(), message, null);
    }

    // 转换为ResponseEntity
    public ResponseEntity<ApiResponse<T>> toResponseEntity() {
        return ResponseEntity.status(this.code).body(this);
    }

    public ResponseEntity<ApiResponse<T>> toResponseEntity(HttpStatus status) {
        return ResponseEntity.status(status).body(this);
    }
}
