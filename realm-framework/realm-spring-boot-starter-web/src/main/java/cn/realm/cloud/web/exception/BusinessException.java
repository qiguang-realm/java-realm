package cn.realm.cloud.web.exception;

import cn.realm.cloud.framework.common.enums.ErrorCode;
import lombok.Getter;

/**
 * 自定义业务异常
 *
 * @author QI Guang
 */
@Getter
public class BusinessException extends RuntimeException {

    /**
     * 业务错误码枚举
     */
    private final ErrorCode errorCode;

    /**
     * 自定义错误消息（可选，若为 null 则使用 ErrorCode 中的默认消息）
     */
    private final String customMessage;

    /**
     * 构造业务异常（使用 ErrorCode 中的默认消息）
     *
     * @param errorCode 错误码枚举
     */
    public BusinessException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
        this.customMessage = null;
    }

    /**
     * 构造业务异常（自定义错误消息，覆盖默认消息）
     *
     * @param errorCode     错误码枚举
     * @param customMessage 自定义错误描述
     */
    public BusinessException(ErrorCode errorCode, String customMessage) {
        super(customMessage);
        this.errorCode = errorCode;
        this.customMessage = customMessage;
    }

    /**
     * 构造业务异常（带根因异常）
     *
     * @param errorCode 错误码枚举
     * @param cause     根因异常
     */
    public BusinessException(ErrorCode errorCode, Throwable cause) {
        super(errorCode.getMessage(), cause);
        this.errorCode = errorCode;
        this.customMessage = null;
    }

    /**
     * 构造业务异常（自定义消息 + 根因异常）
     *
     * @param errorCode     错误码枚举
     * @param customMessage 自定义错误描述
     * @param cause         根因异常
     */
    public BusinessException(ErrorCode errorCode, String customMessage, Throwable cause) {
        super(customMessage, cause);
        this.errorCode = errorCode;
        this.customMessage = customMessage;
    }

    /**
     * 获取最终展示给用户的消息（优先使用 customMessage，否则使用 errorCode 的默认消息）
     *
     * @return 消息文本
     */
    public String getDisplayMessage() {
        return customMessage != null ? customMessage : errorCode.getMessage();
    }
}
