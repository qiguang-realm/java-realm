package cn.realm.cloud.system.server.module.menu.service.impl;

import cn.realm.cloud.system.server.module.menu.model.entity.Menu;
import cn.realm.cloud.system.server.module.menu.mapper.MenuMapper;
import cn.realm.cloud.system.server.module.menu.service.MenuService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 菜单权限表 服务实现类
 * </p>
 *
 * @author QI Guang
 */
@Service
public class MenuServiceImpl extends ServiceImpl<MenuMapper, Menu> implements MenuService {

}
