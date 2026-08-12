package cn.realm.cloud.system.server.module.user.service.impl;

import cn.realm.cloud.system.server.module.user.mapper.UserMapper;
import cn.realm.cloud.system.server.module.user.model.entity.User;
import cn.realm.cloud.system.server.module.user.service.UserService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

/**
 * <p>
 * 用户信息表 服务实现类
 * </p>
 *
 * @author QI Guang
 */
@Slf4j
@Service
@Validated
@RequiredArgsConstructor
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

}
