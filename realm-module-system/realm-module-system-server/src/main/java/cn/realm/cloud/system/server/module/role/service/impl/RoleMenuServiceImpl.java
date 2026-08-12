package cn.realm.cloud.system.server.module.role.service.impl;

import cn.realm.cloud.system.server.module.role.model.entity.RoleMenu;
import cn.realm.cloud.system.server.module.role.mapper.RoleMenuMapper;
import cn.realm.cloud.system.server.module.role.service.RoleMenuService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 角色和菜单关联表 服务实现类
 * </p>
 *
 * @author QI Guang
 */
@Service
public class RoleMenuServiceImpl extends ServiceImpl<RoleMenuMapper, RoleMenu> implements RoleMenuService {

}
