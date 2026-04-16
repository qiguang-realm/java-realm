package cn.realm.cloud.module.system.json;

import cn.realm.cloud.module.system.util.json.JacksonUtils;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Test cases for Jackson
 */
class JacksonTest {

    private static final String JSON_STRING =
            "{\"BackInfo\":{\"PlateNo\":\"辽CD8828\",\"FileNo\":\"210321030861\",\"AllowNum\":\"2人\"," +
                    "\"TotalMass\":\"--\",\"CurbWeight\":\"9400kg\",\"LoadQuality\":\"--\",\"ExternalSize\":\"7375×2550×3560mm\"," +
                    "\"Marks\":\"强制报废期止:2033-11-20\",\"Record\":\"检验有效期至2019年11月辽C(台安)天然气\"," +
                    "\"TotalQuasiMass\":\"39400kg\"},\"RecognizeWarnCode\":[-9105,-9104]," +
                    "\"RecognizeWarnMsg\":[\"WARN_DRIVER_LICENSE_BLUR\",\"WARN_DRIVER_LICENSE_REFLECTION\"],\"RequestId\":\"26dcae75-1dff-44c3-807f-b15cfd1ddfb6\"}";

    @Test
    public void testNotNull() {
        String value = "Hello";
        assertNotNull(value, "值不应为null");  // 断言+自定义错误消息
    }

    /**
     * 测试JSON字符串解析
     * 用例：从复杂JSON结构中提取字段
     * <p>
     * Test JSON string parsing
     * Case: Extract field from complex JSON structure
     */
    @Test
    public void testParseComplexJson() {
        // 原始JSON字符串（含车辆信息和请求ID）
        // Original JSON string (contains vehicle info and request ID)
        String jsonString = "{\"FrontInfo\":{\"PlateNo\":\"辽CD8828\",\"VehicleType\":\"重型半挂牵引车\","
                + "\"Owner\":\"台安金钵运输有限公司\",\"Address\":\"辽宁省鞍山市台安县富家镇本街\","
                + "\"UseCharacter\":\"货运\",\"Model\":\"陕汽牌SX4258GR384TL\",\"Vin\":\"LZGJLG848JX100098\","
                + "\"EngineNo\":\"3118K049964\",\"RegisterDate\":\"2018-11-20\",\"IssueDate\":\"2018-11-20\","
                + "\"Seal\":\"辽宁省鞍山市公安局交通警察支队\"},\"RecognizeWarnCode\":[],"
                + "\"RecognizeWarnMsg\":[],\"RequestId\":\"6f27e321-9453-445d-bb31-21c303991bde\"}";

        // 使用全局工具类替代临时ObjectMapper（线程安全）
        // Use global utility class instead of temporary ObjectMapper (thread-safe)
        ObjectMapper objectMapper = JacksonUtils.getObjectMapper();

        try {
            // 将JSON字符串解析为树形结构
            // Parse JSON string into tree model
            JsonNode rootNode = objectMapper.readTree(jsonString);

            // 安全获取字段值（不存在时返回null而非抛出异常）
            // Safely get field value (returns null instead of throwing exception if field missing)
            String requestId = rootNode.path("RequestId").asText();  // 注意字段名大小写
            // Note field name case sensitivity

            // 验证结果非空
            // Verify result is not null
            assertNotNull("RequestId should not be null", requestId);

            // 打印结果（实际项目建议使用日志）
            // Print result (logging is recommended in production)
            System.out.println("Extracted RequestId: " + requestId);

        } catch (Exception e) {
            // 实际项目应使用日志记录错误，并考虑自定义异常
            // In production, use logger and consider custom exceptions
            System.err.println("JSON parsing failed: " + e.getMessage());
            throw new RuntimeException("JSON parsing failed", e);  // 使测试失败
            // Fail the test
        }
    }

    @Test
    public void testExtractPlateNoSafely() {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode rootNode = mapper.readTree(JSON_STRING);

            // 方案1：严格模式（推荐）
            String plateNo = Optional.ofNullable(rootNode)
                    .map(node -> node.get("BackInfo"))
                    .map(info -> info.get("PlateNo"))  // 精确匹配字段名
                    .map(JsonNode::asText)
                    .orElse("未知车牌");


            assertAll(
                    () -> assertEquals("辽CD8828", plateNo, "精确匹配失败")
            );
        } catch (Exception e) {
            fail("JSON解析失败: " + e.getMessage());
        }
    }
}
