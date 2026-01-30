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
- **Networking**: `http` package
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
  - `TodoRemoteDataSource`: Interfaces with the Backend API.

### 3. Presentation Layer (`lib/features/todo/presentation`)
- **BLoC**: `TodoBloc` manages the state of the Todo list and handles events.
- **Pages/Widgets**: UI components using the BLoC for data.

### 4. Core Layer (`lib/core`)
- **Sync**: `SyncManager` handles the complex logic of Pushing local changes and Pulling remote changes.
- **Database**: `AppDatabase` (Drift) setup and table definitions.
- **Network**: `NetworkInfo` for connectivity checks.

---

## 🔄 Synchronization Strategy (Offline-First)

The app uses a robust sync mechanism to ensure data consistency between the mobile device and the server.

### Key Concepts:
- **`syncId`**: A client-generated UUID used as the primary identifier across both local and remote databases.
- **Soft Delete**: Todos are marked with `isDeleted = true` instead of being removed immediately, allowing the delete action to sync to the server.
- **`isSynced` Flag**: Tracks whether local changes have been successfully pushed to the server.
- **Version Tracking**: Uses a `version` field for conflict resolution (higher version wins).

### Sync Flow (`SyncManager`):
1. **Push**: Gathers all todos where `isSynced = false`.
   - Sends new todos to `POST /todos`.
   - Sends updates to `PUT /todos/:id`.
   - Sends deletes to `DELETE /todos/:id`.
2. **Pull**:
   - Calls `GET /todos/sync?since=<last_sync_time>`.
   - Merges changes into the local Drift database.
   - Updates the `lastSyncTime` locally.

---

## 📊 Data Schema Highlights (`Todo` Entity)
- `syncId` (String): UUID
- `title` (String)
- `description` (String)
- `isCompleted` (Boolean)
- `isDeleted` (Boolean)
- `version` (Integer)
- `createdAt` (DateTime)
- `updatedAt` (DateTime)
- `isSynced` (Boolean) - *Local Database Only*
