package cn.realm.cloud.system.server.module.role.service.impl;

import cn.realm.cloud.system.server.module.role.model.entity.Role;
import cn.realm.cloud.system.server.module.role.mapper.RoleMapper;
import cn.realm.cloud.system.server.module.role.service.RoleService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 角色信息表 服务实现类
 * </p>
 *
 * @author QI Guang
 */
@Service
public class RoleServiceImpl extends ServiceImpl<RoleMapper, Role> implements RoleService {

}
