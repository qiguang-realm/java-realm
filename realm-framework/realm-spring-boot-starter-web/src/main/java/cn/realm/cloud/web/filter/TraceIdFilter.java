package cn.realm.cloud.web.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.UUID;

/**
 * TraceId 过滤器
 * <p>
 * 职责：
 * <ul>
 *   <li>从请求头提取或生成 TraceId</li>
 *   <li>将 TraceId 放入 MDC，供日志和响应使用</li>
 *   <li>将 TraceId 放入响应头（便于前端或下游调用方获取）</li>
 *   <li>请求结束后清理 MDC，防止线程池复用导致上下文污染</li>
 * </ul>
 *
 * @author QI Guang
 */
@Slf4j
@Component
@Order(Ordered.HIGHEST_PRECEDENCE) // 最高优先级，确保在其他 Filter 之前执行
public class TraceIdFilter implements Filter {

    /**
     * TraceId 的请求头名称（符合 W3C Trace Context 规范）
     */
    private static final String TRACE_ID_HEADER = "X-Trace-Id";

    /**
     * TraceId 在 MDC 中的 key（与日志配置中的 %X{traceId} 对应）
     */
    private static final String TRACE_ID_MDC_KEY = "traceId";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 1. 获取或生成 TraceId
        String traceId = extractTraceId(httpRequest);

        // 2. 放入 MDC
        MDC.put(TRACE_ID_MDC_KEY, traceId);

        // 3. 放入响应头（便于前端或下游调用方获取）
        httpResponse.setHeader(TRACE_ID_HEADER, traceId);

        // 4. 记录入站日志（方便排查）
        if (log.isDebugEnabled()) {
            log.debug(">>> 请求开始: method={}, uri={}, traceId={}",
                    httpRequest.getMethod(),
                    httpRequest.getRequestURI(),
                    traceId);
        }

        try {
            // 5. 继续执行后续过滤器和业务逻辑
            chain.doFilter(request, response);
        } finally {
            // 6. 清理 MDC（关键！防止线程池复用导致 traceId 泄漏）
            MDC.remove(TRACE_ID_MDC_KEY);
            if (log.isDebugEnabled()) {
                log.debug("<<< 请求结束: traceId={}", traceId);
            }
        }
    }

    /**
     * 提取 TraceId（优先级：请求头 > 自动生成）
     *
     * @param request HTTP 请求
     * @return TraceId
     */
    private String extractTraceId(HttpServletRequest request) {
        // 1. 尝试从请求头获取（上游服务传递过来）
        String traceId = request.getHeader(TRACE_ID_HEADER);
        if (StringUtils.hasText(traceId)) {
            return traceId;
        }

        // 2. 尝试从请求参数获取（某些场景如 WebSocket 降级）
        traceId = request.getParameter(TRACE_ID_HEADER);
        if (StringUtils.hasText(traceId)) {
            return traceId;
        }

        // 3. 自动生成（去掉 "-" 缩短长度）
        return UUID.randomUUID().toString().replace("-", "");
    }

}
