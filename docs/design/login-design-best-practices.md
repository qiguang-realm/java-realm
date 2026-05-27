# 主流应用登录流程设计最佳实践（2026版）

> 基于 Spring Boot / Spring Security 生态，涵盖 8 种主流应用形态，提供最安全、高效、健壮、无坑的解决方案。  
> **每个代码段均附有详细注释，解释“为什么这样写”。**

---

## 📑 目录

1. [前后端分离 Web 应用](#1-前后端分离-web-应用)
2. [传统单体 Web 应用](#2-传统单体-web-应用)
3. [移动端 App (Native)](#3-移动端-app-native)
4. [微信/抖音小程序](#4-微信抖音小程序)
5. [企业级内部系统](#5-企业级内部系统)
6. [B2B SaaS 应用](#6-b2b-saas-应用)
7. [高安全/无密码应用](#7-高安全无密码应用)
8. [游戏/社交应用](#8-游戏社交应用)
9. [通用安全基线](#9-通用安全基线)
10. [技术选型总结表](#10-技术选型总结表)
11. [附录：常用工具与库](#附录常用工具与库)

---

## 1. 前后端分离 Web 应用

### 1.1 场景描述
- React / Vue / Angular 等 SPA，前后端独立部署。
- 后端提供 REST API，前端负责页面渲染。
- 跨域请求（CORS）常见。

### 1.2 最佳方案：JWT 双 Token + Refresh Token 轮换

| 令牌类型 | 有效期 | 存储位置（前端） | 作用 |
|---------|--------|-----------------|------|
| Access Token | 15 分钟 | 内存（如 Vuex/Redux）或 sessionStorage | 调用业务 API |
| Refresh Token | 7 天 | HttpOnly Cookie（推荐） | 刷新 Access Token |

**为什么这样设计？**
- Access Token 短期有效：即使泄露，攻击者可用时间窗口短。
- Refresh Token 长期有效且存储在 HttpOnly Cookie 中：无法被 JavaScript 读取，防止 XSS 攻击；同时支持无感刷新。
- 轮换机制：每次刷新颁发新 Refresh Token，并使旧 Token 失效，防止重放攻击。

### 1.3 核心技术栈（Maven 依赖）

在 `pom.xml` 中添加以下依赖：

```xml
<!-- Spring Security 核心 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```
```xml
<!-- JJWT 生成/解析 JWT -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
```
```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
```
```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
```

# 主流应用登录流程与 Spring 技术选型归纳

在目前主流的开发场景中，不同的应用形态由于其安全模型、用户交互方式和使用环境各异，在登录流程和 Spring 技术选型上都有对应的、经过验证的最佳实践。以下是针对各类主流应用的归纳整理：

| 应用类型 | 场景描述 | 最佳设计流程（方案） | 最佳技术组合 (Spring 生态为主) |
| :--- | :--- | :--- | :--- |
| 🌐 前后端分离 Web 应用 | 现代 SPA 应用（如 React/Vue），前端独立部署，与后端通过 API 通信。 | JWT 双 Token + Refresh Token 轮换机制<br>Access Token 短期有效（15分钟），Refresh Token 长期有效，用于静默续期。 | `Spring Security + JWT` (Spring Security + JJWT) |
| 🗄️ 传统单体 Web 应用 | 服务端渲染页面（如 Thymeleaf/JSP），前后端未分离。 | Session + Cookie 机制<br>利用 Servlet 容器原生 Session，Spring Security 默认方案。 | `Spring Security` (默认表单登录) |
| 📱 移动端 App (Native) | iOS/Android 原生应用，需调用手机系统 API。 | OAuth 2.0 + PKCE + OpenID Connect (OIDC)<br>通过 PKCE 增强验证码交换的安全性，防止拦截攻击。 | `Spring Security OAuth 2.0 Resource Server + JWT` |
| 🟢 微信/抖音小程序 | 运行于小程序容器内，需获取第三方平台的用户身份。 | 授权 Code 换取 OpenID/UnionID<br>通过 code 换取用户唯一标识，颁发应用自己的 Session/Token。 | `Spring Boot + WxJava` (微信Java开发工具包) + JWT |
| 🏢 企业级内部系统 | 公司内部应用，需对接公司统一账号体系。 | LDAP/Active Directory 集成 或 企业级 SSO (OIDC)<br>对接公司 LDAP 服务器或通过企业 IdP（如 Okta）实现单点登录。 | `Spring Security LDAP` / `Spring Security OAuth 2.0 Client` |
| ☁️ B2B SaaS 应用 | 面向多企业客户的云服务，需支持多租户隔离。 | 多租户 SSO (OIDC + SCIM)<br>为不同租户提供定制化 SSO，并通过 SCIM 协议自动同步员工账号（JIT Provisioning）。 | `Spring Security + Keycloak / Okta / Auth0` |
| 🔐 高安全/无密码应用 | 金融机构、高权限后台等安全等级极高的场景。 | WebAuthn / Passkeys 无密码认证<br>基于生物识别（指纹/面容）或硬件密钥，实现防钓鱼的多因素认证（MFA）。 | `Spring Security + WebAuthn4J` (或 Yubico) + FIDO2 |
| 🎮 游戏/社交应用 | 游戏、社交应用，追求快速转化与裂变传播。 | 聚合多种登录方式 (聚合登录)<br>集成手机号、邮箱、用户名，以及微信、Google、Facebook、Apple 等多种第三方授权。 | `Spring Security OAuth 2.0 Client + JustAuth` (聚合登录SDK) |


### 1.4 关键代码实现（含详细注释）

#### 1.4.1 JWT 工具类（生成、解析、验证）

```java
@Component
public class JwtUtil {
    // 从配置文件读取密钥（绝不能硬编码）
    @Value("${jwt.access-secret}")
    private String accessSecret;
    @Value("${jwt.refresh-secret}")
    private String refreshSecret;
    @Value("${jwt.access-expiration}")
    private Long accessExpiration;  // 单位：秒，如 900 = 15分钟
    @Value("${jwt.refresh-expiration}")
    private Long refreshExpiration; // 如 604800 = 7天

    // 生成 Access Token
    public String generateAccessToken(String username) {
        return Jwts.builder()
            .setSubject(username)                     // 存放用户唯一标识
            .setIssuedAt(new Date())                  // 签发时间
            .setExpiration(new Date(System.currentTimeMillis() + accessExpiration * 1000)) // 过期时间
            .signWith(Keys.hmacShaKeyFor(accessSecret.getBytes()), SignatureAlgorithm.HS256) // 签名算法
            .compact();
    }

    // 生成 Refresh Token
    public String generateRefreshToken(String username) {
        return Jwts.builder()
            .setSubject(username)
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + refreshExpiration * 1000))
            .signWith(Keys.hmacShaKeyFor(refreshSecret.getBytes()), SignatureAlgorithm.HS256)
            .compact();
    }

    // 验证 Token 是否有效（未被篡改、未过期）
    public boolean validateToken(String token, String secret) {
        try {
            Jwts.parserBuilder().setSigningKey(secret.getBytes()).build().parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            // 签名错误、过期、格式错误等均返回 false
            return false;
        }
    }

    // 从 Token 中提取用户名（subject）
    public String getUsername(String token) {
        return Jwts.parserBuilder()
            .setSigningKey(accessSecret.getBytes())
            .build()
            .parseClaimsJws(token)
            .getBody()
            .getSubject();
    }

    // 注意：Refresh Token 的解析需使用 refreshSecret，此处省略 getUsernameFromRefreshToken 类似。
}
```

#### 1.4.2 认证过滤器（拦截请求，解析 Access Token）

```java
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws IOException, ServletException {
        // 1. 从请求头中提取 Token
        String token = extractToken(request);
        
        // 2. 如果 Token 存在且有效，则设置认证信息到 SecurityContext
        if (token != null && jwtUtil.validateToken(token, jwtUtil.getAccessSecret())) {
            String username = jwtUtil.getUsername(token);
            // 3. 从数据库（或缓存）加载用户详情（含权限）
            UserDetails user = userDetailsService.loadUserByUsername(username);
            // 4. 创建认证令牌，注意第三个参数是权限列表
            UsernamePasswordAuthenticationToken auth =
                new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
            // 5. 将认证信息存入线程上下文（后续 @AuthenticationPrincipal 可获取）
            SecurityContextHolder.getContext().setAuthentication(auth);
        }
        // 6. 继续执行后续过滤器
        chain.doFilter(request, response);
    }

    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
```

#### 1.4.3 登录与刷新接口（Controller）

```java
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private AuthenticationManager authenticationManager; // 由 Spring Security 提供
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private RefreshTokenService refreshTokenService; // 用于存储/验证 Refresh Token（通常用 Redis）

    // 登录接口
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        // 1. 执行认证（会触发 UserDetailsService 和 PasswordEncoder）
        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );
        String username = authentication.getName();

        // 2. 生成双 Token
        String accessToken = jwtUtil.generateAccessToken(username);
        String refreshToken = jwtUtil.generateRefreshToken(username);

        // 3. 存储 Refresh Token 到 Redis（用于后续校验和撤销）
        refreshTokenService.save(username, refreshToken);

        // 4. 将 Refresh Token 放入 HttpOnly Cookie（安全）
        ResponseCookie cookie = ResponseCookie.from("refreshToken", refreshToken)
            .httpOnly(true)          // 禁止 JS 读取
            .secure(true)            // 仅 HTTPS 传输
            .sameSite("Strict")      // 防止 CSRF
            .path("/")               // 整个站点有效
            .maxAge(Duration.ofDays(7))
            .build();

        // 5. 返回 Access Token（前端通常存在内存中）
        return ResponseEntity.ok()
            .header(HttpHeaders.SET_COOKIE, cookie.toString())
            .body(new AccessTokenResponse(accessToken));
    }

    // 刷新 Access Token 接口
    @PostMapping("/refresh")
    public ResponseEntity<?> refresh(@CookieValue(value = "refreshToken") String refreshToken) {
        // 1. 校验 Refresh Token 是否有效
        if (!jwtUtil.validateToken(refreshToken, jwtUtil.getRefreshSecret())) {
            throw new BadCredentialsException("Invalid refresh token");
        }
        String username = jwtUtil.getUsername(refreshToken);
        
        // 2. 校验服务端是否还存储着这个 Refresh Token（防止重放）
        if (!refreshTokenService.isValid(username, refreshToken)) {
            throw new BadCredentialsException("Refresh token revoked");
        }

        // 3. 生成新的 Access Token
        String newAccessToken = jwtUtil.generateAccessToken(username);
        
        // （可选）实现 Refresh Token 轮换：生成新的 Refresh Token，并使旧的失效
        // String newRefreshToken = jwtUtil.generateRefreshToken(username);
        // refreshTokenService.revoke(username, refreshToken);
        // refreshTokenService.save(username, newRefreshToken);
        // ResponseCookie newCookie = ... 设置新 Cookie

        return ResponseEntity.ok(new AccessTokenResponse(newAccessToken));
    }

    // 登出接口
    @PostMapping("/logout")
    public ResponseEntity<?> logout(@CookieValue(value = "refreshToken") String refreshToken) {
        String username = jwtUtil.getUsername(refreshToken);
        // 删除服务端存储的 Refresh Token
        refreshTokenService.revoke(username, refreshToken);
        // 清除客户端的 Cookie
        ResponseCookie clearCookie = ResponseCookie.from("refreshToken", "")
            .httpOnly(true)
            .maxAge(0)
            .path("/")
            .build();
        return ResponseEntity.ok()
            .header(HttpHeaders.SET_COOKIE, clearCookie.toString())
            .build();
    }
}
```

#### 1.4.4 配置文件示例（application.yml）

```yaml
jwt:
  access-secret: "mySuperSecretKeyForAccessTokenThatIsAtLeast256BitsLong"
  refresh-secret: "anotherStrongSecretForRefreshToken"
  access-expiration: 900   # 15分钟
  refresh-expiration: 604800 # 7天
```


### 1.5 安全建议（关键点）
>
- 永远不要将 Refresh Token 以明文形式返回给前端，必须用 HttpOnly Cookie。

- Access Token 不要存 localStorage（XSS 可读取），应存内存（如 Vuex）。

- 启用 Refresh Token 轮换：每次刷新都换一个新的 Refresh Token，旧 Token 立即失效。

- CORS 配置：允许前端域名，且 allowCredentials=true 时不能用 *。
>

## 2. 传统单体 Web 应用
### 2.1 场景描述
服务端渲染（Thymeleaf、JSP、FreeMarker），前后端代码耦合。

通过 Session 维护状态，Cookie 自动携带。

### 2.2 最佳方案：Session + Cookie（Spring Security 默认）
用户登录后服务端创建 HttpSession，JSESSIONID 写入 Cookie。

SecurityContextPersistenceFilter 从 Session 恢复认证信息。

支持 Remember-Me（持久化 Token）。

### 2.3 核心技术栈

```xml

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```
```xml
<dependency>
    <groupId>org.springframework.session</groupId>
    <artifactId>spring-session-data-redis</artifactId>
</dependency>
```
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>

```
### 2.4 关键配置（含注释）

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 1. 授权规则
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/login", "/css/**", "/js/**").permitAll() // 公开资源
                .anyRequest().authenticated() // 其他所有请求需要认证
            )
            // 2. 表单登录配置
            .formLogin(form -> form
                .loginPage("/login")            // 自定义登录页面
                .defaultSuccessUrl("/home")     // 登录成功后跳转
                .failureUrl("/login?error")     // 失败后重定向
                .permitAll()
            )
            // 3. 登出配置
            .logout(logout -> logout
                .logoutSuccessUrl("/login?logout")
                .invalidateHttpSession(true)    // 销毁 Session
                .deleteCookies("JSESSIONID")    // 删除 Cookie
            )
            // 4. Session 管理
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED) // 需要时创建
                .maximumSessions(1)              // 同一用户只能有一个 Session（后登录踢前一个）
                .expiredUrl("/login?expired")    // Session 过期后的跳转
            );
        return http.build();
    }

    // 从数据库加载用户
    @Bean
    public UserDetailsService userDetailsService() {
        return username -> {
            User user = userRepository.findByUsername(username);
            if (user == null) {
                throw new UsernameNotFoundException("用户不存在");
            }
            // Spring Security 的 User 对象
            return org.springframework.security.core.userdetails.User
                .withUsername(user.getUsername())
                .password(user.getPassword())
                .authorities(user.getAuthorities()) // 如 "ROLE_USER"
                .build();
        };
    }

    // 密码编码器（BCrypt 强哈希）
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}

```

### 2.5 Session 共享（集群部署）

```yaml

spring:
  session:
    store-type: redis          # 使用 Redis 存储 Session
    redis:
      namespace: spring:session
  redis:
    host: redis.example.com
    port: 6379

```

### 2.6 安全建议

生产环境必须启用 HTTPS，并设置 server.servlet.session.cookie.secure=true。

设置 Session 超时：server.servlet.session.timeout=30m。

防止 Session Fixation：Spring Security 默认在登录后变更 Session ID。

## 3. 移动端 App (Native)
### 3.1 场景描述
iOS/Android 原生应用，无法安全保存 client_secret。

需要生物识别快捷登录。

### 3.2 最佳方案：OAuth 2.0 + PKCE + OIDC
授权码流程 + PKCE（Proof Key for Code Exchange）增强安全性。

返回 ID Token（JWT）和 Access Token。

推荐使用 Spring Authorization Server 或 Keycloak。

### 3.3 PKCE 核心原理（为什么安全？）
App 生成随机字符串 code_verifier，并对其哈希得到 code_challenge。

授权请求中只发送 code_challenge，不发送 code_verifier。

换取 Token 时，App 再发送 code_verifier。授权服务器验证哈希匹配。

即使攻击者截获授权码，没有 code_verifier 也无法换取 Token。

### 3.4 资源服务器配置（验证 Access Token）

```java
@Configuration
@EnableWebSecurity
public class ResourceServerConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 启用 JWT 格式的 Resource Server
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt
                    .jwtAuthenticationConverter(jwtAuthenticationConverter())
                )
            )
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            );
        return http.build();
    }

    // 自定义 JWT 转换器（可将 JWT 中的 claims 映射为权限）
    private JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(jwt -> {
            // 从 JWT 的 scope 或 roles 字段提取权限
            List<String> scopes = jwt.getClaimAsStringList("scope");
            return scopes.stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());
        });
        return converter;
    }
}
```

### 3.5 安全建议
强制使用 HTTPS。

使用 OIDC 标准，通过 ID Token 获取用户身份，而不是依赖 Access Token。

App 内存储 Token 使用安全存储（iOS Keychain / Android EncryptedSharedPreferences）。

## 4. 微信/抖音小程序
### 4.1 场景描述
运行于小程序容器，通过平台提供的 code 换取用户唯一标识（OpenID/UnionID）。

需要解密手机号等敏感信息。

### 4.2 最佳方案：Code 换 OpenID + 自定义 JWT
### 4.3 核心技术栈

```xml
<dependency>
    <groupId>com.github.binarywang</groupId>
    <artifactId>wx-java-miniapp-spring-boot-starter</artifactId>
    <version>4.6.0</version>
</dependency>
```


### 4.4 详细代码与解释

```java
@RestController
@RequestMapping("/api/wechat")
public class WechatLoginController {
    @Autowired
    private WxMaService wxMaService;          // WxJava 提供的小程序服务
    @Autowired
    private UserService userService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    // 步骤1：小程序调用 wx.login() 获得 code，然后 POST 这个 code 到此接口
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        // 1. 用 code 换取 openid 和 session_key
        //    注意：每个 code 只能用一次，微信会校验
        WxMaJscode2SessionResult session = wxMaService.getUserService()
            .getSessionInfo(request.getCode());
        String openid = session.getOpenid();
        String sessionKey = session.getSessionKey();   // 用于解密用户敏感数据
        
        // 2. 根据 openid 查找或创建用户（通常还会合并 unionid）
        User user = userService.findOrCreateByOpenid(openid);
        
        // 3. 存储 session_key 到 Redis，关联用户 ID，有效期一般 5-10 分钟
        //    因为解密手机号的操作通常发生在登录后不久
        redisTemplate.opsForValue().set("wx:session_key:" + user.getId(),
                                         sessionKey, 5, TimeUnit.MINUTES);
        
        // 4. 生成你自己的 JWT（小程序后续请求使用）
        String accessToken = jwtUtil.generateAccessToken(user.getUsername());
        String refreshToken = jwtUtil.generateRefreshToken(user.getUsername());
        
        // 5. 返回给小程序，小程序应存储到 storage 中
        return ResponseEntity.ok(new TokenResponse(accessToken, refreshToken));
    }

    // 步骤2：如果需要获取手机号，前端传递 encryptedData 和 iv
    @PostMapping("/decrypt-phone")
    public ResponseEntity<?> decryptPhone(@RequestBody DecryptRequest request,
                                          @AuthenticationPrincipal User user) {
        // 1. 从 Redis 中取出之前存储的 session_key
        String sessionKey = (String) redisTemplate.opsForValue()
            .get("wx:session_key:" + user.getId());
        if (sessionKey == null) {
            throw new RuntimeException("session_key 已过期，请重新登录");
        }
        
        // 2. 使用 WxJava 提供的解密方法
        WxMaUserInfo userInfo = wxMaService.getUserService()
            .getUserInfo(sessionKey, request.getEncryptedData(), request.getIv());
        String phoneNumber = userInfo.getPhoneNumber();
        
        // 3. 保存手机号到用户表
        userService.updatePhoneNumber(user.getId(), phoneNumber);
        
        // 4. 删除 session_key（用完即焚，提高安全性）
        redisTemplate.delete("wx:session_key:" + user.getId());
        
        return ResponseEntity.ok(phoneNumber);
    }
}
```
### 4.5 安全建议（非常重要）
绝对不要将 session_key 返回给小程序，它可用于解密任何用户数据，泄露后后果严重。

code 由微信保证一次性，后端无需额外防重放。

解密手机号后立即删除 Redis 中的 session_key，减少暴露时间。

小程序存储 JWT 时使用 wx.setStorageSync，登出时清除。

## 5. 企业级内部系统
### 5.1 场景描述
公司内部系统（OA、HR、财务等），已有 LDAP/Active Directory。

要求单点登录（SSO）。

### 5.2 最佳方案：LDAP/AD 认证 + OIDC SSO
直接对接 LDAP 验证用户名密码。

多系统时使用 Keycloak 提供 OIDC SSO。

### 5.3 LDAP 认证代码（含详细注释）

# application.yml

```yaml

spring:
  ldap:
    urls: ldaps://ldap.example.com:636   # 使用 ldaps 加密
    base: dc=example,dc=com
    username: cn=admin,dc=example,dc=com
    password: adminsecret

```

```java
@Configuration
@EnableWebSecurity
public class LdapSecurityConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/public/**").permitAll()
                .anyRequest().authenticated()
            )
            // 使用表单登录，但认证方式改为 LDAP
            .formLogin(withDefaults())
            .logout(withDefaults());
        return http.build();
    }

    // 配置 LDAP 认证 Provider
    @Bean
    public AuthenticationProvider ldapAuthenticationProvider(
            DefaultSpringSecurityContextSource contextSource) {
        // BindAuthenticator：直接使用用户名/密码绑定 LDAP 进行验证
        BindAuthenticator authenticator = new BindAuthenticator(contextSource);
        // 设置用户搜索模式，例如 uid={0} 表示用 uid 属性匹配用户名
        authenticator.setUserDnPatterns(new String[]{"uid={0},ou=people"});
        
        // 授权信息填充器：从 LDAP 的组中读取角色
        DefaultLdapAuthoritiesPopulator authoritiesPopulator =
            new DefaultLdapAuthoritiesPopulator(contextSource, "ou=groups");
        authoritiesPopulator.setGroupRoleAttribute("cn");
        authoritiesPopulator.setGroupSearchFilter("member={0}");
        
        return new LdapAuthenticationProvider(authenticator, authoritiesPopulator);
    }
}
```

### 5.4 集成 OIDC SSO（Keycloak）

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          keycloak:
            client-id: myapp
            client-secret: xxx
            authorization-grant-type: authorization_code
            scope: openid, profile, email
        provider:
          keycloak:
            issuer-uri: https://sso.example.com/realms/master
```

### 5.5 安全建议
LDAP 连接必须使用 ldaps:// 或 StartTLS。

首次登录成功后，可在本地数据库创建用户并同步 LDAP 中的部门、角色信息。

密码过期处理：捕获 AuthenticationException 的子类，提示用户修改密码。

## 6. B2B SaaS 应用
### 6.1 场景描述
多租户云服务，每个客户独立登录域名或租户标识。

客户使用自己的 IdP（Okta、Azure AD）进行 SSO。

需要自动同步员工账号（入职/离职）。

### 6.2 最佳方案：多租户 SSO (OIDC + SCIM)
每个租户配置独立的 OIDC 客户端（issuer 不同）。

通过 SCIM 2.0 协议自动预配用户（创建、更新、禁用）。

### 6.3 租户解析器（从子域名或请求头获取租户）

```java
@Component
public class TenantResolver {
    public String resolveTenant(HttpServletRequest request) {
        // 方式1：从子域名解析，例如 tenant1.yourapp.com
        String host = request.getServerName();
        if (host.contains(".")) {
            // 取第一个点之前的部分作为租户标识
            return host.substring(0, host.indexOf("."));
        }
        // 方式2：从请求头获取（适用于 API 调用）
        String tenantId = request.getHeader("X-Tenant-Id");
        if (tenantId != null) {
            return tenantId;
        }
        // 方式3：从 JWT 的 issuer 字段解析（需在认证后）
        throw new IllegalStateException("Unable to resolve tenant");
    }
}
```
### 6.4 动态 OIDC 客户端配置（关键）

```java
@Configuration
public class TenantOAuth2Config {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, TenantResolver tenantResolver) throws Exception {
        http
            .oauth2Client(oauth2 -> oauth2
                // 自定义客户端存储库，根据租户动态获取配置
                .authorizedClientRepository(new TenantAwareClientRepository(tenantResolver))
            )
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/login/**", "/oauth2/**").permitAll()
                .anyRequest().authenticated()
            );
        return http.build();
    }
}
```
### 6.5 SCIM 自动预配端点（接收来自 IdP 的用户同步）

```java
@RestController
@RequestMapping("/scim/v2/Users")
public class ScimUserController {
    @PostMapping
    public ResponseEntity<?> createUser(@RequestBody ScimUser user) {
        // SCIM 规范：POST /Users 表示创建或更新用户
        // 从请求头中获取租户（通常 IdP 会通过 Bearer Token 标识客户）
        String tenantId = resolveTenantFromRequest();
        userService.provisionUser(tenantId, user);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> updateUser(@PathVariable String id, @RequestBody ScimPatch patch) {
        if (patch.isActive() == false) {
            // 用户被禁用（离职）
            userService.disableUser(id);
        } else {
            userService.updateUserAttributes(id, patch);
        }
        return ResponseEntity.ok().build();
    }
}
```

### 6.6 安全建议
- 租户隔离：所有数据库查询必须隐式或显式带上 tenant_id 过滤条件。

- JWT 中必须包含 tenant_id 声明，后端过滤器验证当前请求的租户与 Token 中租户一致。

- SCIM 端点使用 Bearer Token 认证（客户 IdP 提供），防止未授权访问。

## 7. 高安全/无密码应用

### 7.1 场景描述
- 金融、政务、高权限后台，要求防钓鱼、防暴力破解。

- 使用生物识别（指纹/面容）或硬件密钥（YubiKey）。

### 7.2 最佳方案：WebAuthn / Passkeys
- 基于非对称加密，私钥存储在用户设备，公钥存储在服务器。

- 可单独作为无密码登录，或作为 MFA 因子。

### 7.3 WebAuthn 注册与登录流程（代码片段）

```java
@RestController
@RequestMapping("/webauthn")
public class WebAuthnController {
    // 注册开始：生成 challenge 和选项
    @PostMapping("/register/begin")
    public PublicKeyCredentialCreationOptions beginRegistration(@RequestBody String username) {
        byte[] challenge = generateRandomBytes(32);
        // 将 challenge 存入 session（或临时缓存），用于后续验证
        session.setAttribute("challenge", challenge);
        return PublicKeyCredentialCreationOptions.builder()
            .challenge(challenge)
            .rp(RelyingParty.builder().id("example.com").name("Example App").build())
            .user(User.builder().id(username.getBytes()).name(username).displayName(username).build())
            .pubKeyCredParams(List.of(
                new PublicKeyCredentialParameters(PublicKeyCredentialType.PUBLIC_KEY, COSEAlgorithm.ES256)
            ))
            .build();
    }

    // 注册完成：验证前端返回的凭证
    @PostMapping("/register/complete")
    public void completeRegistration(@RequestBody RegistrationRequest request) {
        byte[] expectedChallenge = (byte[]) session.getAttribute("challenge");
        // 使用 Yubico 或 WebAuthn4J 库验证 Attestation 签名
        // 验证通过后，保存凭证 ID 和公钥到数据库
    }

    // 登录开始：根据用户名获取已注册的凭证 ID
    @PostMapping("/login/begin")
    public PublicKeyCredentialRequestOptions beginLogin(@RequestBody String username) {
        List<PublicKeyCredentialDescriptor> allowCredentials = getCredentialsForUser(username);
        byte[] challenge = generateRandomBytes(32);
        session.setAttribute("loginChallenge", challenge);
        return PublicKeyCredentialRequestOptions.builder()
            .challenge(challenge)
            .allowCredentials(allowCredentials)
            .build();
    }

    // 登录完成：验证签名，生成会话 Token
    @PostMapping("/login/complete")
    public AuthenticationResponse completeLogin(@RequestBody AuthenticationRequest request) {
        // 使用存储的公钥验证签名
        boolean verified = verifySignature(request);
        if (verified) {
            String username = ...;
            String jwt = jwtUtil.generateAccessToken(username);
            return new AuthenticationResponse(jwt);
        }
        throw new RuntimeException("WebAuthn 验证失败");
    }
}
```

### 7.4 安全建议
- WebAuthn 可以单独作为无密码登录，但推荐作为 MFA（与密码组合）。

- 必须提供备用验证方式（如 TOTP 或恢复码），防止用户丢失设备。

- 2026 年主流浏览器已全面支持，移动端需使用原生相机调用 Passkeys。

## 8. 游戏/社交应用

### 8.1 场景描述
- 手游、社交平台，追求低门槛、高转化率。

- 提供多种登录方式（手机号、邮箱、微信、Google、Facebook、Apple）。

- 支持游客模式。

### 8.2 最佳方案：聚合登录 + 手机号优先
- 首次使用分配游客账号（基于设备标识）。

- 推荐绑定手机号（一键登录或验证码），或通过第三方授权快速登录。

- 使用 JustAuth 聚合 30+ 第三方 OAuth 登录。

### 8.3 手机号验证码登录（完整代码）

```java
@RestController
@RequestMapping("/api/auth")
public class SmsLoginController {
    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    @Autowired
    private UserService userService;
    @Autowired
    private JwtUtil jwtUtil;

    // 发送验证码（需限制频率）
    @PostMapping("/send-sms-code")
    public ResponseEntity<?> sendSmsCode(@RequestBody SendSmsRequest request) {
        String phone = request.getPhone();
        // 频率限制：同一手机号 60 秒内只能发送一次
        String limitKey = "sms:limit:" + phone;
        if (redisTemplate.hasKey(limitKey)) {
            throw new RuntimeException("请勿频繁发送验证码");
        }
        // 生成 6 位随机码
        String code = String.format("%06d", new Random().nextInt(999999));
        // 存储验证码，有效期 5 分钟
        redisTemplate.opsForValue().set("sms:code:" + phone, code, 5, TimeUnit.MINUTES);
        // 存储限流标记，60 秒过期
        redisTemplate.opsForValue().set(limitKey, "1", 60, TimeUnit.SECONDS);
        
        // 实际调用短信服务商发送 code（省略）
        // smsService.send(phone, code);
        return ResponseEntity.ok().build();
    }

    // 验证码登录
    @PostMapping("/login/sms")
    public ResponseEntity<?> smsLogin(@RequestBody SmsLoginRequest request) {
        String phone = request.getPhone();
        String cachedCode = redisTemplate.opsForValue().get("sms:code:" + phone);
        if (cachedCode == null || !cachedCode.equals(request.getCode())) {
            throw new BadCredentialsException("验证码错误或已过期");
        }
        // 根据手机号查找或创建用户
        User user = userService.findOrCreateByPhone(phone);
        // 生成 JWT
        String accessToken = jwtUtil.generateAccessToken(user.getUsername());
        String refreshToken = jwtUtil.generateRefreshToken(user.getUsername());
        // 登录成功后删除验证码（一次性）
        redisTemplate.delete("sms:code:" + phone);
        return ResponseEntity.ok(new TokenResponse(accessToken, refreshToken));
    }
}
```

### 8.4 聚合第三方登录（JustAuth 示例）

```java

@Service
public class OAuthService {
    // 配置微信登录
    public String getWechatAuthUrl(String state) {
        AuthRequest authRequest = new AuthWeChatRequest(AuthConfig.builder()
            .clientId("wx_appid")
            .clientSecret("wx_secret")
            .redirectUri("https://yourapp.com/oauth/wechat/callback")
            .build());
        // state 用于防止 CSRF
        return authRequest.authorize(state);
    }
    
    // 回调处理
    public AuthUser wechatLogin(String code, String state) {
        AuthRequest authRequest = new AuthWeChatRequest(config);
        AuthResponse<AuthUser> response = authRequest.login(code);
        if (response.ok()) {
            AuthUser authUser = response.getData();
            // authUser.getUuid() 是用户在第三方平台的唯一标识
            // 根据该标识查找或创建本地用户
            return authUser;
        }
        throw new RuntimeException("微信登录失败: " + response.getMsg());
    }
}

```

### 8.5 安全建议
- 手机验证码发送必须限流（60 秒/次，每日上限 10 次）。

- 游客账号转正时，需将游客期间产生的数据（如游戏记录）迁移到正式账号。

- 第三方登录建议绑定手机号，便于找回账号和防恶意注册。

- 若上架 App Store，必须支持 Apple 登录（Sign in with Apple）。

## 9. 通用安全基线
无论哪种应用类型，以下安全措施是必须的：

措施	说明
HTTPS	全站强制，使用 HSTS 预加载
密码加密	BCrypt（强度 10+）或 Argon2
防暴力破解	登录失败 5 次锁定 15 分钟（Redis 计数）
CORS 严格配置	仅允许前端域名，allowCredentials=true 时禁用 *
请求限流	对登录、注册、发送验证码接口限流
敏感数据脱敏	返回用户信息时隐藏手机号中间四位、邮箱前缀
日志脱敏	日志中不记录密码、Token、身份证号
漏洞依赖检查	定期使用 OWASP Dependency-Check 扫描

**防暴力破解代码示例**

```java
@Component
public class LoginFailureLimiter {
    @Autowired
    private RedisTemplate<String, Integer> redisTemplate;

    public void loginFailed(String username) {
        String key = "login:fail:" + username;
        int count = redisTemplate.opsForValue().increment(key);
        if (count == 1) {
            redisTemplate.expire(key, Duration.ofMinutes(15));
        }
        if (count >= 5) {
            redisTemplate.opsForValue().set("login:locked:" + username, 1, Duration.ofMinutes(15));
        }
    }

    public void checkLocked(String username) {
        if (Boolean.TRUE.equals(redisTemplate.hasKey("login:locked:" + username))) {
            throw new LockedException("账号已被锁定，请 15 分钟后再试");
        }
    }
}

// 在认证失败时调用
@Component
public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {
    @Autowired
    private LoginFailureLimiter limiter;
    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                        AuthenticationException exception) throws IOException {
        String username = request.getParameter("username");
        limiter.loginFailed(username);
        response.sendRedirect("/login?error");
    }
}
```

## **10. 技术选型总结表**

| 应用类型 | 推荐方案 | 核心框架 | Token 策略 | 状态管理 | 复杂度 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 前后端分离 Web | JWT 双 Token + Refresh 轮换 | Spring Security + JJWT | 无状态 JWT | 客户端存储 | ⭐⭐⭐ |
| 传统单体 Web | Session + Cookie | Spring Security + Spring Session | 有状态 Session | 服务端 Redis | ⭐ |
| 移动端 App | OAuth 2.0 + PKCE + OIDC | Spring Authorization Server / Keycloak | JWT / Opaque | 安全存储 | ⭐⭐⭐⭐ |
| 微信/抖音小程序 | Code 换 OpenID + JWT | WxJava + JWT | 无状态 JWT | 小程序存储 | ⭐⭐ |
| 企业级内部系统 | LDAP / AD 认证 | Spring Security LDAP | 无 / Session | 服务端 | ⭐⭐ |
| B2B SaaS | 多租户 OIDC + SCIM | Keycloak / Okta | JWT | 数据库 + Redis | ⭐⭐⭐⭐⭐ |
| 高安全/无密码 | WebAuthn / Passkeys | WebAuthn4J + Yubico | 无密码 / 临时 Token | 服务端公钥 | ⭐⭐⭐⭐ |
| 游戏/社交 | 聚合登录 + 手机号 | JustAuth + Spring Security | JWT | 客户端存储 | ⭐⭐⭐ |


**附录：常用工具与库**

- **OAuth 2.0 授权服务器：** Spring Authorization Server、Keycloak

- **密码编码：** BCryptPasswordEncoder (Spring Security)

- **验证码生成：** Google Authenticator (TOTP)、Hutool

- **聚合登录：** JustAuth

- **小程序 SDK：** WxJava

- **WebAuthn：** Yubico WebAuthn Server、WebAuthn4J

- **限流：** Bucket4j、Resilience4j

- **API 安全：** Spring Security + OWASP ESAPI


> 📌 最后更新：2026 年 4 月
> 
> 📚 源文：[Spring Security 最佳实践指南](https://spring.io/blog/2023/04/03/spring-security-best-practices)
> 
> ✍️ 作者：Spring Security 最佳实践指南
> 
> 📄 许可：CC BY-NC-SA 4.0

