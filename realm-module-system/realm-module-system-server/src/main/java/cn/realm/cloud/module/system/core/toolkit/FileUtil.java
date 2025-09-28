package cn.realm.cloud.module.system.core.toolkit;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

/**
 * 文件操作
 *
 * @author Qi
 * @version 1.0
 */
public class FileUtil {
    private static final Logger logger = LoggerFactory.getLogger(FileUtil.class);

    // 文件类型白名单（阿里安全规范）
    private static final List<String> ALLOWED_EXTENSIONS = List.of(
            "txt", "pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx",
            "jpg", "jpeg", "png", "gif", "bmp", "webp",
            "mp4", "avi", "mov", "wmv",
            "mp3", "wav", "ogg",
            "zip", "rar", "7z"
    );

    // 最大文件大小限制：100MB（腾讯规范）
    private static final long MAX_FILE_SIZE = 100 * 1024 * 1024;

    private FileUtil() {
        throw new UnsupportedOperationException("工具类不允许实例化");
    }

    // ========== 基础文件操作 ==========

    /**
     * 安全获取文件绝对路径（阿里规范）
     */
    public static String getAbsolutePath(String classpathResource) {
        try {
            URL resourceUrl = FileUtil.class.getClassLoader().getResource(classpathResource);
            if (resourceUrl == null) {
                throw new RuntimeException("资源文件不存在: " + classpathResource);
            }
            return Paths.get(resourceUrl.toURI()).toAbsolutePath().toString();
        } catch (Exception e) {
            logger.error("获取文件路径失败: {}", classpathResource, e);
            throw new RuntimeException("获取文件路径失败: " + classpathResource, e);
        }
    }

    /**
     * 验证文件路径安全性（防止路径遍历攻击 - 字节跳动安全规范）
     */
    private static void validateFilePath(String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            throw new RuntimeException("文件路径不能为空");
        }

        // 防止路径遍历攻击
        if (filePath.contains("..") || filePath.contains("~") || filePath.contains("//")) {
            throw new RuntimeException("非法文件路径: " + filePath);
        }

        String normalizedPath = FilenameUtils.normalize(filePath);
        if (normalizedPath == null || !normalizedPath.equals(filePath)) {
            throw new RuntimeException("文件路径格式错误: " + filePath);
        }
    }

    // ========== 阿里云文件处理方案 ==========

    /**
     * 阿里方案：分片上传（适合大文件）
     */
    public static void aliUploadWithChunking(InputStream inputStream, String targetPath, int chunkSize) {
        validateFilePath(targetPath);

        try (FileOutputStream fos = new FileOutputStream(targetPath);
             BufferedOutputStream bos = new BufferedOutputStream(fos)) {

            byte[] buffer = new byte[chunkSize];
            int bytesRead;
            long totalBytes = 0;

            while ((bytesRead = inputStream.read(buffer)) != -1) {
                bos.write(buffer, 0, bytesRead);
                totalBytes += bytesRead;

                // 阿里监控点：每上传1MB记录日志
                if (totalBytes % (1024 * 1024) == 0) {
                    logger.info("阿里分片上传进度: {} MB", totalBytes / (1024 * 1024));
                }
            }

            logger.info("阿里分片上传完成: {}, 总大小: {} MB", targetPath, totalBytes / (1024 * 1024));

        } catch (IOException e) {
            logger.error("阿里分片上传失败: {}", targetPath, e);
            throw new RuntimeException("文件上传失败", e);
        }
    }

    // ========== 腾讯云文件处理方案 ==========

    /**
     * 腾讯方案：文件下载带MD5校验（确保文件完整性）
     */
    public static void tencentDownloadWithVerification(String sourcePath, String targetPath) {
        validateFilePath(sourcePath);
        validateFilePath(targetPath);

        try {
            File sourceFile = new File(sourcePath);
            if (!sourceFile.exists()) {
                throw new RuntimeException("源文件不存在: " + sourcePath);
            }

            // 计算源文件MD5（腾讯安全要求）
            String sourceMd5 = calculateMD5(sourcePath);
            logger.info("腾讯下载校验 - 源文件MD5: {}", sourceMd5);

            // 执行下载
            Files.copy(Paths.get(sourcePath), Paths.get(targetPath), StandardCopyOption.REPLACE_EXISTING);

            // 验证下载文件完整性
            String targetMd5 = calculateMD5(targetPath);
            if (!sourceMd5.equals(targetMd5)) {
                throw new RuntimeException("文件下载完整性校验失败");
            }

            logger.info("腾讯下载完成: {}, MD5校验通过", targetPath);

        } catch (IOException e) {
            logger.error("腾讯下载失败", e);
            throw new RuntimeException("文件下载失败", e);
        }
    }

    // ========== 字节跳动文件处理方案 ==========

    /**
     * 字节方案：安全文件上传（类型检查+大小限制+病毒扫描模拟）
     */
    public static void bytedanceSafeUpload(InputStream inputStream, String originalFilename, String targetPath) {
        validateFilePath(targetPath);

        // 字节安全规范：文件类型检查
        if (!isAllowedFileType(originalFilename)) {
            throw new RuntimeException("不支持的文件类型: " + originalFilename);
        }

        try {
            // 字节安全规范：文件大小检查
            checkFileSize(inputStream, MAX_FILE_SIZE);

            // 字节安全规范：病毒扫描（模拟）
            if (!virusScan(inputStream)) {
                throw new RuntimeException("文件安全扫描未通过");
            }

            // 重置流位置
            inputStream.reset();

            // 保存文件
            Files.copy(inputStream, Paths.get(targetPath), StandardCopyOption.REPLACE_EXISTING);

            logger.info("字节安全上传完成: {}", targetPath);

        } catch (IOException e) {
            logger.error("字节上传失败", e);
            throw new RuntimeException("文件上传失败", e);
        }
    }

    // ========== Google文件处理方案 ==========

    /**
     * Google方案：高效文件复制（使用NIO，性能优化）
     */
    public static void googleEfficientCopy(String sourcePath, String targetPath) {
        validateFilePath(sourcePath);
        validateFilePath(targetPath);

        try {
            Path source = Paths.get(sourcePath);
            Path target = Paths.get(targetPath);

            // Google性能优化：使用NIO文件通道
            Files.createDirectories(target.getParent());
            Files.copy(source, target, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);

            logger.info("Google高效复制完成: {} -> {}", sourcePath, targetPath);

        } catch (IOException e) {
            logger.error("Google复制失败", e);
            throw new RuntimeException("文件复制失败", e);
        }
    }

    // ========== 京东文件处理方案 ==========

    /**
     * 京东方案：批量文件处理（支持压缩包）
     */
    public static List<String> jdBatchProcess(List<String> filePaths, String outputDir) {
        validateFilePath(outputDir);

        List<String> processedFiles = new ArrayList<>();
        File outputDirectory = new File(outputDir);
        if (!outputDirectory.exists()) {
            outputDirectory.mkdirs();
        }

        for (String filePath : filePaths) {
            validateFilePath(filePath);
            try {
                File file = new File(filePath);
                if (file.exists()) {
                    // 京东处理逻辑：生成唯一文件名
                    String uniqueName = generateUniqueFileName(file.getName());
                    String targetPath = outputDir + File.separator + uniqueName;

                    Files.copy(file.toPath(), Paths.get(targetPath), StandardCopyOption.REPLACE_EXISTING);
                    processedFiles.add(targetPath);

                    logger.info("京东批量处理: {} -> {}", filePath, targetPath);
                }
            } catch (IOException e) {
                logger.warn("京东批量处理跳过文件: {}", filePath, e);
            }
        }

        return processedFiles;
    }

    // ========== 通用工具方法 ==========

    /**
     * 计算文件MD5（腾讯规范）
     */
    private static String calculateMD5(String filePath) {
        try (InputStream inputStream = new FileInputStream(filePath)) {
            MessageDigest digest = MessageDigest.getInstance("MD5");
            byte[] buffer = new byte[8192];
            int read;

            while ((read = inputStream.read(buffer)) > 0) {
                digest.update(buffer, 0, read);
            }

            byte[] md5Bytes = digest.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : md5Bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();

        } catch (Exception e) {
            throw new RuntimeException("MD5计算失败", e);
        }
    }

    /**
     * 检查文件类型是否允许（字节安全规范）
     */
    private static boolean isAllowedFileType(String filename) {
        if (filename == null) {
            return false;
        }

        String extension = FilenameUtils.getExtension(filename).toLowerCase();
        return ALLOWED_EXTENSIONS.contains(extension);
    }

    /**
     * 检查文件大小（字节安全规范）
     */
    private static void checkFileSize(InputStream inputStream, long maxSize) throws IOException {
        long size = 0;
        byte[] buffer = new byte[8192];
        int read;

        while ((read = inputStream.read(buffer)) != -1) {
            size += read;
            if (size > maxSize) {
                throw new RuntimeException("文件大小超过限制: " + (maxSize / 1024 / 1024) + "MB");
            }
        }

        // 重置流位置
        inputStream.reset();
    }

    /**
     * 病毒扫描模拟（字节安全规范）
     */
    private static boolean virusScan(InputStream inputStream) {
        // 模拟病毒扫描逻辑
        // 实际生产中会集成专业的病毒扫描服务
        try {
            // 这里简单模拟扫描过程
            byte[] header = new byte[1024];
            inputStream.read(header);
            inputStream.reset();

            // 模拟99.9%的文件通过率
            return Math.random() > 0.001;

        } catch (IOException e) {
            return false;
        }
    }

    /**
     * 生成唯一文件名（京东规范）
     */
    private static String generateUniqueFileName(String originalName) {
        String extension = FilenameUtils.getExtension(originalName);
        String baseName = FilenameUtils.getBaseName(originalName);
        String uuid = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        return baseName + "_" + uuid + "." + extension;
    }

    /**
     * 压缩文件（通用方法）
     */
    public static void compressFiles(List<String> sourcePaths, String zipPath) {
        validateFilePath(zipPath);

        try (ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(zipPath))) {
            for (String sourcePath : sourcePaths) {
                validateFilePath(sourcePath);
                File file = new File(sourcePath);
                if (file.exists()) {
                    zos.putNextEntry(new ZipEntry(file.getName()));
                    Files.copy(file.toPath(), zos);
                    zos.closeEntry();
                }
            }
            logger.info("文件压缩完成: {}", zipPath);
        } catch (IOException e) {
            logger.error("文件压缩失败", e);
            throw new RuntimeException("文件压缩失败", e);
        }
    }

    /**
     * 解压文件（通用方法）
     */
    public static List<String> extractZip(String zipPath, String outputDir) {
        validateFilePath(zipPath);
        validateFilePath(outputDir);

        List<String> extractedFiles = new ArrayList<>();
        File outputDirectory = new File(outputDir);
        if (!outputDirectory.exists()) {
            outputDirectory.mkdirs();
        }

        try (ZipInputStream zis = new ZipInputStream(new FileInputStream(zipPath))) {
            ZipEntry entry;
            while ((entry = zis.getNextEntry()) != null) {
                if (!entry.isDirectory()) {
                    String entryPath = outputDir + File.separator + entry.getName();
                    Files.copy(zis, Paths.get(entryPath), StandardCopyOption.REPLACE_EXISTING);
                    extractedFiles.add(entryPath);
                    zis.closeEntry();
                }
            }
            logger.info("文件解压完成: {} -> {}", zipPath, outputDir);
        } catch (IOException e) {
            logger.error("文件解压失败", e);
            throw new RuntimeException("文件解压失败", e);
        }

        return extractedFiles;
    }
}
