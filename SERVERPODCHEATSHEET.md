## 🛠️ Installation & Project Creation

| Command                                  | Description                                     |
| :--------------------------------------- | :---------------------------------------------- |
| `dart pub global activate serverpod_cli` | Install or update the Serverpod CLI             |
| `serverpod`                              | Verify installation and view available commands |
| `serverpod create <project_name>`        | Create a new Serverpod project                  |

> Project names must be lowercase with underscores  
> Example: `my_project`

---

## 📦 Project Structure Overview

A Serverpod project is a full stack Flutter application.

```

my_project_server/   # Backend, database models, API endpoints
my_project_client/   # Generated client code (do not edit manually)
my_project_flutter/  # Flutter frontend (mobile + web)

```

---

## 🐘 Local Database (Docker)

All database services run via Docker.  
Commands must be executed from the `*_server` directory.

| Command                        | Description                  |
| :----------------------------- | :--------------------------- |
| `docker compose up`            | Start database services      |
| `docker compose up -d`         | Start database in background |
| `docker compose up --build -d` | Rebuild and start database   |
| `docker compose down`          | Stop database services       |

---

## 🚀 Running the App Locally

You need **three processes** running at the same time.

---

### 1️⃣ Database (Postgres + Redis)

```bash
cd my_project_server
docker compose up -d
```

---

### 2️⃣ Server (Backend API)

```bash
cd my_project_server
dart run bin/main.dart --apply-migrations
```

Use `--apply-migrations` when:

- Running locally
- You changed database models
- You deployed schema changes

---

### 3️⃣ Client (Flutter App)

```bash
cd my_project_flutter
flutter pub get
flutter run
```

Web example:

```bash
flutter run -d chrome --web-port 3000
```

---

## 🔄 Development Workflow

### When You Change APIs or Models

If you add or modify:

- Endpoints
- Database models
- Model properties

Run the following from the server directory:

```bash
serverpod generate
serverpod create-migration
docker compose up --build -d
dart run bin/main.dart --apply-migrations
```

Then restart the Flutter app.

---

### Common Generator Commands

| Command                              | Description                         |
| :----------------------------------- | :---------------------------------- |
| `serverpod generate`                 | Regenerate client and protocol code |
| `serverpod create-migration`         | Create a new database migration     |
| `serverpod create-migration --force` | Force migration generation          |

---

## ☁️ Deployment (Serverpod Cloud)

> Serverpod Cloud is a deployment service.
> Serverpod itself is the backend framework.

---

### Deploy Backend

```bash
scloud deploy
```

Verbose and debugging options:

```bash
scloud deploy --verbose
scloud deploy --dry-run --verbose
scloud deploy --show-files
```

---

### Check Deployment Status

```bash
scloud deployment show
scloud deployment list
```

You know deployment succeeded when **all stages show green checkmarks**.

---

### View Deployment Logs

```bash
scloud log
scloud log --tail
scloud log --since 1h
scloud log 10m
```

---

### Build Logs (Critical for Debugging)

```bash
scloud deployment build-log
scloud deployment build-log <deployment_id>
```

Example:

```bash
scloud deployment build-log 923a5286-c937-46fd-90a2-a23d78025c31
```

---

## 🔐 Secrets & Passwords

| Command                | Description                 |
| :--------------------- | :-------------------------- |
| `scloud secret list`   | List stored secrets         |
| `scloud password list` | List passwords (names only) |

---

## 🧪 Flutter Build via Serverpod

```bash
serverpod run flutter_build
```

Useful for validating production Flutter builds.

---

## 🧠 Common Gotchas

- `scloud deploy` showing success does not always mean deployment completed
- Always confirm with `scloud deployment show`
- Some apps are hosted at `/app` by default:

  ```
  https://your-domain.serverpod.space/app/
  ```

- If builds fail silently, check:

  ```
  scloud deployment build-log
  ```

- WASM flags may cause intermittent build failures depending on environment

---

## ✅ Quick Mental Model

- **Serverpod**: Backend framework, database access, APIs, scalability
- **Docker**: Local dev parity and database services
- **Serverpod Cloud**: Deployment and hosting convenience
- **Flutter**: UI and client logic

---
