package cn.realm.cloud.framework.common.base.api;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Map;

/**
 * 将 ApiResponse<T> 与 Spring 的 ResponseEntity<T> 结合可以充分利用两者的优势：ApiResponse 提供统一的响应格式，ResponseEntity 提供更灵活的 HTTP 响应控制。
 *
 * @author qig
 */
public class ResponseBuilder {

    /**
     * 构建成功响应
     */
    public static <T> ResponseEntity<ApiResponse<T>> success(T data) {
        ApiResponse<T> response = ApiResponse.success(data);
        return ResponseEntity.ok(response);
    }

    /**
     * 构建成功响应（无数据）
     */
    public static <T> ResponseEntity<ApiResponse<T>> success() {
        ApiResponse<T> response = ApiResponse.success();
        return ResponseEntity.ok(response);
    }

    /**
     * 构建成功响应（自定义消息）
     */
    public static <T> ResponseEntity<ApiResponse<T>> success(String message, T data) {
        ApiResponse<T> response = ApiResponse.success(message, data);
        return ResponseEntity.ok(response);
    }

    /**
     * 构建错误响应
     */
    public static <T> ResponseEntity<ApiResponse<T>> error(String message) {
        ApiResponse<T> response = ApiResponse.error(message);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }

    /**
     * 构建错误响应（自定义状态码）
     */
    public static <T> ResponseEntity<ApiResponse<T>> error(int code, String message) {
        ApiResponse<T> response = ApiResponse.error(code, message);
        HttpStatus status = HttpStatus.valueOf(code);
        return ResponseEntity.status(status).body(response);
    }

    /**
     * 构建错误响应（使用HTTP状态枚举）
     */
    public static <T> ResponseEntity<ApiResponse<T>> error(HttpStatus status, String message) {
        ApiResponse<T> response = ApiResponse.error(status.value(), message);
        return ResponseEntity.status(status).body(response);
    }

    /**
     * 构建自定义响应
     */
    public static <T> ResponseEntity<ApiResponse<T>> of(HttpStatus status, String message, T data) {
        ApiResponse<T> response = new ApiResponse<>(status.value(), message, data);
        return ResponseEntity.status(status).body(response);
    }

    /**
     * 构建分页响应
     */
//    public static <T> ResponseEntity<ApiResponse<PageResponse<T>>> page(
//            com.baomidou.mybatisplus.extension.plugins.pagination.Page<T> page) {
//        PageResponse<T> pageResponse = PageResponse.from(page);
//        ApiResponse<PageResponse<T>> response = ApiResponse.success(pageResponse);
//        return ResponseEntity.ok(response);
//    }

    /**
     * 构建带HTTP头的响应
     */
    public static <T> ResponseEntity<ApiResponse<T>> withHeaders(
            ApiResponse<T> response, HttpHeaders headers) {
        return ResponseEntity.ok().headers(headers).body(response);
    }

    /**
     * 构建带自定义头的响应
     */
    public static <T> ResponseEntity<ApiResponse<T>> withHeaders(
            ApiResponse<T> response, Map<String, String> headersMap) {
        HttpHeaders headers = new HttpHeaders();
        headersMap.forEach(headers::add);
        return ResponseEntity.ok().headers(headers).body(response);
    }
}
