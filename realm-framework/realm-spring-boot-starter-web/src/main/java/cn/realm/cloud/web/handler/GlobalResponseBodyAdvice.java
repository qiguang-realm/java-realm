package cn.realm.cloud.web.handler;

import cn.realm.cloud.framework.common.base.api.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.core.MethodParameter;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

/**
 * 全局响应体包装器
 * <p>
 * 自动将 Controller 返回的非 ApiResponse 对象包装为统一的 ApiResponse 格式。
 * 对于已经是 ApiResponse 类型的返回值，直接放行，避免重复包装。
 * </p>
 * <p>
 * 使用场景示例：
 * <pre>
 * // Controller 中直接返回业务数据
 * &#64;GetMapping("/user/{id}")
 * public User getUser(@PathVariable Long id) {
 *     return userService.getUserById(id);
 * }
 * // 响应自动被包装为：ApiResponse.success(user)
 * </pre>
 *
 * @author QI Guang
 */
@Slf4j
@RestControllerAdvice
@Order(Ordered.HIGHEST_PRECEDENCE + 1) // 优先级略低于全局异常处理器
public class GlobalResponseBodyAdvice implements ResponseBodyAdvice<Object> {

    /**
     * 判断是否需要对当前返回值进行包装
     * <p>
     * 如果返回值已经是 ApiResponse 类型，则不重复包装。
     * 如果返回值为 void 或 Void，也需要包装为 ApiResponse.success()。
     * </p>
     *
     * @param returnType    方法返回类型
     * @param converterType 消息转换器类型
     * @return true 表示需要包装，false 表示不需要
     */
    @Override
    public boolean supports(MethodParameter returnType,
                            Class<? extends HttpMessageConverter<?>> converterType) {
        Class<?> paramType = returnType.getParameterType();

        // 如果返回类型是 ResponseEntity 或 ApiResponse，不重复包装
        if (ResponseEntity.class.isAssignableFrom(paramType)) {
            return false;
        }
        if (ApiResponse.class.isAssignableFrom(paramType)) {
            return false;
        }

        // 如果返回类型是 String，不包装（避免 StringHttpMessageConverter 问题）
        if (String.class.isAssignableFrom(paramType)) {
            return false;
        }

        return true;

    }

    /**
     * 在响应体写入之前进行包装
     *
     * @param body                  Controller 返回的原始对象
     * @param returnType            方法返回类型
     * @param selectedContentType   选定的内容类型
     * @param selectedConverterType 选定的消息转换器类型
     * @param request               HTTP 请求
     * @param response              HTTP 响应
     * @return 包装后的 ApiResponse 对象
     */
    @Override
    public Object beforeBodyWrite(Object body,
                                  MethodParameter returnType,
                                  MediaType selectedContentType,
                                  Class<? extends HttpMessageConverter<?>> selectedConverterType,
                                  ServerHttpRequest request,
                                  ServerHttpResponse response) {

        // 如果 body 已经是 ApiResponse，直接返回
        if (body instanceof ApiResponse) {
            return body;
        }

        // 从 MDC 获取 traceId
        String traceId = MDC.get("traceId");

        // 如果返回值为 void（即方法返回类型为 void），包装为无数据的成功响应
        if (returnType.getParameterType().equals(void.class) ||
                returnType.getParameterType().equals(Void.class)) {
            return ApiResponse.success().withTraceId(traceId);
        }

        // 如果 body 为 null，包装为无数据的成功响应（例如查询不到数据时返回 null）
        if (body == null) {
            return ApiResponse.success().withTraceId(traceId);
        }

        // 正常包装为成功的 ApiResponse
        return ApiResponse.success(body).withTraceId(traceId);
    }
}
