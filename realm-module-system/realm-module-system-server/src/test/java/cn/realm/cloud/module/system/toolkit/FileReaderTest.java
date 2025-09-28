package cn.realm.cloud.module.system.toolkit;

import cn.idev.excel.FastExcelFactory;
import cn.realm.cloud.module.system.core.toolkit.FileReaderUtil;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

public class FileReaderTest {

    private static final Logger logger = LoggerFactory.getLogger(FileReaderTest.class);

    /**
     * 测试读取文本文件
     */
    public static void testReadTxtFile() {
        String filePath = "D:\\qiguang\\workspace\\git_workspace\\java-realm\\realm-module-system\\realm-module-system-server\\src\\main\\resources\\static\\sensitive_words.txt";
        try {
            logger.info("=== 测试读取文本文件 ===");

            // 1. 读取文本文件为字符串
            String txtContent = FileReaderUtil.readTxtFile(filePath);
//            String txtContent = FileReaderUtil.readTxtFile("data.txt");
            logger.info("文本文件内容（前200字符）: {}",
                    txtContent.length() > 200 ? txtContent.substring(0, 200) + "..." : txtContent);

            // 2. 读取文本文件为行列表
            List<String> txtLines = FileReaderUtil.readTxtFileLines(filePath);
//            List<String> txtLines = FileReaderUtil.readTxtFileLines("data.txt");
            logger.info("文本文件行数: {}", txtLines.size());

            if (!txtLines.isEmpty()) {
                logger.info("第一行内容: {}", txtLines.get(0));
            }

            logger.info("文本文件读取测试成功！\n");

        } catch (Exception e) {
            logger.error("文本文件读取测试失败", e);
        }
    }

    @Test
    public void readTxtFileTest() {

        testReadTxtFile();

    }

    /**
     * 测试读取JSON文件
     */
    public static void testReadJsonFile() {
        try {
            logger.info("=== 测试读取JSON文件 ===");

            // 1. 读取JSON文件为字符串
            String jsonString = FileReaderUtil.readJsonFileAsString("data.json");
            logger.info("JSON文件内容（前200字符）: {}",
                    jsonString.length() > 200 ? jsonString.substring(0, 200) + "..." : jsonString);

            // 2. 读取JSON文件为JsonNode对象
            JsonNode jsonNode = FileReaderUtil.readJsonFile("data.json");
            logger.info("JSON节点类型: {}", jsonNode.getNodeType());

            // 3. 验证JSON格式
            boolean isValid = FileReaderUtil.isValidJsonFile("data.json");
            logger.info("JSON格式验证: {}", isValid ? "有效" : "无效");

            logger.info("JSON文件读取测试成功！\n");

        } catch (Exception e) {
            logger.error("JSON文件读取测试失败", e);
        }
    }

    /**
     * 测试读取CSV文件
     */
    public static void testReadCsvFile() {
        try {
            logger.info("=== 测试读取CSV文件 ===");

            // 1. 读取CSV文件为字符串
            String csvContent = FileReaderUtil.readCsvFileAsString("data.csv");
            logger.info("CSV文件内容（前200字符）: {}",
                    csvContent.length() > 200 ? csvContent.substring(0, 200) + "..." : csvContent);

            // 2. 读取CSV文件为行列表
            List<String> csvLines = FileReaderUtil.readCsvFileAsLines("data.csv");
            logger.info("CSV文件行数: {}", csvLines.size());

            if (!csvLines.isEmpty()) {
                logger.info("第一行内容: {}", csvLines.get(0));
            }

            // 3. 读取CSV文件为记录列表
            List<List<String>> csvRecords = FileReaderUtil.readCsvFileAsRecords("data.csv");
            logger.info("CSV记录数: {}", csvRecords.size());

            if (!csvRecords.isEmpty() && !csvRecords.get(0).isEmpty()) {
                logger.info("第一个记录的第一个字段: {}", csvRecords.get(0).get(0));
            }

            logger.info("CSV文件读取测试成功！\n");

        } catch (Exception e) {
            logger.error("CSV文件读取测试失败", e);
        }
    }

    /**
     * 测试读取Excel文件
     */
    public static void testReadExcelFile() {
        try {
            logger.info("=== 测试读取Excel文件 ===");

            // 1. 读取Excel文件为字符串
            String excelContent = FileReaderUtil.readExcelFileAsString("data.xlsx");
            logger.info("Excel文件内容（前200字符）: {}",
                    excelContent.length() > 200 ? excelContent.substring(0, 200) + "..." : excelContent);

            // 2. 读取Excel文件为行列表
            List<String> excelLines = FileReaderUtil.readExcelFileAsLines("data.xlsx");
            logger.info("Excel文件行数: {}", excelLines.size());

            if (!excelLines.isEmpty()) {
                logger.info("第一行内容: {}", excelLines.get(0));
            }

            // 3. 读取Excel文件为表格数据
            List<List<String>> excelTable = FileReaderUtil.readExcelFileAsTable("data.xlsx");
            logger.info("Excel表格行数: {}", excelTable.size());

            if (!excelTable.isEmpty() && !excelTable.get(0).isEmpty()) {
                logger.info("第一个单元格内容: {}", excelTable.get(0).get(0));
            }

            // 4. 测试读取指定工作表
            try {
                List<String> sheet1Lines = FileReaderUtil.readExcelFileAsLines("data.xlsx", 0);
                logger.info("工作表1行数: {}", sheet1Lines.size());

                if (sheet1Lines.size() > 1) {
                    List<List<String>> sheet2Table = FileReaderUtil.readExcelFileAsTable("data.xlsx", 1);
                    logger.info("工作表2行数: {}", sheet2Table.size());
                }
            } catch (Exception e) {
                logger.info("多工作表测试跳过（可能只有一个工作表）");
            }

            logger.info("Excel文件读取测试成功！\n");

        } catch (Exception e) {
            logger.error("Excel文件读取测试失败", e);
        }
    }

    /**
     * 测试通用文件读取方法
     */
    public static void testGenericFileReading() {
        try {
            logger.info("=== 测试通用文件读取方法 ===");

            // 测试通用方法读取各种文件
            String[] testFiles = {"data.txt", "data.json", "data.csv", "data.xlsx"};

            for (String file : testFiles) {
                try {
                    String content = FileReaderUtil.readFileAsString(file);
                    List<String> lines = FileReaderUtil.readFileAsLines(file);

                    logger.info("文件: {}", file);
                    logger.info("  内容长度: {}", content.length());
                    logger.info("  行数: {}", lines.size());

                    if (!lines.isEmpty()) {
                        logger.info("  第一行预览: {}",
                                lines.get(0).length() > 50 ? lines.get(0).substring(0, 50) + "..." : lines.get(0));
                    }

                } catch (Exception e) {
                    logger.warn("文件 {} 读取失败: {}", file, e.getMessage());
                }
                logger.info("");
            }

            logger.info("通用文件读取测试完成！\n");

        } catch (Exception e) {
            logger.error("通用文件读取测试失败", e);
        }
    }

    /**
     * 测试错误处理
     */
    public static void testErrorHandling() {
        try {
            logger.info("=== 测试错误处理 ===");

            // 测试不存在的文件
            try {
                FileReaderUtil.readTxtFile("nonexistent.txt");
                logger.error("错误：应该抛出文件不存在异常");
            } catch (FileNotFoundException e) {
                logger.info("✓ 正确处理了文件不存在的情况");
            } catch (Exception e) {
                logger.warn("文件不存在测试出现意外异常: {}", e.getMessage());
            }

            // 测试不支持的文件格式
            try {
                FileReaderUtil.readTxtFile("image.jpg");
                logger.error("错误：应该抛出不支持格式异常");
            } catch (IllegalArgumentException e) {
                logger.info("✓ 正确处理了不支持的文件格式");
            } catch (Exception e) {
                logger.warn("文件格式测试出现意外异常: {}", e.getMessage());
            }

            // 测试空文件
            try {
                List<String> lines = FileReaderUtil.readTxtFileLines("empty.txt");
                logger.info("空文件行数: {}", lines.size());
            } catch (Exception e) {
                logger.info("空文件处理: {}", e.getMessage());
            }

            // 测试大文件限制
            try {
                // 创建一个临时的大文件进行测试（需要实际有大文件时使用）
                // FileReaderUtil.readTxtFile("large_file.txt");
                logger.info("大文件限制测试需要实际有大文件");
            } catch (Exception e) {
                logger.info("大文件限制处理: {}", e.getMessage());
            }

            logger.info("错误处理测试完成！\n");

        } catch (Exception e) {
            logger.error("错误处理测试失败", e);
        }
    }

    /**
     * 测试性能
     */
    public static void testPerformance() {
        try {
            logger.info("=== 测试性能 ===");

            String testFile = "data.txt";
            int iterations = 5;

            long totalTime = 0;
            for (int i = 0; i < iterations; i++) {
                long startTime = System.currentTimeMillis();

                String content = FileReaderUtil.readFileAsString(testFile);
                List<String> lines = FileReaderUtil.readFileAsLines(testFile);

                long endTime = System.currentTimeMillis();
                long duration = endTime - startTime;
                totalTime += duration;

                logger.info("第 {} 次读取 - 耗时: {}ms, 内容长度: {}, 行数: {}",
                        i + 1, duration, content.length(), lines.size());
            }

            double averageTime = (double) totalTime / iterations;
            logger.info("平均读取耗时: {}ms", String.format("%.2f", averageTime));
            logger.info("性能测试完成！\n");

        } catch (Exception e) {
            logger.error("性能测试失败", e);
        }
    }

    /**
     * 运行所有测试
     */
    public static void runAllTests() {
        logger.info("开始运行所有文件读取测试...\n");

        testReadTxtFile();
        testReadJsonFile();
        testReadCsvFile();
        testReadExcelFile();
        testGenericFileReading();
        testErrorHandling();
        testPerformance();

        logger.info("所有测试运行完成！");
    }

    /**
     * 主方法 - 可以选择运行单个测试或所有测试
     */
    public static void main(String[] args) {
        if (args.length > 0) {
            // 根据参数运行特定测试
            switch (args[0].toLowerCase()) {
                case "txt":
                    testReadTxtFile();
                    break;
                case "json":
                    testReadJsonFile();
                    break;
                case "csv":
                    testReadCsvFile();
                    break;
                case "excel":
                    testReadExcelFile();
                    break;
                case "generic":
                    testGenericFileReading();
                    break;
                case "error":
                    testErrorHandling();
                    break;
                case "performance":
                    testPerformance();
                    break;
                default:
                    runAllTests();
            }
        } else {
            // 默认运行所有测试
            runAllTests();
        }
    }

    public static List<String> generateSqlStatements(String jsonFilePath) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        List<String> sqlStatements = new ArrayList<>();

        JsonNode rootNode = mapper.readTree(new File(jsonFilePath));

        if (rootNode.isArray()) {
            for (JsonNode node : rootNode) {
                // 获取必填字段
                String code = node.get("code").asText();
                String name = node.get("name").asText();
                String pinyin = node.get("pinyin").asText();
                String zipCode = node.get("zip_code").asText();
                int type = node.get("type").asInt();
                String firstLetter = node.get("first_letter").asText();

                // 处理可选的parent_code字段
                String parentCode = "NULL";
                if (node.has("parent_code") && !node.get("parent_code").isNull()) {
                    parentCode = "'" + node.get("parent_code").asText() + "'";
                }

                // 构建完全匹配示例格式的SQL语句
                String sql = String.format(
                        "INSERT INTO kyc_administrative_division (code, name, pinyin, zip_code, parent_code, type, first_letter) %n" +
                                "VALUES ('%s', '%s', '%s', '%s', %s, %d, '%s');",
                        code, name, pinyin, zipCode, parentCode, type, firstLetter
                );

                sqlStatements.add(sql);
            }
        }

        return sqlStatements;
    }

    @Test
    public void generateSqlStatementsTest() {
        // "尝试获取名为'data.file.path'的系统属性，
        // 如果找不到，就使用默认路径"
        String jsonFilePath = System.getProperty("data.file.path",
                "src/main/resources/static/data.json");

        Path jsonPath = Paths.get(jsonFilePath);
        Path outputPath = jsonPath.getParent().resolve("output.txt");

        try {
            List<String> sqlStatements = generateSqlStatements(jsonFilePath);

            Files.createDirectories(outputPath.getParent());

            try (BufferedWriter writer = Files.newBufferedWriter(outputPath,
                    StandardCharsets.UTF_8, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING)) {

                for (int i = 0; i < sqlStatements.size(); i++) {
                    writer.write(sqlStatements.get(i));
                    writer.newLine();
                    if (i < sqlStatements.size() - 1) {
                        writer.newLine();
                    }
                }
            }

            // 使用logger输出
            logger.info("SQL输出文件: {}", outputPath.toAbsolutePath());
            logger.info("成功生成 {} 条SQL语句", sqlStatements.size());

        } catch (IOException e) {
            logger.error("生成SQL语句失败 - 文件路径: {}", jsonFilePath, e);
            throw new RuntimeException("Failed to generate SQL: " + e.getMessage(), e);
        }
    }



}
