# GitHub 管理与正式发布

本项目以 MIT 许可证在公开 GitHub 仓库维护。附带的 GitHub Actions 工作流负责类型检查、推荐规则测试和构建；它不发布应用，也不需要生产密钥。

## 推荐的发布方式

GitHub 仓库 → Cloudflare Workers 自动构建 → Cloudflare D1 数据库 → 自有域名。

GitHub Pages 只提供静态托管，不能单独运行本项目的 API、验证码验证、数据库和审核后台。GitHub 的 github.io 地址属于 Pages；若必须使用它，需要另外拆分和部署后端，当前应用并未做这种拆分。

目前线上版本由 Sites 托管。迁移到你自己的 Cloudflare 账户前，必须完成：

1. 确定仓库和 Cloudflare 账户。初期可使用 workers.dev 地址，自有域名可后续绑定。
2. 在新账户创建 D1 数据库，绑定 DB，并按顺序应用 drizzle 迁移；有生产数据时另行迁移数据，不能仅复制 schema。
3. 把生成配置里的本地占位数据库 ID 替换成新账户的真实资源，并配置正式 Worker 名称、构建和发布流程。
4. 将管理员认证改为邮件登录或独立的受信身份系统。当前 Sites 版本依赖平台提供的身份头；在普通公网 Worker 上不得直接信任客户端传入的 oai-authenticated-user-* 请求头。Sites 的 /signin-with-chatgpt 路由不能直接移植。
5. 配置 ADMIN_EMAILS、邮件发送者及服务密钥。未配置邮件服务时只有管理员预览模式，不会实际发送邮件。
6. 验证数据库、账户隔离、OTP、管理员权限、发送邮件和域名后再切换流量。

以上迁移尚未执行；GitHub CI 构建通过不代表已经建立独立 Cloudflare 生产环境。

## 邮件服务

GitHub 不能替代事务邮件提供商。当前代码已有 Resend 集成，需要 RESEND_API_KEY、EMAIL_FROM，以及在 Resend 中验证的自有域名。发信子域名可与网站共用同一个根域名，例如网站 www.example.com、发信 mail.example.com。

运行时密钥存放在 Cloudflare / Sites 的 Secret 设置中。GitHub Actions 如果负责部署，可用 GitHub Secrets 保存部署凭据。不要把实际密钥、.env、验证码记录或本地数据库提交到仓库。

## 官方参考

- GitHub Pages：https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages
- Cloudflare Git 自动部署：https://developers.cloudflare.com/workers/ci-cd/builds/
- 自有域名：https://developers.cloudflare.com/workers/configuration/routing/custom-domains/
- Resend 发信域名：https://resend.com/docs/dashboard/domains/introduction
