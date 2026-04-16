package cn.realm.cloud.gateway.handler;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.cloud.gateway.support.NotFoundException;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * 全局网关异常处理器
 * <p>
 * 统一处理 Spring Cloud Gateway 中的所有异常，返回结构化的 JSON 错误响应。
 * 基于 WebFlux 响应式编程模型，传统的 @ControllerAdvice 无法在此生效。
 * <p>
 * 通过 @Order(-1) 提高优先级，确保在默认的 ErrorWebExceptionHandler 之前执行。
 *
 * @author qig
 */
@Slf4j
@Configuration
@Order(-1)  // 设置最高优先级，优先于默认的异常处理器
public class CustomGlobalExceptionHandler implements ErrorWebExceptionHandler {

    // ObjectMapper 是线程安全的，使用 static final 重用，避免重复创建开销
    private static final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 处理异常的主方法
     *
     * @param exchange 当前请求的上下文，包含 request/response 等信息
     * @param ex       捕获到的异常
     * @return Mono<Void> 响应式返回，表示处理完成
     */
    @Override
    public Mono<Void> handle(ServerWebExchange exchange, Throwable ex) {
        ServerHttpResponse response = exchange.getResponse();
        // 设置响应内容类型为 JSON
        response.getHeaders().setContentType(MediaType.APPLICATION_JSON);

        // 根据异常类型确定 HTTP 状态码
        HttpStatusCode status = determineHttpStatusCode(ex);
        response.setStatusCode(status);

        // 构建安全且统一的错误响应体（避免直接暴露异常堆栈信息）
        Map<String, Object> result = buildErrorResponse(ex, status, exchange);

        // 将响应对象序列化为 JSON 字节流
        byte[] bytes = safeSerializeToBytes(result);
        DataBuffer buffer = response.bufferFactory().wrap(bytes);

        // 记录完整的异常信息（仅在需要时，生产环境可调整日志级别）
        log.error("网关异常发生：path={}, status={}, message={}",
                exchange.getRequest().getURI().getPath(),
                status.value(),
                ex.getMessage(),
                ex);  // 将异常对象传入，可打印完整堆栈

        // 返回响应
        return response.writeWith(Mono.just(buffer));
    }

    /**
     * 根据异常类型确定合适的 HTTP 状态码
     *
     * @param ex 异常对象
     * @return HttpStatusCode 状态码（可以是 HttpStatus 枚举或其他实现）
     */
    private HttpStatusCode determineHttpStatusCode(Throwable ex) {
        if (ex instanceof NotFoundException) {
            // 路由未找到，返回 404
            return HttpStatus.NOT_FOUND;
        } else if (ex instanceof ResponseStatusException) {
            // 直接使用 ResponseStatusException 中携带的状态码
            return ((ResponseStatusException) ex).getStatusCode();
        } else {
            // 其他未预期的异常，统一返回 500
            return HttpStatus.INTERNAL_SERVER_ERROR;
        }
    }

    /**
     * 构建安全的错误响应体
     * <p>
     * 不直接返回 ex.getMessage()，避免泄露敏感信息（如 SQL 异常、文件路径等）。
     * 可根据异常类型返回更友好的提示，或统一返回通用错误信息。
     *
     * @param ex       原始异常
     * @param status   最终确定的 HTTP 状态码
     * @param exchange 请求上下文
     * @return 包含错误信息的 Map
     */
    private Map<String, Object> buildErrorResponse(Throwable ex, HttpStatusCode status, ServerWebExchange exchange) {
        Map<String, Object> result = new HashMap<>(4);
        result.put("code", status.value());
        result.put("path", exchange.getRequest().getURI().getPath());

        // 根据异常类型或状态码返回更友好的消息
        if (status.is4xxClientError()) {
            // 客户端错误，可返回异常消息（但仍需过滤敏感信息）
            result.put("message", safeGetErrorMessage(ex));
        } else {
            // 服务器内部错误，统一返回模糊提示，不暴露内部细节
            result.put("message", "服务器内部错误，请稍后重试");
            // 可选：添加一个请求追踪 ID，方便运维定位（可结合 MDC 实现）
            // result.put("traceId", MDC.get("traceId"));
        }

        return result;
    }

    /**
     * 安全地获取异常消息
     * <p>
     * 防止 ex.getMessage() 返回 null 或包含敏感词。
     *
     * @param ex 异常对象
     * @return 安全的消息字符串
     */
    private String safeGetErrorMessage(Throwable ex) {
        String msg = ex.getMessage();
        if (msg == null || msg.isBlank()) {
            return "请求处理失败";
        }
        // 可根据需要过滤敏感关键词，例如：password, secret 等
        // 此处简单返回原消息（可根据实际安全要求加强过滤）
        return msg;
    }

    /**
     * 安全地将对象序列化为 JSON 字节数组
     * <p>
     * 如果序列化失败，返回一个备用 JSON 字符串的字节数组，确保始终能返回有效响应。
     *
     * @param obj 需要序列化的对象
     * @return JSON 字节数组
     */
    private byte[] safeSerializeToBytes(Object obj) {
        try {
            return objectMapper.writeValueAsBytes(obj);
        } catch (JsonProcessingException e) {
            // 序列化失败（极少数情况，如循环引用），记录错误并返回一个简单的错误 JSON
            log.error("响应序列化失败，返回默认错误信息", e);
            return "{\"code\":500,\"message\":\"服务内部错误\"}".getBytes(StandardCharsets.UTF_8);
        }
    }
}
