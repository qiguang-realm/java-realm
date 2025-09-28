package cn.realm.cloud.module.system.core.toolkit;

import cn.idev.excel.FastExcelFactory;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * 文件读取
 *
 * @author qiguang
 * @version 1.0
 */
public class FileReaderUtil {
    private static final Logger logger = LoggerFactory.getLogger(FileReaderUtil.class);
    // https://stackoverflow.com/questions/309424/how-do-i-read-convert-an-inputstream-into-a-string-in-java
    // https://stackoverflow.com/questions/4716503/reading-a-plain-text-file-in-java

    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB限制
    private static final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 通用方法：安全读取文件内容为字符串
     */
    public static String readFileAsString(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);

        String extension = getFileExtension(filePath).toLowerCase();

        switch (extension) {
            case "txt":
                return readTextFileInternal(path);
            case "json":
                return readJsonFileAsStringInternal(path);
            case "csv":
                return readCsvFileAsStringInternal(path);
            case "xlsx":
            case "xls":
                return readExcelAsStringInternal(path);
            default:
                throw new IllegalArgumentException("Unsupported file format: " + extension);
        }
    }

    /**
     * 通用方法：读取文件内容为字符串列表
     */
    public static List<String> readFileAsLines(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);

        String extension = getFileExtension(filePath).toLowerCase();

        switch (extension) {
            case "txt":
                return readTextFileLinesInternal(path);
            case "csv":
                return readCsvAsLinesInternal(path);
            case "xlsx":
            case "xls":
                return readExcelAsLinesInternal(path);
            case "json":
                return List.of(readJsonFileAsStringInternal(path));
            default:
                throw new IllegalArgumentException("Unsupported file format: " + extension);
        }
    }

    // ==================== 单独的文件读取方法 ====================

    /**
     * 单独方法：读取文本文件为字符串
     */
    public static String readTxtFile(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateFileExtension(path, "txt");
        return readTextFileInternal(path);
    }

    /**
     * 单独方法：读取文本文件为行列表
     */
    public static List<String> readTxtFileLines(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateFileExtension(path, "txt");
        return readTextFileLinesInternal(path);
    }

    /**
     * 单独方法：读取JSON文件为字符串
     */
    public static String readJsonFileAsString(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateFileExtension(path, "json");
        return readTextFileInternal(path);
    }

    /**
     * 单独方法：读取JSON文件为JsonNode对象
     */
    public static JsonNode readJsonFile(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateFileExtension(path, "json");

        String jsonContent = readTextFileInternal(path);
        return objectMapper.readTree(jsonContent);
    }

    /**
     * 单独方法：读取JSON文件为指定类型的对象
     */
    public static <T> T readJsonFile(String filePath, Class<T> valueType) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateFileExtension(path, "json");

        String jsonContent = readTextFileInternal(path);
        return objectMapper.readValue(jsonContent, valueType);
    }

    /**
     * 单独方法：读取CSV文件为字符串
     */
    public static String readCsvFileAsString(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateFileExtension(path, "csv");
        return readCsvFileAsStringInternal(path);
    }

    /**
     * 单独方法：读取CSV文件为行列表
     */
    public static List<String> readCsvFileAsLines(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateFileExtension(path, "csv");
        return readCsvAsLinesInternal(path);
    }

    /**
     * 单独方法：读取CSV文件为记录列表（每行作为List<String>）
     */
    public static List<List<String>> readCsvFileAsRecords(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateFileExtension(path, "csv");

        List<List<String>> records = new ArrayList<>();

        try (Reader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8);
             CSVParser csvParser = new CSVParser(reader, CSVFormat.DEFAULT)) {

            for (CSVRecord record : csvParser) {
                List<String> recordList = new ArrayList<>();
                for (int i = 0; i < record.size(); i++) {
                    recordList.add(record.get(i));
                }
                records.add(recordList);
            }
        }

        return records;
    }

    /**
     * 单独方法：读取Excel文件为字符串
     */
    public static String readExcelFileAsString(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateExcelExtension(path);
        return readExcelAsStringInternal(path);
    }

    /**
     * 单独方法：读取Excel文件为行列表
     */
    public static List<String> readExcelFileAsLines(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateExcelExtension(path);
        return readExcelAsLinesInternal(path);
    }

    /**
     * 单独方法：读取Excel文件指定工作表为行列表
     */
    public static List<String> readExcelFileAsLines(String filePath, int sheetIndex) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateExcelExtension(path);

        List<String> result = new ArrayList<>();

        try (InputStream inputStream = Files.newInputStream(path);
             Workbook workbook = createWorkbook(inputStream, filePath)) {

            Sheet sheet = workbook.getSheetAt(sheetIndex);
            Iterator<Row> rowIterator = sheet.iterator();

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                StringBuilder rowBuilder = new StringBuilder();

                Iterator<Cell> cellIterator = row.cellIterator();
                while (cellIterator.hasNext()) {
                    Cell cell = cellIterator.next();
                    rowBuilder.append(getCellValueAsString(cell));

                    if (cellIterator.hasNext()) {
                        rowBuilder.append(",");
                    }
                }

                result.add(rowBuilder.toString());
            }
        }

        return result;
    }

    /**
     * 单独方法：读取Excel文件为表格数据（二维列表）
     */
    public static List<List<String>> readExcelFileAsTable(String filePath, int sheetIndex) throws IOException {
        Path path = Paths.get(filePath);
        validateFile(path);
        validateExcelExtension(path);

        List<List<String>> table = new ArrayList<>();

        try (InputStream inputStream = Files.newInputStream(path);
             Workbook workbook = createWorkbook(inputStream, filePath)) {

            Sheet sheet = workbook.getSheetAt(sheetIndex);
            Iterator<Row> rowIterator = sheet.iterator();

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                List<String> rowData = new ArrayList<>();

                Iterator<Cell> cellIterator = row.cellIterator();
                while (cellIterator.hasNext()) {
                    Cell cell = cellIterator.next();
                    rowData.add(getCellValueAsString(cell));
                }

                table.add(rowData);
            }
        }

        return table;
    }

    /**
     * 单独方法：读取Excel文件第一个工作表为表格数据
     */
    public static List<List<String>> readExcelFileAsTable(String filePath) throws IOException {
        return readExcelFileAsTable(filePath, 0);
    }

    // ==================== 私有辅助方法（全部重命名避免冲突）====================

    private static String readTextFileInternal(Path path) throws IOException {
        return Files.readString(path, StandardCharsets.UTF_8);
    }

    private static List<String> readTextFileLinesInternal(Path path) throws IOException {
        return Files.readAllLines(path, StandardCharsets.UTF_8);
    }

    private static String readJsonFileAsStringInternal(Path path) throws IOException {
        return readTextFileInternal(path);
    }

    private static String readCsvFileAsStringInternal(Path path) throws IOException {
        List<String> lines = readCsvAsLinesInternal(path);
        return String.join("\n", lines);
    }

    private static List<String> readCsvAsLinesInternal(Path path) throws IOException {
        List<String> result = new ArrayList<>();

        try (Reader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8);
             CSVParser csvParser = new CSVParser(reader, CSVFormat.DEFAULT)) {

            for (CSVRecord record : csvParser) {
                result.add(String.join(",", record));
            }
        }

        return result;
    }

    private static String readExcelAsStringInternal(Path path) throws IOException {
        List<String> lines = readExcelAsLinesInternal(path);
        return String.join("\n", lines);
    }

    private static List<String> readExcelAsLinesInternal(Path path) throws IOException {
        return readExcelFileAsLines(path.toString(), 0);
    }

    private static void validateFile(Path path) throws IOException {
        if (!Files.exists(path)) {
            throw new FileNotFoundException("File not found: " + path);
        }

        if (!Files.isReadable(path)) {
            throw new SecurityException("File is not readable: " + path);
        }

        long fileSize = Files.size(path);
        if (fileSize > MAX_FILE_SIZE) {
            throw new IOException("File size exceeds limit: " + fileSize + " bytes");
        }
    }

    private static void validateFileExtension(Path path, String expectedExtension) {
        String actualExtension = getFileExtension(path.toString()).toLowerCase();
        if (!actualExtension.equals(expectedExtension.toLowerCase())) {
            throw new IllegalArgumentException("Expected " + expectedExtension +
                    " file but got: " + actualExtension);
        }
    }

    private static void validateExcelExtension(Path path) {
        String extension = getFileExtension(path.toString()).toLowerCase();
        if (!extension.equals("xlsx") && !extension.equals("xls")) {
            throw new IllegalArgumentException("Expected Excel file but got: " + extension);
        }
    }

    private static String getCellValueAsString(Cell cell) {
        if (cell == null) {
            return "";
        }

        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                } else {
                    return String.valueOf(cell.getNumericCellValue());
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                return cell.getCellFormula();
            case BLANK:
                return "";
            default:
                return "";
        }
    }

    private static Workbook createWorkbook(InputStream inputStream, String fileName) throws IOException {
        if (fileName.toLowerCase().endsWith(".xlsx")) {
            return new XSSFWorkbook(inputStream);
        } else if (fileName.toLowerCase().endsWith(".xls")) {
            return new HSSFWorkbook(inputStream);
        } else {
            throw new IllegalArgumentException("Unsupported Excel format: " + fileName);
        }
    }

    private static String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex == -1) {
            return "";
        }
        return fileName.substring(lastDotIndex + 1);
    }

    /**
     * 验证JSON格式
     */
    public static boolean isValidJson(String jsonString) {
        try {
            objectMapper.readTree(jsonString);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 验证JSON文件格式
     */
    public static boolean isValidJsonFile(String filePath) {
        try {
            String jsonContent = readJsonFileAsString(filePath);
            return isValidJson(jsonContent);
        } catch (Exception e) {
            return false;
        }
    }

    public static <T> List<T> read(MultipartFile file, Class<T> head) throws IOException {
        return FastExcelFactory.read(file.getInputStream(), head, null)
                .autoCloseStream(false)  // 不要自动关闭，交给 Servlet 自己处理
                .doReadAllSync();
    }

}
