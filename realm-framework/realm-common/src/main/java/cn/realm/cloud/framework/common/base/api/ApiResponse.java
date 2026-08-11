package cn.realm.cloud.framework.common.base.api;

import cn.realm.cloud.framework.common.enums.ResultCode;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AccessLevel;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.io.Serializable;

/**
 * 统一 API 响应体（泛型支持）
 * <p>所有接口返回此结构，保证前后端数据交互的一致性。
 * 业务状态码与 HTTP 状态码解耦，推荐 HTTP 状态始终为 200，业务成功与否由 {@code code} 字段判定。
 *
 * @param <T> 业务数据类型
 * @author QI Guang
 */
@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)  // 供序列化框架使用
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 业务状态码（自定义枚举，例如 200 成功，400 参数错误，500 系统异常）
     */
    private int code;

    /**
     * 提示信息（面向开发或用户的描述）
     */
    private String message;

    /**
     * 业务数据（可为 null）
     */
    private T data;

    /**
     * 响应时间戳（毫秒），由构造器自动生成，禁止外部修改
     */
    @Setter(AccessLevel.NONE)
    private long timestamp;

    // ---------- 私有构造器（强制使用静态工厂） ----------

    /**
     * 全参构造器（私有），用于创建响应对象并自动填充时间戳。
     *
     * @param code    业务状态码
     * @param message 提示信息
     * @param data    业务数据
     */
    private ApiResponse(int code, String message, T data) {
        this.code = code;
        this.message = (message != null) ? message : "";
        this.data = data;
        this.timestamp = System.currentTimeMillis();
    }

    // ---------- 静态工厂方法（成功响应） ----------

    /**
     * 构造一个无数据的成功响应（code=200, message="操作成功"）
     *
     * @param <T> 数据类型
     * @return ApiResponse 对象
     */
    public static <T> ApiResponse<T> success() {
        return new ApiResponse<>(ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), null);
    }

    /**
     * 构造一个带数据的成功响应（code=200, message="操作成功"）
     *
     * @param data 业务数据
     * @param <T>  数据类型
     * @return ApiResponse 对象
     */
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), data);
    }

    /**
     * 构造一个带自定义消息和数据的成功响应（code=200）
     *
     * @param message 自定义成功消息
     * @param data    业务数据
     * @param <T>     数据类型
     * @return ApiResponse 对象
     */
    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(ResultCode.SUCCESS.getCode(), message, data);
    }

    // ---------- 静态工厂方法（错误响应） ----------

    /**
     * 使用预定义的状态码枚举构造错误响应（无数据）
     *
     * @param resultCode 状态码枚举
     * @param <T>        数据类型
     * @return ApiResponse 对象
     */
    public static <T> ApiResponse<T> error(ResultCode resultCode) {
        return new ApiResponse<>(resultCode.getCode(), resultCode.getMessage(), null);
    }

    /**
     * 使用预定义的状态码枚举 + 自定义错误消息构造错误响应（无数据）
     *
     * @param resultCode    状态码枚举
     * @param customMessage 自定义错误描述（覆盖枚举中的默认消息）
     * @param <T>           数据类型
     * @return ApiResponse 对象
     */
    public static <T> ApiResponse<T> error(ResultCode resultCode, String customMessage) {
        return new ApiResponse<>(resultCode.getCode(), customMessage, null);
    }

    /**
     * 直接使用数字状态码和消息构造错误响应（兜底方案，不推荐直接使用，建议使用枚举）
     *
     * @param code    数字状态码
     * @param message 错误描述
     * @param <T>     数据类型
     * @return ApiResponse 对象
     */
    public static <T> ApiResponse<T> error(int code, String message) {
        return new ApiResponse<>(code, message, null);
    }

    /**
     * 完全自定义响应（允许任意 code、message 和 data）
     * <p>适用于需要非标准业务状态码或特殊消息的场景，例如：库存不足（1001）、业务限制（1002）等。
     *
     * @param code    业务状态码（自定义）
     * @param message 提示信息
     * @param data    业务数据（可为 null）
     * @param <T>     数据类型
     * @return ApiResponse 对象
     */
    public static <T> ApiResponse<T> of(int code, String message, T data) {
        return new ApiResponse<>(code, message, data);
    }

    // ---------- 实例方法 ----------

    /**
     * 判断当前响应是否成功（约定 code == 200 为成功）
     *
     * @return true 表示业务处理成功
     */
    public boolean isSuccess() {
        return this.code == 200;
    }

    /**
     * 将当前响应包装为 Spring 的 {@link ResponseEntity}，HTTP 状态固定为 200 OK。
     * <p>推荐使用此方式，让业务状态码完全承载业务结果，符合 RESTful 风格且便于前端统一拦截。
     *
     * @return ResponseEntity 对象，状态 200
     */
    public ResponseEntity<ApiResponse<T>> toResponseEntity() {
        return ResponseEntity.ok(this);
    }

    /**
     * 将当前响应包装为指定 HTTP 状态的 {@link ResponseEntity}。
     * <p>仅当需要利用 HTTP 协议本身的语义（如 404, 500）时使用，否则建议使用默认的 {@link #toResponseEntity()}。
     *
     * @param status HTTP 状态枚举
     * @return ResponseEntity 对象，状态由参数指定
     */
    public ResponseEntity<ApiResponse<T>> toResponseEntity(HttpStatus status) {
        return ResponseEntity.status(status).body(this);
    }
}
