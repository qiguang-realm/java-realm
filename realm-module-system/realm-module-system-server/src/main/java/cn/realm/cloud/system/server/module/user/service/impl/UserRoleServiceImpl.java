package cn.realm.cloud.system.server.module.user.service.impl;

import cn.realm.cloud.system.server.module.user.model.entity.UserRole;
import cn.realm.cloud.system.server.module.user.mapper.UserRoleMapper;
import cn.realm.cloud.system.server.module.user.service.UserRoleService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 用户和角色关联表 服务实现类
 * </p>
 *
 * @author QI Guang
 * @since 2026-08-12
 */
@Service
public class UserRoleServiceImpl extends ServiceImpl<UserRoleMapper, UserRole> implements UserRoleService {

}
