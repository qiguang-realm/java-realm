package cn.realm.cloud.system.server.util;

import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.util.StreamUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;

/**
 * 模板下载工具类
 *
 * @author QI Guang
 */
public final class TemplateDownloadUtils {
    private static final Logger logger = LoggerFactory.getLogger(TemplateDownloadUtils.class);

    private static final String TEMPLATE_DIR = "/templates/";
    private static final List<String> ALLOWED_TEMPLATES = Arrays.asList(
            "user-template.xlsx",
            "product-template.csv",
            "order-template.xlsx",
            "data-import-template.xls"
    );

    private TemplateDownloadUtils() {
        throw new UnsupportedOperationException("工具类不允许实例化");
    }

    /**
     * 验证文件名是否合法
     */
    public static boolean isValidFileName(String fileName) {
        if (fileName == null) {
            logger.debug("File name is null");
            return false;
        }

        // 防止路径遍历攻击
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            logger.warn("Path traversal attempt detected: {}", fileName);
            return false;
        }

        // 检查是否在允许的模板列表中
        if (!ALLOWED_TEMPLATES.contains(fileName)) {
            logger.warn("Template not in allowed list: {}", fileName);
            return false;
        }

        // 检查文件类型
        if (!fileName.matches("^[a-zA-Z0-9_\\-]+\\.(xlsx|xls|csv)$")) {
            logger.warn("Unsupported file type: {}", fileName);
            return false;
        }

        return true;
    }

    /**
     * 获取模板资源
     */
    public static Resource getTemplateResource(String fileName) {
        if (!isValidFileName(fileName)) {
            throw new IllegalArgumentException("Invalid file name: " + fileName);
        }

        ClassPathResource resource = new ClassPathResource(TEMPLATE_DIR + fileName);
        if (!resource.exists()) {
            throw new RuntimeException("Template not found: " + fileName);
        }

        return resource;
    }

    /**
     * 下载模板文件
     */
    public static void downloadTemplate(String fileName, HttpServletResponse response) throws IOException {
        Resource resource = getTemplateResource(fileName);
        setResponseHeaders(response, fileName);

        try (InputStream inputStream = resource.getInputStream();
             OutputStream outputStream = response.getOutputStream()) {
            StreamUtils.copy(inputStream, outputStream);
        }
    }

    /**
     * 设置响应头
     */
    private static void setResponseHeaders(HttpServletResponse response, String fileName) {
        String encodedFileName = "attachment; filename=\"" + fileName + "\"; " +
                "filename*=UTF-8''" + encodeRFC5987(fileName);

        response.setHeader(HttpHeaders.CONTENT_DISPOSITION, encodedFileName);
        response.setHeader(HttpHeaders.CONTENT_TYPE, getContentType(fileName));
        response.setHeader(HttpHeaders.CACHE_CONTROL, "no-cache, no-store, must-revalidate");
        response.setHeader(HttpHeaders.PRAGMA, "no-cache");
        response.setHeader(HttpHeaders.EXPIRES, "0");
        response.setHeader("Content-Transfer-Encoding", "binary");
    }

    /**
     * 根据文件扩展名获取Content-Type
     */
    private static String getContentType(String fileName) {
        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        switch (extension) {
            case "xlsx":
                return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            case "xls":
                return "application/vnd.ms-excel";
            case "csv":
                return "text/csv";
            default:
                return "application/octet-stream";
        }
    }

    /**
     * RFC 5987编码
     */
    private static String encodeRFC5987(String value) {
        try {
            return URLEncoder.encode(value, StandardCharsets.UTF_8.name())
                    .replace("+", "%20")
                    .replace("*", "%2A")
                    .replace("%7E", "~");
        } catch (UnsupportedEncodingException e) {
            logger.warn("Failed to encode filename: {}", value, e);
            return value;
        }
    }

    /**
     * 获取允许的模板列表
     */
    public static List<String> getAllowedTemplates() {
        return ALLOWED_TEMPLATES;
    }
}
