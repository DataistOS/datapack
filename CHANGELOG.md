# Changelog

## [v0.4.0] - 2026-06-06

### Major Features & Additions
- **Industry Workspaces Integration:** Added comprehensive industry-specific taxonomies and base packages ranging from Dataist core and AgriTech to Retail Services (`assets/taxonomies/`).
- **Dynamic System Storage Monitoring:** Integrated real-time partition metrics tracking via system `df` commands, rendered dynamically inside the `SystemStorageCard` component.
- **Enhanced UI & Workflows:** Introduced dedicated workspace management pages, interactive tool stacks installation dialogs via terminal integration, and smooth shimmer loading placeholders.

### Improvements & Refactoring
- **Core Services Overhaul:** Upgraded platform commands, caching mechanisms, settings, tray services, and API handlers for robust Linux desktop execution.
- **Model & State Updates:** Refined `Tool` and `Workspace` models with enhanced null-safety and structured resource links (GitHub, Telegram, Docs, etc.).
- **Codebase Cleanliness:** Addressed syntax compilation and formatting across core features and presentation layers.

## [0.3.0] - 2026-11-01

### Added
- **System Tray Support:** Integrated native system tray (`tray_manager`) enabling background minimization, quick window toggling, and app quit actions.
- **Advanced Window Management:** Configured robust window controls (`window_manager`) ensuring proper sizing, centering, and state handling on Linux/Desktop.
- **Interactive Terminal Dialog:** Added dedicated terminal execution and feedback dialogs (`terminal_dialog.dart`) for package operations.
- **Settings Page:** Introduced a new dedicated settings page (`settings_page.dart`) to customize application preferences.
- **Core Modular Services:** Implemented clean architecture services:
    - `LoggingService`: Comprehensive logging for app actions and debugging.
    - `CacheService` & `SettingsService`: Persistent local storage and preference handling.
    - `UpdateService`: Version tracking and update management infrastructure.
- **App Branding:** Configured professional desktop and tray launcher icons using `flutter_launcher_icons`.

### Changed
- **UI & UX Improvements:** Refined layout, clean card designs, and professional tool management workspace.
- **Navigation & Filtering:** Polished custom app bars, smart search bars with debouncing, sorting/filtering bars, and smooth refresh controls.
- **CI/CD & Release Pipeline:** Updated `release.yml` to automatically build optimized Linux and Arch-compatible release artifacts upon pushing version tags.

## [0.2.0] - 2026-10-15

### Added
- **System Integration:** Implemented `PlatformDetector` and `SystemCommands` in `core/platform` for native OS/Linux package management (`dpkg`, `apt`).
- **Network Layer:** Added dedicated `ApiService` in `core/services` to handle clean HTTP interactions and file downloads.
- **UI/UX Enhancements:** Integrated Vazir font as default typography and upgraded `ToolDetailPage` with a modern card-based layout.
- **App Assets:** Added high-resolution application branding (logos and app icons) across Android, iOS, and Web.

### Changed
- **Architecture Refactoring:** Migrated state management from BLoC (`ToolBloc`) to `Provider` and `ChangeNotifier` (`ToolProvider`).
- **Project Structure:** Reorganized codebase to a scalable feature-first architecture (`features/tools/data`, `presentation/pages`, `presentation/widgets`).
- **Security & Config:** Moved remote endpoints (e.g., `REGISTRY_URL`) to `.env` configuration file with documented comments.

### Removed
- **Unused State Management:** Removed all legacy BLoC files (`tool_bloc.dart`, `tool_event.dart`, `tool_state.dart`).

## [0.1.1] - 2026-07-04

### Added
- GitHub Actions workflow for automated releases.
- Cleaned and standardized `.gitignore` for Flutter/Dart and platform-specific artifacts.

### Fixed
- Resolved `type 'Null' is not a subtype of type 'String'` error in `Tool.fromJson` by implementing null-aware parsing.
- Fixed broken build pipeline paths due to project directory migration.

### Changed
- Updated `pubspec.yaml` version to 0.1.1.