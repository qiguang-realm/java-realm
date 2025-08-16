package cn.realm.cloud.module.system;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class SqlGeneratorTest {

    private static final Logger logger = LoggerFactory.getLogger(SqlGeneratorTest.class);

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

    public static void main(String[] args) {
        try {
            List<String> sqlStatements = generateSqlStatements("D:\\qiguang\\workspace\\git_workspace\\java-realm\\java-documentation\\src\\test\\java\\pers\\qiguang\\documentation\\database\\data.json");
            for (String sql : sqlStatements) {
                System.out.println(sql);
                System.out.println();  // 每个SQL语句后加空行，与示例一致
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
