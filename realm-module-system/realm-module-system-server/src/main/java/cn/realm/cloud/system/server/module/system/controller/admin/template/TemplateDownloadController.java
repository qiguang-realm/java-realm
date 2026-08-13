package cn.realm.cloud.system.server.module.system.controller.admin.template;

import cn.realm.cloud.system.server.common.util.TemplateDownloadUtil;
import cn.realm.cloud.system.server.module.system.service.TemplateDownloadService;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * @author QI Guang
 */
@RestController
@RequestMapping("/system/templates")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class TemplateDownloadController {

    private static final Logger logger = LoggerFactory.getLogger(TemplateDownloadController.class);

    @Autowired
    private TemplateDownloadService templateDownloadService;

    /**
     * 下载默认模板
     */
    @GetMapping("/download/default")
    public void downloadDefaultTemplate(HttpServletResponse response) {
        downloadTemplate("user-template.xlsx", response);
    }

    /**
     * 下载指定模板
     */
    @GetMapping("/download/{fileName}")
    public void downloadTemplate(@PathVariable String fileName, HttpServletResponse response) {
        try {
            templateDownloadService.downloadTemplate(fileName, response);
        } catch (IllegalArgumentException e) {
            logger.warn("Invalid file name requested: {}", fileName, e);
            templateDownloadService.sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid file name");
        } catch (RuntimeException e) {
            logger.warn("Template not found: {}", fileName, e);
            templateDownloadService.sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Template not found");
        } catch (IOException e) {
            logger.error("File download failed: {}", fileName, e);
            templateDownloadService.sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Download failed");
        }
    }

    /**
     * 下载用户导入模板
     */
    @GetMapping("/user-import-template")
    public void downloadUserImportTemplate(HttpServletResponse response) {
        String fileName = "user-template.xlsx";
        try {
            TemplateDownloadUtil.downloadTemplate(fileName, response);
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "用户导入模板下载失败");
        }
    }

    /**
     * 使用 HttpServletResponse（Servlet原生方式）
     *
     * @param response
     */
    @GetMapping("/download")
    public void downloadTemplate(HttpServletResponse response) {
        try {
            // 设置响应头
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"template.xlsx\"");
            response.setCharacterEncoding("UTF-8");

            // 获取模板文件（这里以类路径下的文件为例）
            InputStream inputStream = getClass().getClassLoader().getResourceAsStream("templates/template.xlsx");

            if (inputStream == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "模板文件不存在");
                return;
            }

            // 将文件内容写入响应输出流
            OutputStream outputStream = response.getOutputStream();
            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }

            outputStream.flush();
            inputStream.close();

        } catch (IOException e) {
            throw new RuntimeException("文件下载失败", e);
        }
    }

    /**
     * 获取允许的模板列表
     */
    @GetMapping("/allowed-templates")
    public java.util.List<String> getAllowedTemplates() {
        return templateDownloadService.getAllowedTemplates();
    }
}
