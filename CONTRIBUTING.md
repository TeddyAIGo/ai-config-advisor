# Contributing to AI//CONFIG

Thank you for helping improve AI hardware planning.

## Issues

Search existing issues before opening a new one. For bugs, include expected behavior, actual behavior, reproduction steps, and relevant browser or runtime versions. Use synthetic assessment data and redact credentials, email addresses, verification codes, and private reports.

For recommendation changes, explain the workload, model/runtime assumptions, expected impact, and supporting measurements or references. Avoid presenting estimates as measured performance.

## Pull requests

1. Fork the repository and create a branch for a focused change.
2. Follow the [local setup instructions](README.md#local-development).
3. Explain the problem and resulting behavior in the pull request.
4. Run type checking, the engine checks, and the build. For account, API, database, or review changes, also run the local workflow check.
5. Include before/after screenshots for visible interface changes and update relevant documentation.

Keep production credentials and user data out of commits. Preserve existing migration history; schema changes should add a migration. Changes to authentication must preserve account isolation, administrator checks, and the distinction between local mock identity and trusted production identity.

The product catalog intentionally has no fabricated inventory or prices. Use clearly marked synthetic products in tests only.

## License

Contributions are made under the project's [MIT license](LICENSE). Preserve third-party copyright and license notices and identify the source of any added third-party code.
