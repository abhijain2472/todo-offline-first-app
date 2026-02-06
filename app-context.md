# Application Context: Todo Offline-First App

This document provides a high-level overview of the application's architecture, tech stack, and core logic to aid AI agents and developers in understanding the codebase.

## 🚀 Project Overview
**Name**: `todo-offline-first-app`
**Goal**: A task management application built with an **offline-first** architecture, ensuring users can manage todos without internet connectivity and sync changes when online.

---

## 🛠 Tech Stack
- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **Local Database**: [Drift](https://drift.simonbinder.eu/) (Reactive persistence library for Flutter/Dart, SQLite-based)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
- **Persistence**: `shared_preferences` for key-value storage (Theme settings).
- **Networking**: `http` package with a custom **`NetworkClient` abstraction** for centralized logging and error handling.
- **Architecture**: **Clean Architecture** (Domain, Data, Presentation layers)

---

## 🏗 Architecture Layers

### 1. Domain Layer (`lib/features/todo/domain`)
- **Entities**: Business objects (e.g., `Todo`).
- **Repositories**: Abstract definitions of data operations.
- **Use Cases**: Specific business rules (e.g., `CreateTodo`, `SyncTodos`).

### 2. Data Layer (`lib/features/todo/data`)
- **Models**: DTOs for JSON and Database mapping.
- **Repositories Implementation**: Coordinates between Local and Remote data sources.
- **Data Sources**:
  - `TodoLocalDataSource`: Interfaces with Drift (SQLite).
  - `TodoRemoteDataSource`: Interfaces with the Backend API via `NetworkClient`.

### 3. Presentation Layer (`lib/features/todo/presentation`, `lib/features/theme/presentation`, `lib/features/settings`)
- **features/todo**:
    - **BLoC**: `TodoBloc` manages the state of the Todo list and handles events.
    - **Pages**: `TodoListScreen`, `AddEditTodoScreen`.
- **features/theme**:
    - **BLoC**: `ThemeBloc` manages app-wide theme state (Light/Dark/System).
- **features/settings**:
    - **Pages**: `SettingsPage` centralized configuration screen.

### 4. Data Layer Extensions
- **Theme**: `ThemeLocalDataSource` uses `shared_preferences` to persist user theme choice.

### 4. Core Layer (`lib/core`)
- **Sync**: `SyncManager` handles the high-level orchestration of Pushing and Pulling changes, including **automatic sync on connectivity recovery**.
- **Database**: `AppDatabase` (Drift) setup and table definitions.
- **Network**: 
  - `NetworkInfo`: Connectivity checks and change streams.
  - `NetworkClient`: Abstract interface for HTTP operations.
  - `HttpNetworkClient`: Implementation with centralized logging and status-code error checking.

---

## 🔄 Synchronization Strategy (Offline-First)

The app uses a robust sync mechanism to ensure data consistency between the mobile device and the server.

### Key Concepts:
- **`syncId`**: A client-generated UUID used as the primary identifier across both local and remote databases.
- **Soft Delete**: Todos are marked with `isDeleted = true` instead of being removed immediately.
- **`isSynced` Flag**: A local-only flag used for UI indicators (e.g., cloud icon). *It is no longer the primary source of truth for synchronization.*
- **Version Tracking**: Every user update increments the `version` field locally. The Outbox uses this version to distinguish between `create` (v1) and `update` (v>1) actions.
- **Typed Failure Resilience**: The sync engine handles specific failure types (`NotFoundFailure`, `ConflictFailure`) instead of generic string matching. This ensures robust and deterministic error recovery for "Already Exists" (409) and "Not Found" (404) scenarios.
- **Auto-Sync**: The app automatically triggers a sync when moving from **Offline to Online**.

### 6. Typed Failure Resilience & Versioning
- **Typed Failure Handling**: Replaced brittle string comparisons in `SyncManager` with robust typed catch blocks (`NotFoundFailure`, `ConflictFailure`).
- **HTTP/Protocol Awareness**: `HttpNetworkClient` now maps 404 (Not Found) and 409 (Conflict) status codes to these specific failure types, providing clear domain-specific error handling.
- **Automatic Versioning**: The `TodoRepositoryImpl` now automatically increments the `version` field during every update, allowing the Outbox to correctly choose between `POST` and `PATCH`.

### Sync Flow (`SyncManager`):
1. **Outbox Pattern**: Instead of scanning the `todos` table, the app maintains a **`SyncOutbox`** table (Transactional Outbox Pattern).
2. **Push**:
   - Every local write (create/update/delete) is part of a transaction that also writes an "action" and the "full JSON payload" to the Outbox.
   - `SyncManager` processes these actions sequentially.
   - Actions are deleted from the Outbox only after a successful network response.
   - Failed actions track `retryCount` and `lastError` for robustness.
3. **Pull**:
   - Calls `GET /todos/sync?since=<last_sync_time>`.
   - Merges changes into the local Drift database using **`upsertTodo`** (Server wins).
   - `upsertTodo` is a local-only write that skips the Outbox to prevent infinite sync loops.
   - Updates the `lastSyncTime` locally.

---

## 📊 Data Schema Highlights

### `Todo` Table
- `syncId` (String): UUID
- `title` (String)
- `description` (String)
- `isCompleted` (Boolean)
- `isDeleted` (Boolean)
- `version` (Integer)
- `createdAt` (DateTime)
- `updatedAt` (DateTime)
- `isSynced` (Boolean) - *Local UI state only*

### `SyncOutbox` Table
- `id` (Integer): Auto-increment PK
- `syncId` (String)
- `action` (Enum): `create` | `update` | `delete` (Stored as Text)
- `payload` (String): Full JSON snapshot
- `retryCount` (Integer)
- `lastError` (String)
- `createdAt` (DateTime)
