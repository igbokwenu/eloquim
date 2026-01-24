# Serverpod CLI Cheatsheet

A quick reference guide for installing, setting up, and running a Serverpod project.

---

## 🛠️ Installation & Setup

| Command | Description |
| :--- | :--- |
| `dart pub global activate serverpod_cli` | Installs/updates the Serverpod CLI globally on your machine. |
| `serverpod` | Verifies installation and displays help/available commands. |
| `serverpod create <project_name>` | Creates a new project folder with server, client, and flutter packages. |

> **Note:** Project names must be lowercase with underscores (e.g., `my_project`).

---

## 🐘 Database Management (Docker)
*Commands must be run from the `your_project_server` directory.*

- **Start Database:** `docker compose up`
- **Start in Background:** `docker compose up -d`
- **Stop Database:** `docker compose down`

---

## 🚀 Running the Application

### 1. Start the Server
Navigate to the server directory:
```bash
cd my_project_server
dart run bin/main.dart --apply-migrations

# Terminal 1: Start database & server
cd eloquim_server
docker-compose up -d
serverpod generate
serverpod create-migration
serverpod run

# Terminal 2: Run Flutter app
cd eloquim_flutter
flutter pub get
flutter run