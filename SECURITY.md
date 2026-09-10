# Security Policy

## Supported Versions

This project is a portfolio/demo Flutter application. Security fixes are applied to the current `main` branch.

## Reporting a Vulnerability

Do not open public issues with secrets, API keys, tokens, private URLs, crash dumps, or personal data.

Report security concerns privately to the project owner. Include:

- A short description of the issue
- Steps to reproduce
- Affected platform, such as Android, iOS, web, Linux, macOS, or Windows
- Any relevant logs with secrets redacted

## Secret Handling

- Never commit `.env`, `.env.save`, API keys, tokens, keystores, provisioning profiles, or signing passwords.
- Use `.env.example` for placeholder values only.
- Run locally with `--dart-define-from-file=.env`.
- Rotate a key immediately if it appears in chat, screenshots, logs, Git history, or a public build.
- For deployed web apps, do not expose the GNews API key in browser code. Use a backend proxy.

## Security Notes

- API request logging is disabled to avoid leaking keys.
- Error messages redact `apikey` query parameters where possible.
- Android internet access is declared explicitly in `AndroidManifest.xml`.
- User bookmarks and search history are stored locally with `shared_preferences`.
