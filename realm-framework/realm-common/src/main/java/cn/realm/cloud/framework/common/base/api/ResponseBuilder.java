package cn.realm.cloud.framework.common.base.api;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Map;

/**
 * 响应构建器（Builder），用于快速构建带有 {@link ApiResponse} 体的 {@link ResponseEntity}。
 *
 * <p>将统一响应体与 Spring HTTP 响应对象结合，既保留了业务状态码的独立性，
 * 又能灵活控制 HTTP 状态、Headers 等底层传输细节。
 *
 * <p>推荐在 Controller 层使用本构建器替代直接构造 ResponseEntity，
 * 以保持代码风格统一、减少重复代码。
 *
 * @author QI Guang
 * @see ApiResponse
 * @see ResponseEntity
 */
public final class ResponseBuilder {

    // ==================== 成功响应 ====================

    /**
     * 构建一个 HTTP 200 的成功响应，携带业务数据。
     *
     * @param data 业务数据（可为 null，但建议有值）
     * @param <T>  数据类型
     * @return ResponseEntity 包裹的 ApiResponse，状态码 200 OK
     */
    public static <T> ResponseEntity<ApiResponse<T>> success(T data) {
        return ResponseEntity.ok(ApiResponse.success(data));
    }

    /**
     * 构建一个 HTTP 200 的成功响应，不带业务数据。
     *
     * @param <T> 数据类型（通常为 Void）
     * @return ResponseEntity 包裹的 ApiResponse，状态码 200 OK
     */
    public static <T> ResponseEntity<ApiResponse<T>> success() {
        return ResponseEntity.ok(ApiResponse.success());
    }

    /**
     * 构建一个 HTTP 200 的成功响应，携带自定义消息和业务数据。
     *
     * @param message 自定义成功消息（会覆盖默认的“操作成功”）
     * @param data    业务数据
     * @param <T>     数据类型
     * @return ResponseEntity 包裹的 ApiResponse，状态码 200 OK
     */
    public static <T> ResponseEntity<ApiResponse<T>> success(String message, T data) {
        return ResponseEntity.ok(ApiResponse.success(message, data));
    }

    // ==================== 错误响应 ====================

    /**
     * 构建一个 HTTP 500 的服务器内部错误响应，使用默认的 500 状态码和自定义错误消息。
     *
     * @param message 错误描述（会设置到 ApiResponse.message 中）
     * @param <T>     数据类型（通常为 Void）
     * @return ResponseEntity 包裹的 ApiResponse，状态码 500 INTERNAL_SERVER_ERROR
     */
    public static <T> ResponseEntity<ApiResponse<T>> error(String message) {
        ApiResponse<T> response = ApiResponse.error(HttpStatus.INTERNAL_SERVER_ERROR.value(), message);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }

    /**
     * 构建一个错误响应，同时指定业务状态码和 HTTP 状态码（两者取相同的数值）。
     *
     * <p>注意：如果传入的 code 不是标准的 HTTP 状态码（如 1001），
     * 该方法会回退到 HTTP 500，避免抛出异常。
     *
     * @param code    业务状态码（同时尝试作为 HTTP 状态码）
     * @param message 错误描述
     * @param <T>     数据类型（通常为 Void）
     * @return ResponseEntity 包裹的 ApiResponse
     */
    public static <T> ResponseEntity<ApiResponse<T>> error(int code, String message) {
        ApiResponse<T> response = ApiResponse.error(code, message);
        // 安全解析 HTTP 状态码，非标准值自动回退到 500
        HttpStatus status = HttpStatus.resolve(code);
        if (status == null) {
            status = HttpStatus.INTERNAL_SERVER_ERROR;
        }
        return ResponseEntity.status(status).body(response);
    }

    /**
     * 构建一个错误响应，使用指定的 HttpStatus 枚举和自定义消息。
     *
     * @param status  HTTP 状态枚举（如 HttpStatus.NOT_FOUND）
     * @param message 错误描述
     * @param <T>     数据类型（通常为 Void）
     * @return ResponseEntity 包裹的 ApiResponse，状态码为 status
     */
    public static <T> ResponseEntity<ApiResponse<T>> error(HttpStatus status, String message) {
        ApiResponse<T> response = ApiResponse.error(status.value(), message);
        return ResponseEntity.status(status).body(response);
    }

    // ==================== 完全自定义响应 ====================

    /**
     * 构建一个完全自定义的响应，允许自由指定 HTTP 状态、业务状态码（与 HTTP 状态码一致）、消息和业务数据。
     *
     * <p>此方法适用于需要返回非标准业务码且希望与 HTTP 状态码保持一致的场景。
     * 若业务码与 HTTP 状态码需要完全解耦，请直接使用 {@link #custom(HttpStatus, int, String, Object)}。
     *
     * @param status  HTTP 状态枚举
     * @param message 提示信息
     * @param data    业务数据（可为 null）
     * @param <T>     数据类型
     * @return ResponseEntity 包裹的 ApiResponse
     */
    public static <T> ResponseEntity<ApiResponse<T>> of(HttpStatus status, String message, T data) {
        ApiResponse<T> response = ApiResponse.of(status.value(), message, data);
        return ResponseEntity.status(status).body(response);
    }

    /**
     * 构建一个完全自定义的响应，支持业务状态码与 HTTP 状态码完全解耦。
     *
     * <p>例如：HTTP 状态返回 200，但业务状态码为 1001（库存不足）。
     *
     * @param httpStatus   HTTP 状态枚举（决定响应头中的状态行）
     * @param businessCode 业务状态码（写入 ApiResponse.code）
     * @param message      提示信息
     * @param data         业务数据（可为 null）
     * @param <T>          数据类型
     * @return ResponseEntity 包裹的 ApiResponse
     */
    public static <T> ResponseEntity<ApiResponse<T>> custom(HttpStatus httpStatus, int businessCode,
                                                            String message, T data) {
        ApiResponse<T> response = ApiResponse.of(businessCode, message, data);
        return ResponseEntity.status(httpStatus).body(response);
    }

    // ==================== 分页响应（示例，按需启用） ====================

    // 注：PageResponse 需另行定义，此处仅示意
    /*
    public static <T> ResponseEntity<ApiResponse<PageResponse<T>>> page(Page<T> page) {
        PageResponse<T> pageResponse = PageResponse.from(page);
        ApiResponse<PageResponse<T>> response = ApiResponse.success(pageResponse);
        return ResponseEntity.ok(response);
    }
    */

    // ==================== 带自定义 HTTP 头的响应 ====================

    /**
     * 在已有 ApiResponse 基础上添加 HTTP 头，并返回 HTTP 200 OK。
     *
     * @param response 已构建的 ApiResponse 对象
     * @param headers  Spring HttpHeaders 对象
     * @param <T>      数据类型
     * @return ResponseEntity 包裹的 ApiResponse，状态码 200 OK
     */
    public static <T> ResponseEntity<ApiResponse<T>> withHeaders(ApiResponse<T> response, HttpHeaders headers) {
        return ResponseEntity.ok().headers(headers).body(response);
    }

    /**
     * 在已有 ApiResponse 基础上添加自定义键值对形式的 HTTP 头，并返回 HTTP 200 OK。
     *
     * @param response   已构建的 ApiResponse 对象
     * @param headersMap 头信息的键值对（如果值为 null，将被忽略）
     * @param <T>        数据类型
     * @return ResponseEntity 包裹的 ApiResponse，状态码 200 OK
     */
    public static <T> ResponseEntity<ApiResponse<T>> withHeaders(ApiResponse<T> response,
                                                                 Map<String, String> headersMap) {
        HttpHeaders headers = new HttpHeaders();
        if (headersMap != null) {
            headersMap.forEach((key, value) -> {
                if (value != null) {
                    headers.add(key, value);
                }
            });
        }
        return ResponseEntity.ok().headers(headers).body(response);
    }

    // 私有构造，防止实例化
    private ResponseBuilder() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated");
    }
}
