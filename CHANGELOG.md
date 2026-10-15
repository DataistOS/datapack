# Changelog

## [0.2.0] - 2026-10-15
### Added
- **System Integration**: Implemented `PlatformDetector` and `SystemCommands` in `core/platform` for native OS/Linux package management (`dpkg`, `apt`).
- **Network Layer**: Added dedicated `ApiService` in `core/services` to handle clean HTTP interactions and file downloads.
- **UI/UX Enhancements**: Integrated Vazir font as default typography and upgraded `ToolDetailPage` with a modern card-based layout.
- **App Assets**: Added high-resolution application branding (logos and app icons) across Android, iOS, and Web.
### Changed
- **Architecture Refactoring**: Migrated state management from BLoC (`ToolBloc`) to `Provider` and `ChangeNotifier` (`ToolProvider`).
- **Project Structure**: Reorganized codebase to a scalable feature-first architecture (`features/tools/data`, `presentation/pages`, `presentation/widgets`).
- **Security & Config**: Moved remote endpoints (e.g., `REGISTRY_URL`) to `.env` configuration file with documented comments.
### Removed
- **Unused State Management**: Removed all legacy BLoC files (`tool_bloc.dart`, `tool_event.dart`, `tool_state.dart`).

## [0.1.1] - 2026-07-04
### Fixed
- Resolved `type 'Null' is not a subtype of type 'String'` error in `Tool.fromJson` by implementing null-aware parsing.
- Fixed broken build pipeline paths due to project directory migration.
### Added
- GitHub Actions workflow for automated releases.
- Cleaned and standardized `.gitignore` for Flutter/Dart and platform-specific artifacts.
### Changed
- Updated `pubspec.yaml` version to 0.1.1.