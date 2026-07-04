## [0.1.1] - 2026-07-04
### Fixed
- Resolved `type 'Null' is not a subtype of type 'String'` error in `Tool.fromJson` by implementing null-aware parsing.
- Fixed broken build pipeline paths due to project directory migration.

### Added
- GitHub Actions workflow for automated releases.
- Cleaned and standardized `.gitignore` for Flutter/Dart and platform-specific artifacts.

### Changed
- Updated `pubspec.yaml` version to 0.1.1.