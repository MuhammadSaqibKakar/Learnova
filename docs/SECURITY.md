# Security Notes

## Current State
The app is currently a frontend-first demo with local persistence.

## Hardening Added
- Legacy plain-text remembered password storage is removed automatically.
- "Remember me" now stores identifier only.
- Login throttling added (temporary lockout after repeated failures).
- OTP debug code display is now debug-only (`kDebugMode`).

## Production Checklist
- Move authentication and account storage to backend (Node.js).
- Store passwords as salted hashes server-side (never plaintext).
- Replace demo OTP with backend email/SMS OTP provider.
- Replace local role checks with signed access token verification.
- Add HTTPS enforcement and API request signing.
- Add audit logs for admin operations (user/content changes).
- Add row-level authorization checks in backend.

## Data Privacy
- Do not store sensitive educational analytics unencrypted on client.
- For kid data, enforce COPPA/child-data compliance policies in backend.

## Secrets Management
- Keep API keys in environment variables and secret managers.
- Never commit secrets to repo.
