package cn.realm.cloud.web.handler;

import cn.realm.cloud.framework.common.base.api.ApiResponse;
import cn.realm.cloud.framework.common.enums.ErrorCode;
import cn.realm.cloud.web.exception.BusinessException;
import com.fasterxml.jackson.databind.exc.InvalidFormatException;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.stream.Collectors;

/**
 * 全局异常处理器
 *
 * @author QI Guang
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    // ==================== 业务异常 ====================

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(BusinessException e) {
        log.warn("业务异常: code={}, message={}", e.getErrorCode().getCode(), e.getDisplayMessage(), e);
        return buildErrorResponse(e.getErrorCode(), e.getDisplayMessage());
    }

    // ==================== Spring Security 认证/授权异常 ====================

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiResponse<Void>> handleAccessDenied(AccessDeniedException e) {
        log.warn("无权限访问: {}", e.getMessage());
        return buildErrorResponse(ErrorCode.AUTH_FORBIDDEN, ErrorCode.AUTH_FORBIDDEN.getMessage());
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ApiResponse<Void>> handleAuthentication(AuthenticationException e) {
        log.warn("未认证: {}", e.getMessage());
        return buildErrorResponse(ErrorCode.AUTH_UNAUTHORIZED, ErrorCode.AUTH_UNAUTHORIZED.getMessage());
    }

    // ==================== 参数校验异常（@Valid 实体类校验） ====================

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleMethodArgumentNotValid(MethodArgumentNotValidException e) {
        String errorMsg = e.getBindingResult().getFieldErrors().stream()
                .map(f -> f.getField() + ": " + f.getDefaultMessage())
                .collect(Collectors.joining("; "));
        log.warn("参数校验失败: {}", errorMsg);
        return buildErrorResponse(ErrorCode.PARAM_INVALID, errorMsg);
    }

    // ==================== 参数校验异常（@Validated 方法参数校验） ====================

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleConstraintViolation(ConstraintViolationException e) {
        String errorMsg = e.getConstraintViolations().stream()
                .map(ConstraintViolation::getMessage)
                .collect(Collectors.joining("; "));
        log.warn("约束校验失败: {}", errorMsg);
        return buildErrorResponse(ErrorCode.PARAM_INVALID, errorMsg);
    }

    // ==================== 参数绑定异常（@RequestParam 绑定失败） ====================

    @ExceptionHandler(BindException.class)
    public ResponseEntity<ApiResponse<Void>> handleBindException(BindException e) {
        String errorMsg = e.getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining("; "));
        log.warn("参数绑定失败: {}", errorMsg);
        return buildErrorResponse(ErrorCode.PARAM_INVALID, errorMsg);
    }

    // ==================== 缺少请求参数 ====================

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ApiResponse<Void>> handleMissingParam(MissingServletRequestParameterException e) {
        log.warn("缺少必要参数: {}", e.getParameterName());
        String msg = "缺少必要参数: " + e.getParameterName();
        return buildErrorResponse(ErrorCode.MISSING_PARAM, msg);
    }

    // ==================== 参数类型不匹配（如 String -> Long 转换失败） ====================

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ApiResponse<Void>> handleTypeMismatch(MethodArgumentTypeMismatchException e) {
        log.warn("参数类型不匹配: 参数 '{}' 应为类型 '{}'，实际值: '{}'",
                e.getName(), e.getRequiredType() != null ? e.getRequiredType().getSimpleName() : "未知", e.getValue());
        String msg = String.format("参数 '%s' 类型错误，期望 %s", e.getName(),
                e.getRequiredType() != null ? e.getRequiredType().getSimpleName() : "未知");
        return buildErrorResponse(ErrorCode.PARAM_INVALID, msg);
    }

    // ==================== 请求体解析失败（JSON 格式错误） ====================

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiResponse<Void>> handleHttpMessageNotReadable(HttpMessageNotReadableException e) {
        log.warn("请求体解析失败", e);
        String msg = "请求体格式错误";
        // 如果是由 InvalidFormatException 引起的，可提取具体字段信息
        if (e.getCause() instanceof InvalidFormatException) {
            InvalidFormatException ife = (InvalidFormatException) e.getCause();
            if (ife.getPath() != null && !ife.getPath().isEmpty()) {
                String field = ife.getPath().get(0).getFieldName();
                msg = String.format("字段 '%s' 格式错误，期望类型: %s", field, ife.getTargetType().getSimpleName());
            }
        }
        return buildErrorResponse(ErrorCode.PARAM_INVALID, msg);
    }

    // ==================== HTTP 方法不支持 ====================

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ApiResponse<Void>> handleMethodNotSupported(HttpRequestMethodNotSupportedException e) {
        log.warn("不支持的HTTP方法: {}", e.getMethod());
        return buildErrorResponse(ErrorCode.METHOD_NOT_ALLOWED, "不支持的HTTP方法: " + e.getMethod());
    }

    // ==================== 媒体类型不支持 ====================

    @ExceptionHandler(HttpMediaTypeNotSupportedException.class)
    public ResponseEntity<ApiResponse<Void>> handleMediaTypeNotSupported(HttpMediaTypeNotSupportedException e) {
        log.warn("不支持的媒体类型: {}", e.getContentType());
        return buildErrorResponse(ErrorCode.MEDIA_TYPE_UNSUPPORTED, "不支持的媒体类型: " + e.getContentType());
    }

    // ==================== 404 未找到（如果启用了 ThrowExceptionIfNoHandlerFound） ====================

    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleNoHandlerFound(NoHandlerFoundException e) {
        log.warn("请求路径不存在: {}", e.getRequestURL());
        return buildErrorResponse(ErrorCode.PARAM_INVALID, "请求路径不存在: " + e.getRequestURL());
    }

    // ==================== 其他未捕获异常（兜底） ====================

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleException(Exception e) {
        log.error("系统内部异常", e);
        return buildErrorResponse(ErrorCode.SYSTEM_ERROR, ErrorCode.SYSTEM_ERROR.getMessage());
    }

    // ==================== 私有辅助方法 ====================

    /**
     * 构建错误响应并自动注入 traceId（从 MDC 获取）
     *
     * @param errorCode 错误码枚举
     * @param message   错误消息（如果为 null，则使用 errorCode 的默认消息）
     * @return ResponseEntity 包装的 ApiResponse
     */
    private ResponseEntity<ApiResponse<Void>> buildErrorResponse(ErrorCode errorCode, String message) {
        String traceId = MDC.get("traceId");
        ApiResponse<Void> response = ApiResponse.<Void>error(errorCode, message)
                .withTraceId(traceId);
        return response.toResponseEntity();
    }
}
