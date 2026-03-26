# Learnova Backend (Node.js)

This folder is reserved for the Node.js backend and is intentionally split for scalability:

- `services/core-api/` -> main REST/API backend (auth, users, learning, admin)
- `services/chatbox/` -> separate future chatbox backend service

## Why Separate `chatbox`?

Chat systems usually have different scaling and deployment needs (websocket, realtime, queueing, moderation). Keeping it separate avoids coupling and keeps the main API clean.

## Suggested Next Step

1. Initialize each service with its own `package.json`.
2. Keep shared contracts in a future `packages/shared/` folder if needed.
