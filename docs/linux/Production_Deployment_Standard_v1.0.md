# 国际化大厂项目部署标准规范

> 参考：阿里巴巴、腾讯、字节跳动、Google、京东等一线互联网公司的部署实践  
> 适用范围：后端 Java/Go/Node.js 应用、前端 React/Vue/Angular 静态资源  
> 目标：标准化、自动化、可观测、可回滚、安全合规

---

## 1. 部署原则

| 原则 | 说明 |
|------|------|
| **自动化** | 所有部署通过 CI/CD 流水线完成，禁止手动上传、手动重启 |
| **不可变基础设施** | 每次部署生成新镜像/新实例，不原地修改运行环境 |
| **灰度 / 金丝雀** | 生产环境变更必须从小流量开始，逐步扩大 |
| **可观测性** | 部署过程中自动埋点，日志、监控、链路追踪全覆盖 |
| **快速回滚** | 一键回滚到上一稳定版本，RTO < 5 分钟 |
| **安全扫描** | 镜像/制品上线前必须通过漏洞扫描和合规检查 |

---

## 2. 部署前质量门禁（Pre‑Deployment）

### 2.1 代码与构建
- **单元测试**：覆盖率 ≥ 80%（核心模块 ≥ 90%）
- **集成测试**：所有 API 测试通过
- **静态代码扫描**：SonarQube / Checkmarx，无高危漏洞
- **依赖检查**：无已知 CVE 漏洞（Snyk / Dependency Check）

### 2.2 镜像 / 制品
- **基础镜像**：来自官方或内部可信源，最小化原则
- **分层构建**：缓存优化，非 root 用户运行
- **安全扫描**：Trivy / Clair 扫描无 critical 漏洞

### 2.3 配置与环境
- **配置外置**：通过环境变量或配置中心（Nacos / Apollo / Consul）
- **环境隔离**：dev → test → staging → prod，配置独立
- **数据库变更**：提前执行 DDL，兼容老版本

---

## 3. 部署流程标准

### 3.1 后端服务（Java/Go/Node.js）

#### 阿里、腾讯、字节常见模式（容器化 + K8s）
```bash
# CI 阶段
mvn clean package                     # 构建
docker build -t crm-admin:${VERSION}  # 打镜像
docker push registry/crm-admin:${VERSION}

# CD 阶段（K8s rolling update）
kubectl set image deployment/crm-admin crm-admin=registry/crm-admin:${VERSION}
kubectl rollout status deployment/crm-admin
