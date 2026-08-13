package cn.realm.cloud.system.server.module.post.service.impl;

import cn.realm.cloud.system.server.module.post.model.entity.Post;
import cn.realm.cloud.system.server.module.post.mapper.PostMapper;
import cn.realm.cloud.system.server.module.post.service.PostService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 岗位信息表 服务实现类
 * </p>
 *
 * @author QI Guang
 */
@Service
public class PostServiceImpl extends ServiceImpl<PostMapper, Post> implements PostService {

}
