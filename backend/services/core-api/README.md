# Core API Service

Node.js backend service for:

- authentication
- parent/kid/admin management
- learning progression and levels
- dashboard data

This service should remain independent from chatbox runtime concerns.

## Current Demo Runtime

This service now provides a lightweight shared-state API so Android, desktop, and web can use the same Learnova data store.

### Run

```powershell
cd "D:\Flutter Projects\learnova\backend\services\core-api"
npm run dev
```

### Endpoints

- `GET /health`
- `GET /api/shared-state`
- `POST /api/shared-state`

### Flutter Connection

Run Flutter with the same API base URL on every client:

```powershell
flutter run -d chrome --dart-define=LEARNOVA_API_BASE_URL=http://<YOUR-PC-IP>:8787
flutter run -d A001LG --dart-define=LEARNOVA_API_BASE_URL=http://<YOUR-PC-IP>:8787
```

If you run web on the same PC, you can also use `http://127.0.0.1:8787`, but cross-device sync needs the PC's LAN IP so the phone can reach the backend too.
