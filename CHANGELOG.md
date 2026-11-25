# Changelog

## [0.6.1] - 2026-11-25

### Added
- Refined UpUpa (Hodhod) source settings card and configuration handling in settings flow.

### Fixed
- Resolved all static analysis (`dart analyze`) warnings and deprecation notices across presentation widgets, pages, and services.
- Addressed `BuildContext` usage across async boundaries to improve widget lifecycle safety.
- Prevented `MissingPluginException` from `setToolTip` on Linux (`tray_manager` `0.5.3`) by guarding platform-unsupported calls and adding idempotent initialization in `TrayService`.

### Changed
- Migrated color opacity calls from `.withOpacity(...)` to `.withValues(alpha: ...)` for precision and Flutter SDK compatibility.
- Updated project version metadata (`VERSION` and `pubspec.yaml`) to `0.6.1`.

## [0.6.0] - 2026-11-23

### Added
- **Multi-Source Package Architecture:** Introduced `PackageSourceProvider`, `ToolSource`, and `ToolSourceResolver` to aggregate and resolve packages across multiple sources (such as GitHub Releases and UpUpa/Hadaf servers).
- **UpUpa / Hadaf Backend Integration:** Added `UpUpaSourceProvider` powered by `upupa_dart` to query package records from configurable collections and resolve package download URLs.
- **UpUpa Settings UI & Persistence:** Added `UpUpaSourceSettingsCard` and `SettingsService` support to toggle the UpUpa source and persist server URLs and collection names.
- **Source Selector in Tool Details:** Added `SourceSelectorDropdown` and updated `ToolHeaderCard` and `ToolDetailPage` so users can inspect source metadata (URL, format, channel, version) and switch the active source.

### Changed
- **Source-Aware Installation Flow:** Updated `ToolProvider.installTool`, `ToolCard`, and `ToolListPage` to pass `ToolSourceResolver` and download/install packages from the selected source.
- **Dependencies & Project Metadata:** Added the local `upupa_dart` path dependency, set `publish_to: none` in `pubspec.yaml`, bumped `VERSION` to `0.6.0`, and updated `test/widget_test.dart` for `MyApp(isFirstRun: ...)`.

## [0.4.0] - 2026-06-06

### Major Features & Additions
- **Industry Workspaces Integration:** Added industry-specific taxonomies and base packages spanning Dataist core, AgriTech, and Retail Services (`assets/taxonomies/`).
- **Dynamic System Storage Monitoring:** Added real-time partition metric tracking via system `df` commands, rendered dynamically in `SystemStorageCard`.
- **Enhanced UI & Workflows:** Added dedicated workspace management pages, interactive terminal dialogs for tool stack installation, and smooth shimmer loading placeholders.

### Improvements & Refactoring
- **Core Services Overhaul:** Upgraded platform commands, caching, settings, tray services, and API handlers for reliable Linux desktop execution.
- **Model & State Updates:** Refined `Tool` and `Workspace` models with stronger null-safety and structured resource links (GitHub, Telegram, Docs, etc.).
- **Codebase Cleanliness:** Fixed syntax compilation and formatting issues across core features and presentation layers.

## [0.3.0] - 2026-11-01

### Added
- **System Tray Support:** Integrated native system tray support (`tray_manager`) for background minimization, quick window toggling, and quitting the app.
- **Advanced Window Management:** Configured window controls (`window_manager`) for proper sizing, centering, and state handling on Linux/Desktop.
- **Interactive Terminal Dialog:** Added terminal dialogs (`terminal_dialog.dart`) to display live execution output and feedback during package operations.
- **Settings Page:** Added a dedicated settings page (`settings_page.dart`) for customizing application preferences.
- **Core Modular Services:** Implemented modular services for core workflows:
  - `LoggingService`: Application action logging and debugging support.
  - `CacheService` & `SettingsService`: Persistent local storage and preference management.
  - `UpdateService`: Version tracking and update management infrastructure.
- **App Branding:** Configured desktop and tray launcher icons using `flutter_launcher_icons`.

### Changed
- **UI & UX Improvements:** Refined layouts, card designs, and the overall package management workspace.
- **Navigation & Filtering:** Improved custom app bars, debounced search bars, sort/filter bars, and refresh controls.
- **CI/CD & Release Pipeline:** Updated `release.yml` to build Linux and Arch-compatible release artifacts automatically when pushing version tags.

## [0.2.0] - 2026-10-15

### Added
- **System Integration:** Implemented `PlatformDetector` and `SystemCommands` under `core/platform` for native Linux package management (`dpkg`, `apt`).
- **Network Layer:** Added `ApiService` under `core/services` for clean HTTP requests and file downloads.
- **UI/UX Enhancements:** Set Vazir as the default font and updated `ToolDetailPage` with a modern card-based layout.
- **App Assets:** Added high-resolution logos and app icons across Android, iOS, and Web.

### Changed
- **Architecture Refactoring:** Migrated state management from BLoC (`ToolBloc`) to `Provider` and `ChangeNotifier` (`ToolProvider`).
- **Project Structure:** Reorganized the codebase into a feature-first structure (`features/tools/data`, `presentation/pages`, `presentation/widgets`).
- **Security & Config:** Moved remote endpoints (such as `REGISTRY_URL`) into `.env` with documented comments.

### Removed
- **Unused State Management:** Removed legacy BLoC files (`tool_bloc.dart`, `tool_event.dart`, `tool_state.dart`).

## [0.1.1] - 2026-07-04

### Added
- Added a GitHub Actions workflow for automated releases.
- Cleaned up and standardized `.gitignore` for Flutter/Dart and platform build artifacts.

### Fixed
- Fixed `type 'Null' is not a subtype of type 'String'` in `Tool.fromJson` with null-aware parsing.
- Fixed broken build pipeline paths after directory migration.

### Changed
- Updated `pubspec.yaml` version to `0.1.1`.