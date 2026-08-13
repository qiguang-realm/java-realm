package cn.realm.cloud.system.server.module.dept.service.impl;

import cn.realm.cloud.system.server.module.dept.model.entity.Dept;
import cn.realm.cloud.system.server.module.dept.mapper.DeptMapper;
import cn.realm.cloud.system.server.module.dept.service.DeptService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 部门表 服务实现类
 * </p>
 *
 * @author QI Guang
 */
@Service
public class DeptServiceImpl extends ServiceImpl<DeptMapper, Dept> implements DeptService {

}
