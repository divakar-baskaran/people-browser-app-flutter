# People Browser App

## Overview

A Flutter app that fetches people from the [Random User API](https://randomuser.me/), shows them in a searchable list, and opens a detail screen with contact and location information. It uses **Material 3** (light and dark themes), **Riverpod** for state, and **Dio** for HTTP, with loading, error, and empty states handled in the UI.

---

## Tech stack

| Layer      | Choice                                                                                          |
|------------|-------------------------------------------------------------------------------------------------|
| UI         | Flutter, Material 3 (`useMaterial3: true`), system light/dark                                   |
| State      | `flutter_riverpod` (`StateNotifier` + `StateNotifierProvider`)                                  |
| Networking | Dio (`people_repo_impl.dart`)                                                                   |
| Data       | Random User API JSON → `PeopleModel` / `Result` in `lib/features/people/data/model/person.dart` |

---

## Project structure

```
lib/
├── main.dart                          # App entry, `ProviderScope`, theme
├── core/
│   ├── network/
│   │   ├── logging_interceptor.dart   # Debug API logging (`dart:developer` log, Dio bridge)
│   │   └── server.dart                # `Request` enum for log labels
│   └── utils/
│       └── check_null.dart            # Safe parsing helpers for JSON
└── features/people/
    ├── domain/repository/             # `PeopleRepo` interface
    ├── data/
    │   ├── model/person.dart          # API models + `ResultPresentation` helpers
    │   └── repository/
    │       └── people_repo_impl.dart  # Dio client, debug logging interceptor
    └── presentation/
        ├── provider/                  # `PeopleState`, `PeopleProvider`
        └── pages/                     # List + detail screens
```

---

## Features

- **List**: Fetches a batch of users, **pull-to-refresh**, **client-side search** by full name (first + last).
- **Detail**: Name, photo (hero transition from list), email, tags (country, age, gender), contact, location, and account fields from the API payload.
- **Networking**: In **debug** builds, HTTP traffic is traced via a custom **`LoggingInterceptor`** (wired through **`DioLoggingInterceptor`**); release builds do not register that interceptor from the repository factory.
- **Resilience**: Loading indicator, error state with retry, and empty / no-results messaging.

---

## How to run

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (SDK `>=3.0.0 <4.0.0` per `pubspec.yaml`).
2. From the project root:

   ```bash
   flutter pub get
   flutter run
   ```

3. Optional: `flutter analyze` to check for analysis issues.

---

## Testing

There are **no automated tests** in the repository at the moment. A sensible next step would be unit tests for parsing (`PeopleModel.fromJson`) and widget or integration tests for the list and search flow.

---

## Possible improvements

- Pagination or infinite scroll for larger result sets.
- Local caching and offline behavior.
- Automated tests (models, repository, widgets).
- Richer error types and user-facing messages from HTTP status codes.
