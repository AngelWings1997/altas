# 安全测试

> **调用时机**: 需要验证应用安全性、检测漏洞、满足合规要求时加载
> **配合使用**: `references/testing/api-testing.md`（API 安全测试）、`references/testing/e2e-testing.md`（E2E 安全测试）

---

## 核心原则

1. **安全左移**: 在开发早期发现和修复安全漏洞，成本远低于生产环境
2. **纵深防御**: 多层安全控制，不依赖单一防线
3. **最小权限**: 每个组件只拥有完成任务所需的最小权限
4. **默认安全**: 安全配置是默认选项，不安全配置需要显式启用

---

## 安全测试类型

| 类型 | 阶段 | 工具 | 频率 |
|------|------|------|------|
| **静态分析 (SAST)** | 编码 | Bandit, Semgrep, SonarQube | 每次提交 |
| **依赖扫描 (SCA)** | 编码/构建 | Safety, Snyk, Dependabot | 每日/每次构建 |
| **密钥检测** | 提交前 | git-secrets, truffleHog, gitleaks | 每次提交 |
| **动态扫描 (DAST)** | 运行中 | OWASP ZAP, Burp Suite | 每周/每次发布 |
| **容器扫描** | 构建 | Trivy, Clair, Snyk Container | 每次构建 |
| **渗透测试** | 发布前 | 手工/自动化 | 每季度/重大变更 |

---

## 1. 依赖漏洞扫描 (SCA)

### Python: Safety

```bash
# 安装
pip install safety

# 扫描当前环境
safety check

# 扫描 requirements.txt
safety check -r requirements.txt

# 生成 JSON 报告
safety check -r requirements.txt --json > safety-report.json

# 忽略特定漏洞（谨慎使用）
safety check -r requirements.txt --ignore 12345,67890
```

### Python: pip-audit

```bash
# 安装
pip install pip-audit

# 扫描
pip-audit

# 修复（自动升级到无漏洞版本）
pip-audit --fix
```

### JavaScript: npm audit

```bash
# 扫描
npm audit

# 修复（自动安装补丁版本）
npm audit fix

# 修复（可能包含破坏性变更）
npm audit fix --force

# 仅生产依赖
npm audit --production

# JSON 输出
npm audit --json
```

### Snyk（多语言支持）

```bash
# 安装
npm install -g snyk

# 认证
snyk auth

# 扫描
snyk test

# 监控（持续监控新漏洞）
snyk monitor

# 扫描 Docker 镜像
snyk container test myapp:latest
```

### CI 集成

```yaml
# .github/workflows/security.yml
name: Security Scan

on: [push, pull_request]

jobs:
  dependency-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install safety
          pip install -r requirements.txt
      
      - name: Run Safety
        run: safety check -r requirements.txt --full-report
        continue-on-error: true  # 不阻塞构建，但会显示警告
      
      - name: Upload report
        uses: actions/upload-artifact@v4
        with:
          name: safety-report
          path: safety-report.json
```

---

## 2. 静态代码分析 (SAST)

### Python: Bandit

```bash
# 安装
pip install bandit

# 扫描整个项目
bandit -r ./src

# 排除测试文件
bandit -r ./src -x ./tests,./venv

# 生成报告
bandit -r ./src -f json -o bandit-report.json

# 仅显示高危问题
bandit -r ./src -lll  # 只显示 HIGH 级别
```

### Python: Semgrep

```bash
# 安装
pip install semgrep

# 使用默认规则扫描
semgrep --config=auto ./src

# 使用 OWASP 规则
semgrep --config=p/owasp-top-ten ./src

# 使用 Python 安全规则
semgrep --config=p/python ./src

# 扫描并生成 SARIF 报告
semgrep --config=auto --sarif --output=semgrep.sarif ./src
```

### 自定义 Semgrep 规则

```yaml
# .semgrep/custom-rules.yml
rules:
  - id: hardcoded-password
    pattern: password = "..."
    languages: [python]
    message: "检测到硬编码密码，请使用环境变量或密钥管理服务"
    severity: ERROR
    
  - id: unsafe-eval
    pattern: eval(...)
    languages: [python]
    message: "避免使用 eval()，存在代码注入风险"
    severity: WARNING
    
  - id: sql-injection-risk
    patterns:
      - pattern-either:
        - pattern: |
            cursor.execute($X % ...)
        - pattern: |
            cursor.execute($X + ...)
        - pattern: |
            cursor.execute(f"...")
    languages: [python]
    message: "检测到潜在的 SQL 注入风险，请使用参数化查询"
    severity: ERROR
```

---

## 3. 密钥泄露检测

### pre-commit 钩子

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: detect-private-key
      
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
        
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

### gitleaks

```bash
# 安装
brew install gitleaks

# 扫描整个历史
gitleaks detect --source . --verbose

# 扫描最近一次提交
gitleaks detect --source . --no-git

# 生成报告
gitleaks detect --source . --report-format json --report-path gitleaks-report.json
```

### truffleHog

```bash
# 安装
docker pull trufflesecurity/trufflehog:latest

# 扫描
docker run -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest filesystem /pwd

# 扫描 Git 历史
docker run -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest git file:///pwd
```

---

## 4. 动态应用安全测试 (DAST)

### OWASP ZAP

#### 基础扫描

```bash
# Docker 运行 ZAP 基线扫描
docker run -t owasp/zap2docker-stable zap-baseline.py \
  -t https://target.example.com \
  -r zap-report.html

# 完整扫描（更彻底但更慢）
docker run -t owasp/zap2docker-stable zap-full-scan.py \
  -t https://target.example.com \
  -r zap-report.html

# API 扫描
docker run -t owasp/zap2docker-stable zap-api-scan.py \
  -t https://api.example.com/openapi.json \
  -f openapi \
  -r zap-api-report.html
```

#### Python 集成

```python
# tests/security/test_zap_scan.py
import requests
import time
import pytest


class TestZAPSecurity:
    """使用 OWASP ZAP 进行安全扫描"""
    
    ZAP_API_URL = "http://localhost:8080"
    ZAP_API_KEY = "your-api-key"  # 从环境变量读取
    TARGET_URL = "http://target-app:3000"
    
    def test_spider_scan(self):
        """爬取应用页面"""
        # 启动 Spider
        response = requests.get(
            f"{self.ZAP_API_URL}/JSON/spider/action/scan/",
            params={
                "apikey": self.ZAP_API_KEY,
                "url": self.TARGET_URL,
            }
        )
        scan_id = response.json()["scan"]
        
        # 等待扫描完成
        while True:
            status = requests.get(
                f"{self.ZAP_API_URL}/JSON/spider/view/status/",
                params={"apikey": self.ZAP_API_KEY, "scanId": scan_id}
            ).json()["status"]
            if status == "100":
                break
            time.sleep(1)
        
        # 验证发现了一些 URL
        urls = requests.get(
            f"{self.ZAP_API_URL}/JSON/spider/view/results/",
            params={"apikey": self.ZAP_API_KEY}
        ).json()["results"]
        
        assert len(urls) > 0, "Spider 未发现任何 URL"
    
    def test_active_scan(self):
        """主动漏洞扫描"""
        # 启动 Active Scan
        response = requests.get(
            f"{self.ZAP_API_URL}/JSON/ascan/action/scan/",
            params={
                "apikey": self.ZAP_API_KEY,
                "url": self.TARGET_URL,
            }
        )
        scan_id = response.json()["scan"]
        
        # 等待扫描完成
        while True:
            status = requests.get(
                f"{self.ZAP_API_URL}/JSON/ascan/view/status/",
                params={"apikey": self.ZAP_API_KEY, "scanId": scan_id}
            ).json()["status"]
            if status == "100":
                break
            time.sleep(5)
    
    def test_no_high_risk_alerts(self):
        """验证没有高危安全警告"""
        alerts = requests.get(
            f"{self.ZAP_API_URL}/JSON/core/view/alerts/",
            params={"apikey": self.ZAP_API_KEY, "baseurl": self.TARGET_URL}
        ).json()["alerts"]
        
        high_risks = [a for a in alerts if a["risk"] == "High"]
        
        if high_risks:
            alert_details = "\n".join([
                f"- {a['alert']}: {a['description'][:100]}"
                for a in high_risks[:5]
            ])
            pytest.fail(f"发现 {len(high_risks)} 个高危安全警告:\n{alert_details}")
```

---

## 5. API 安全测试

### 常见漏洞测试

```python
# tests/security/test_api_security.py
import pytest
import requests


class TestAPISecurity:
    """API 安全测试"""
    
    BASE_URL = "http://localhost:8000"
    
    def test_sql_injection_in_login(self):
        """测试登录接口 SQL 注入防护"""
        payloads = [
            "' OR '1'='1",
            "' OR 1=1 --",
            "admin'--",
            "1'; DROP TABLE users; --",
        ]
        
        for payload in payloads:
            response = requests.post(
                f"{self.BASE_URL}/api/login",
                json={"username": payload, "password": "test"}
            )
            # 不应该返回成功登录
            assert response.status_code != 200, f"SQL 注入成功: {payload}"
            # 不应该暴露 SQL 错误
            assert "sql" not in response.text.lower()
            assert "syntax" not in response.text.lower()
    
    def test_xss_injection(self):
        """测试 XSS 防护"""
        xss_payloads = [
            "<script>alert('xss')</script>",
            "<img src=x onerror=alert('xss')>",
            "javascript:alert('xss')",
        ]
        
        for payload in xss_payloads:
            response = requests.post(
                f"{self.BASE_URL}/api/comments",
                json={"content": payload},
                headers={"Authorization": "Bearer test-token"}
            )
            
            # 获取刚创建的评论
            comment_id = response.json()["id"]
            get_response = requests.get(f"{self.BASE_URL}/api/comments/{comment_id}")
            
            content = get_response.json()["content"]
            # 验证脚本标签被转义或移除
            assert "<script>" not in content
            assert "onerror=" not in content.lower()
    
    def test_authentication_bypass(self):
        """测试认证绕过"""
        protected_endpoints = [
            "/api/users",
            "/api/admin/settings",
            "/api/orders",
        ]
        
        for endpoint in protected_endpoints:
            # 无 Token 访问
            response = requests.get(f"{self.BASE_URL}{endpoint}")
            assert response.status_code == 401, f"{endpoint} 未正确要求认证"
            
            # 无效 Token
            response = requests.get(
                f"{self.BASE_URL}{endpoint}",
                headers={"Authorization": "Bearer invalid_token"}
            )
            assert response.status_code == 401
    
    def test_authorization_enforcement(self):
        """测试权限控制"""
        # 普通用户 Token
        user_token = "user_token_here"
        # 管理员 Token
        admin_token = "admin_token_here"
        
        # 普通用户访问管理员接口
        response = requests.get(
            f"{self.BASE_URL}/api/admin/users",
            headers={"Authorization": f"Bearer {user_token}"}
        )
        assert response.status_code == 403, "普通用户不应能访问管理员接口"
        
        # 管理员可以访问
        response = requests.get(
            f"{self.BASE_URL}/api/admin/users",
            headers={"Authorization": f"Bearer {admin_token}"}
        )
        assert response.status_code == 200
    
    def test_rate_limiting(self):
        """测试速率限制"""
        # 快速发送 100 个请求
        responses = []
        for i in range(100):
            response = requests.get(f"{self.BASE_URL}/api/public")
            responses.append(response.status_code)
        
        # 应该有一些请求被限制
        assert 429 in responses, "未触发速率限制"
        
        # 检查限流头
        assert "X-RateLimit-Limit" in response.headers
        assert "X-RateLimit-Remaining" in response.headers
    
    def test_sensitive_data_exposure(self):
        """测试敏感数据泄露"""
        response = requests.get(
            f"{self.BASE_URL}/api/users/1",
            headers={"Authorization": "Bearer valid_token"}
        )
        
        data = response.json()
        
        # 不应该返回密码哈希
        assert "password" not in data
        assert "password_hash" not in data
        assert "secret" not in data
        
        # 不应该返回内部 ID 或路径
        assert "__internal_id" not in data
        assert "file_path" not in data
    
    def test_mass_assignment_protection(self):
        """测试批量赋值防护"""
        # 尝试通过更新接口修改只读字段
        response = requests.put(
            f"{self.BASE_URL}/api/users/1",
            json={
                "name": "New Name",
                "role": "admin",  # 只读字段
                "is_superuser": True,  # 敏感字段
            },
            headers={"Authorization": "Bearer user_token"}
        )
        
        # 获取用户信息验证
        user = requests.get(
            f"{self.BASE_URL}/api/users/1",
            headers={"Authorization": "Bearer user_token"}
        ).json()
        
        assert user.get("role") != "admin", "批量赋值防护失败"
        assert user.get("is_superuser") != True
```

---

## 6. 容器安全扫描

### Trivy

```bash
# 扫描镜像
trivy image myapp:latest

# 扫描并仅显示高危漏洞
trivy image --severity HIGH,CRITICAL myapp:latest

# 扫描文件系统
trivy filesystem ./

# 扫描 Dockerfile
trivy config ./Dockerfile

# 生成报告
trivy image --format sarif -o trivy-report.sarif myapp:latest
```

### CI 集成

```yaml
# .github/workflows/container-security.yml
name: Container Security

on: [push]

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Build image
        run: docker build -t myapp:${{ github.sha }} .
      
      - name: Run Trivy
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'myapp:${{ github.sha }}'
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'  # 发现高危漏洞时失败
```

---

## 7. 安全测试清单

### 认证与授权
- [ ] 密码策略（长度、复杂度、历史）
- [ ] 多因素认证 (MFA)
- [ ] 会话管理（超时、并发限制）
- [ ] JWT 安全（签名、过期、刷新机制）
- [ ] OAuth/OIDC 实现安全
- [ ] 权限最小化原则
- [ ] 水平越权防护
- [ ] 垂直越权防护

### 输入验证
- [ ] SQL 注入防护
- [ ] XSS 防护（反射型、存储型、DOM 型）
- [ ] CSRF 防护
- [ ] 命令注入防护
- [ ] 路径遍历防护
- [ ] 文件上传安全
- [ ] XML/XXE 防护

### 数据保护
- [ ] 传输加密 (TLS 1.2+)
- [ ] 敏感数据存储加密
- [ ] 密钥管理（KMS/Vault）
- [ ] PII 数据脱敏
- [ ] 日志脱敏

### 基础设施
- [ ] 依赖漏洞扫描
- [ ] 容器镜像扫描
- [ ] 密钥泄露检测
- [ ] 安全头配置
- [ ] CORS 配置
- [ ] 速率限制
- [ ] DDoS 防护

---

## 8. 安全测试报告模板

```markdown
## 安全测试报告

**应用**: [名称]
**版本**: [版本]
**测试日期**: [日期]
**测试人员**: [姓名]

### 执行摘要

| 严重级别 | 数量 | 状态 |
|----------|------|------|
| Critical | 0 | ✅ 已修复 |
| High | 2 | ⚠️ 待修复 |
| Medium | 5 | ⏳ 计划中 |
| Low | 8 | 📋 已记录 |

### 扫描结果

#### 1. 依赖漏洞扫描 (Safety)
- **扫描范围**: requirements.txt, 127 个依赖
- **发现漏洞**: 2 个
  - HIGH: requests 2.28.1 (CVE-2023-XXXX) - 已修复
  - MEDIUM: urllib3 1.26.0 (CVE-2023-YYYY) - 计划中

#### 2. 静态代码分析 (Bandit)
- **扫描范围**: ./src, 150 个文件
- **发现 issue**: 3 个
  - LOW: 使用 assert 语句 (B101)
  - LOW: 硬编码临时目录 (B108)

#### 3. 动态扫描 (OWASP ZAP)
- **扫描范围**: https://app.example.com
- **发现警告**: 5 个
  - MEDIUM: Content Security Policy 缺失
  - LOW: X-Content-Type-Options 头缺失

### 详细发现

#### [HIGH-001] SQL 注入风险
- **位置**: `/api/search` 接口
- **描述**: 用户输入直接拼接到 SQL 查询
- **复现**: `curl "https://api.example.com/search?q=' OR '1'='1"`
- **修复**: 使用参数化查询
- **状态**: 待修复

### 修复计划

| 问题 | 负责人 | 截止日期 | 优先级 |
|------|--------|----------|--------|
| [HIGH-001] | 张三 | 2024-02-01 | P0 |
| [MED-001] | 李四 | 2024-02-15 | P1 |

### 建议

1. 启用 Dependabot 自动更新
2. 实施安全编码培训
3. 增加 SAST 到 CI 流程
4. 定期（每季度）进行渗透测试
```

---

**版本**: 1.0.0
**参考**: OWASP Top 10 2021, OWASP Testing Guide v4.2
