# AI//CONFIG

**Plan an AI setup around your workload, privacy needs, budget, and existing hardware.**

AI//CONFIG is an AI hardware assessment and recommendation application. A guided assessment suggests a Cloud, Hybrid, or Local approach, then creates a hardware plan for human review before releasing a detailed report.

[中文说明](#中文说明) · [Development](#local-development) · [Deployment](GITHUB-DEPLOYMENT.md) · [Contributing](CONTRIBUTING.md)

## Features

- Guided nine-step assessment covering use cases, privacy, concurrent users, data, automation, existing devices, budget, and experience.
- Deterministic hardware sizing with explicit assumptions for model weights, context, memory, storage, and concurrency.
- Cloud-only recommendations when buying new hardware is unnecessary.
- Passwordless email verification, account creation, and a personal report dashboard.
- Administrator review queue with editable drafts, revision history, approval, and report delivery.
- Product catalog with country, availability, capacity, and compatibility checks.
- Optional AI-generated explanations; the core recommendation engine works without an OpenAI key.
- Dark interface with responsive assessment and dashboard layouts.

## Project status

Maintained by [TeddyAIGo](https://github.com/TeddyAIGo) (ChatGPT: `@teddyaigo`). The hosted demo address is being updated; a verified link will be added once the hosting change is complete.

This is an early-stage project. The live application currently runs on Sites with Cloudflare Workers and D1. GitHub Actions checks types, recommendation rules, and the production build; it does **not** deploy the application.

Independent Cloudflare hosting is still being prepared. Administrator authentication currently depends on Sites-provided identity. Do not deploy this version directly as an independent public Worker without replacing that integration. See the [deployment guide](GITHUB-DEPLOYMENT.md).

Email delivery requires a configured provider and verified sender. Without them, the application stores administrator-only email previews and does not send messages. The product catalog starts empty. Hardware estimates are planning ranges, not benchmarks or live price quotes.

## How it works

1. Complete the assessment and receive a preliminary architecture recommendation.
2. Verify your email to save the assessment and create an account.
3. An administrator reviews the plan and any matching products.
4. The approved report becomes available in your dashboard and can be sent by email when delivery is configured.

## Technology

| Layer | Stack |
| --- | --- |
| Interface | React, TypeScript, Tailwind CSS, shadcn components |
| Application | Vinext, Vite, Next.js App Router conventions |
| Runtime | Cloudflare Workers |
| Database | Cloudflare D1, Drizzle ORM |
| Email | Resend, with a local preview mode |
| Optional explanations | OpenAI Responses API |
| Validation | GitHub Actions, TypeScript, engine and workflow checks |

## Local development

Requires **Node.js 22.13 or later** and npm. A clean clone uses the portable development profile; installing the Sites plugin is not required for this path.

```sh
git clone https://github.com/TeddyAIGo/ai-config-advisor.git
cd ai-config-advisor
npm run install:ci
cp .env.example .env
```

For local administrator access, set this value in your ignored `.env` file:

```dotenv
ADMIN_EMAILS=seedy@sites.test
```

Leave email provider keys empty to use preview mode. The loopback development server supplies the local test identity; it is not a production administrator account.

Build once to generate the local Worker configuration, initialize a **new** local database, then start development:

```sh
npm run build
npx wrangler d1 execute DB --local --config dist/server/wrangler.json --persist-to .wrangler/state --file drizzle/0000_magical_sentinel.sql
npm run dev
```

Open `http://localhost:5173`; administrator tools are at `/admin`. Apply the initial SQL file only once to a new local database. Existing databases require applying only unapplied migrations. Keep `.env` and `.wrangler/` out of version control.

See [runtime settings and architecture](docs/architecture.md) for environment variables, account handling, review behavior, and hardware sizing assumptions.

## Validation

```sh
npx tsc --noEmit
node tests/engine.mjs
npm run build
```

With the local development server running, the test administrator enabled, and email keys empty:

```sh
node tests/workflow.mjs
```

The workflow check creates synthetic assessments and catalog records in your local database. It covers account ownership, OTP replay rejection, administrator permissions, revision conflicts, approval, and report previews.

## Repository layout

```text
app/                 Pages, assessment UI, dashboards, and API routes
lib/                 Assessment definitions, recommendation engine, server helpers
db/                  Database access and schema
drizzle/             Schema migrations
components/          Shared interface components
tests/               Recommendation and local workflow checks
docs/                Architecture and runtime documentation
.github/workflows/   Continuous integration
```

## Roadmap

- Independent Cloudflare deployment with portable administrator authentication.
- Verified production email delivery.
- Model-specific hardware benchmarks and broader compatibility data.
- Community feedback on assessment questions, accessibility, and recommendation rules.

## Contributing

Bug reports, documentation improvements, and tested recommendation-rule changes are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request. Please use synthetic data in reports and examples.

## License

[MIT](LICENSE) © 2026 TeddyAIGo. Third-party components retain their own licenses; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## 中文说明

AI//CONFIG 根据使用场景、隐私要求、预算和现有设备，提供云端、混合或本地 AI 部署建议。用户完成评估后，由管理员审核详细方案，再向用户发布报告。

项目采用 MIT 许可证，欢迎提交问题、文档改进和代码贡献。当前线上版本由 Sites 托管，独立 Cloudflare 部署仍在准备中；邮件服务未配置时仅生成管理员可见的预览，不会实际发信。硬件建议是规划参考，不代表实测性能或实时商品报价。
