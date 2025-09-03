package cn.realm.cloud.module.system.util.json;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Jackson JSON工具类（线程安全，不可变）
 * 提供高效、安全的JSON序列化与反序列化方法，支持泛型、复杂集合类型。
 * 优化异常处理，避免在工具类中抛出Checked Exception，提供返回默认值的重载方法。
 *
 * @author qig
 */
public final class JacksonUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(JacksonUtils.class);
    private static final ObjectMapper OBJECT_MAPPER = createDefaultObjectMapper();
    // 可选：用于缓存TypeReference或JavaType，提升反复解析同一泛型类型的性能
    private static final Map<Type, JavaType> JAVA_TYPE_CACHE = new ConcurrentHashMap<>(64);

    private JacksonUtils() {
        throw new IllegalStateException("JacksonUtils工具类不允许实例化");
    }

    private static ObjectMapper createDefaultObjectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        // 反序列化时，忽略JSON字符串中存在而Java对象中没有的属性
        mapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
        // 序列化时，忽略空Bean
        mapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);
        // 序列化时，日期不转换为时间戳（使用JavaTimeModule后，默认会以数组形式存储，此配置可使其以字符串形式存储，更可读）
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        // 序列化时，只包含非NULL的属性
        mapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        // 允许解析JSON注释（根据需求可选，默认禁用）
        mapper.configure(JsonParser.Feature.ALLOW_COMMENTS, true);
        // 允许解析单引号字符串（根据需求可选，默认禁用）
        // mapper.configure(JsonParser.Feature.ALLOW_SINGLE_QUOTES, true);
        // 允许解析非引号字段名（根据需求可选，默认禁用，不建议开启）
        // mapper.configure(JsonParser.Feature.ALLOW_UNQUOTED_FIELD_NAMES, true);
        // 注册Java 8时间模块
        mapper.registerModule(new JavaTimeModule());
        return mapper;
    }

    /**
     * 获取全局统一的、线程安全的ObjectMapper实例。
     * 注意：返回的实例是配置好的，但对其进行的任何配置变更将影响全局。
     * 如需要自定义配置，可使用 {@link #copyObjectMapper()} 或自行创建新实例。
     */
    public static ObjectMapper getObjectMapper() {
        return OBJECT_MAPPER;
    }

    /**
     * 创建一个与全局配置相同的新ObjectMapper实例。
     * 用于需要临时自定义配置而又不想影响全局的场景。
     */
    public static ObjectMapper copyObjectMapper() {
        return OBJECT_MAPPER.copy();
    }

    /* ---------- 序列化 (to JSON) ---------- */

    /**
     * 将对象转换为JSON字符串（美化输出，适用于调试）
     */
    public static String toPrettyJsonString(Object obj) {
        try {
            return OBJECT_MAPPER.writerWithDefaultPrettyPrinter().writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            LOGGER.error("JacksonUtils#toPrettyJsonString occurs error, obj: {}", obj, e);
            return null;
        }
    }

    /**
     * 将对象转换为JSON字符串（紧凑格式）
     * 注意：此方法会抛出运行时异常 JacksonException
     *
     * @param obj 待序列化的对象
     * @return JSON字符串
     * @throws JacksonException 当序列化失败时抛出
     */
    public static String toJsonString(Object obj) throws JacksonException {
        try {
            return OBJECT_MAPPER.writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            throw new JacksonException("Failed to serialize object to JSON string", e);
        }
    }

    /**
     * 将对象转换为JSON字符串（安全方法，异常时返回null）
     *
     * @param obj 待序列化的对象
     * @return JSON字符串，失败返回null
     */
    public static String toJsonStringOrNull(Object obj) {
        try {
            return toJsonString(obj);
        } catch (JacksonException e) {
            LOGGER.warn("JacksonUtils#toJsonStringOrNull occurs error, return null. obj: {}", obj, e);
            return null;
        }
    }

    /**
     * 将对象序列化到输出流
     *
     * @param out 输出流
     * @param obj 待序列化的对象
     * @throws JacksonException 当序列化失败时抛出
     */
    public static void writeValue(OutputStream out, Object obj) throws JacksonException {
        try {
            OBJECT_MAPPER.writeValue(out, obj);
        } catch (IOException e) {
            throw new JacksonException("Failed to write object to OutputStream", e);
        }
    }

    /**
     * 将对象转换为字节数组
     *
     * @param obj 待序列化的对象
     * @return JSON字节数组
     * @throws JacksonException 当序列化失败时抛出
     */
    public static byte[] toJsonBytes(Object obj) throws JacksonException {
        try {
            return OBJECT_MAPPER.writeValueAsBytes(obj);
        } catch (JsonProcessingException e) {
            throw new JacksonException("Failed to serialize object to JSON bytes", e);
        }
    }

    /* ---------- 反序列化 (from JSON) ---------- */

    /**
     * 将JSON字符串解析为指定类型的对象
     * 注意：此方法会抛出运行时异常 JacksonException
     *
     * @param json  JSON字符串
     * @param clazz 目标对象类型
     * @param <T>   泛型类型
     * @return 解析后的对象
     * @throws JacksonException 当反序列化失败时抛出
     */
    public static <T> T parseObject(String json, Class<T> clazz) throws JacksonException {
        if (json == null || json.isEmpty()) {
            throw new JacksonException("JSON string is null or empty");
        }
        try {
            return OBJECT_MAPPER.readValue(json, clazz);
        } catch (JsonProcessingException e) {
            throw new JacksonException("Failed to parse JSON string to Object: " + json, e);
        }
    }

    /**
     * 将JSON字符串解析为指定类型的对象（安全方法，异常时返回null）
     *
     * @param json  JSON字符串
     * @param clazz 目标对象类型
     * @param <T>   泛型类型
     * @return 解析后的对象，失败返回null
     */
    public static <T> T parseObjectOrNull(String json, Class<T> clazz) {
        try {
            return parseObject(json, clazz);
        } catch (JacksonException e) {
            LOGGER.warn("JacksonUtils#parseObjectOrNull occurs error, return null. json: {}, clazz: {}", json, clazz, e);
            return null;
        }
    }

    /**
     * 将JSON字符串解析为复杂类型对象（支持泛型、集合等）
     * 示例：Map<String, List<User>> map = parseObject(json, new TypeReference<Map<String, List<User>>>() {});
     *
     * @param json          JSON字符串
     * @param typeReference 类型引用，用于描述复杂类型
     * @param <T>           泛型类型
     * @return 解析后的对象
     * @throws JacksonException 当反序列化失败时抛出
     */
    public static <T> T parseObject(String json, TypeReference<T> typeReference) throws JacksonException {
        if (json == null || json.isEmpty()) {
            throw new JacksonException("JSON string is null or empty");
        }
        try {
            return OBJECT_MAPPER.readValue(json, typeReference);
        } catch (JsonProcessingException e) {
            throw new JacksonException("Failed to parse JSON string to Object with TypeReference: " + json, e);
        }
    }

    /**
     * 通过Type反序列化（适用于无法直接使用Class或TypeReference的场景，如Spring的ParameterizedTypeReference）
     *
     * @param json JSON字符串
     * @param type Java Type
     * @param <T>  泛型类型
     * @return 解析后的对象
     * @throws JacksonException 当反序列化失败时抛出
     */
    public static <T> T parseObject(String json, Type type) throws JacksonException {
        if (json == null || json.isEmpty()) {
            throw new JacksonException("JSON string is null or empty");
        }
        try {
            JavaType javaType = getJavaType(type);
            return OBJECT_MAPPER.readValue(json, javaType);
        } catch (JsonProcessingException e) {
            throw new JacksonException("Failed to parse JSON string to Object with Type: " + json, e);
        }
    }

    /**
     * 将JSON输入流解析为指定类型的对象
     *
     * @param inputStream 输入流
     * @param clazz       目标对象类型
     * @param <T>         泛型类型
     * @return 解析后的对象
     * @throws JacksonException 当反序列化失败时抛出
     */
    public static <T> T parseObject(InputStream inputStream, Class<T> clazz) throws JacksonException {
        try {
            return OBJECT_MAPPER.readValue(inputStream, clazz);
        } catch (IOException e) {
            throw new JacksonException("Failed to parse InputStream to Object", e);
        }
    }

    /**
     * 将JSON字节数组解析为指定类型的对象
     *
     * @param bytes JSON字节数组
     * @param clazz 目标对象类型
     * @param <T>   泛型类型
     * @return 解析后的对象
     * @throws JacksonException 当反序列化失败时抛出
     */
    public static <T> T parseObject(byte[] bytes, Class<T> clazz) throws JacksonException {
        try {
            return OBJECT_MAPPER.readValue(bytes, clazz);
        } catch (IOException e) {
            throw new JacksonException("Failed to parse byte[] to Object", e);
        }
    }

    /**
     * 将JSON字符串解析为List（经典写法）
     * 示例：List<User> users = parseArray(json, User.class);
     *
     * @param json  JSON数组字符串
     * @param clazz 集合元素类型
     * @param <T>   泛型类型
     * @return 解析后的List集合
     * @throws JacksonException 当反序列化失败时抛出
     */
    public static <T> List<T> parseArray(String json, Class<T> clazz) throws JacksonException {
        if (json == null || json.isEmpty()) {
            throw new JacksonException("JSON string is null or empty");
        }
        try {
            return OBJECT_MAPPER.readValue(json, OBJECT_MAPPER.getTypeFactory().constructCollectionType(List.class, clazz));
        } catch (JsonProcessingException e) {
            throw new JacksonException("Failed to parse JSON string to List: " + json, e);
        }
    }

    /**
     * 将JSON字符串解析为List（安全方法，异常时返回null）
     */
    public static <T> List<T> parseArrayOrNull(String json, Class<T> clazz) {
        try {
            return parseArray(json, clazz);
        } catch (JacksonException e) {
            LOGGER.warn("JacksonUtils#parseArrayOrNull occurs error, return null. json: {}, clazz: {}", json, clazz, e);
            return null;
        }
    }

    /* ---------- 其他常用操作 ---------- */

    /**
     * 将JSON字符串转换为JsonNode树模型（用于动态解析或操作JSON）
     *
     * @param json JSON字符串
     * @return JsonNode对象
     * @throws JacksonException 当反序列化失败时抛出
     */
    public static JsonNode readTree(String json) throws JacksonException {
        if (json == null || json.isEmpty()) {
            throw new JacksonException("JSON string is null or empty");
        }
        try {
            return OBJECT_MAPPER.readTree(json);
        } catch (JsonProcessingException e) {
            throw new JacksonException("Failed to parse JSON string to JsonNode: " + json, e);
        }
    }

    /**
     * 创建一个空的ObjectNode（可用的JSON对象）
     */
    public static ObjectNode createObjectNode() {
        return OBJECT_MAPPER.createObjectNode();
    }

    /**
     * 对象转换（将已知对象转换为另一个类型的对象）
     * 示例：UserDTO userDTO = convertValue(userEntity, UserDTO.class);
     *
     * @param fromValue   源对象
     * @param toValueType 目标类型
     * @param <T>         泛型类型
     * @return 转换后的对象
     * @throws JacksonException 当转换失败时抛出
     */
    public static <T> T convertValue(Object fromValue, Class<T> toValueType) throws JacksonException {
        try {
            return OBJECT_MAPPER.convertValue(fromValue, toValueType);
        } catch (IllegalArgumentException e) {
            throw new JacksonException("Failed to convert value: " + fromValue, e);
        }
    }

    /**
     * 对象转换（支持复杂类型）
     */
    public static <T> T convertValue(Object fromValue, TypeReference<T> toValueType) throws JacksonException {
        try {
            return OBJECT_MAPPER.convertValue(fromValue, toValueType);
        } catch (IllegalArgumentException e) {
            throw new JacksonException("Failed to convert value: " + fromValue, e);
        }
    }

    /* ---------- 内部方法 ---------- */

    /**
     * 获取缓存的JavaType，提升复杂类型的解析性能
     */
    private static JavaType getJavaType(Type type) {
        return JAVA_TYPE_CACHE.computeIfAbsent(type, t ->
                OBJECT_MAPPER.getTypeFactory().constructType(t)
        );
    }

    /**
     * 自定义Jackson异常，统一将Checked Exception转换为Unchecked Exception
     */
    public static class JacksonException extends RuntimeException {
        public JacksonException(String message) {
            super(message);
        }

        public JacksonException(String message, Throwable cause) {
            super(message, cause);
        }
    }
}
