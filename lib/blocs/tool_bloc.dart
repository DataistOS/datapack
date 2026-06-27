import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:datapack/models/tool_model.dart';
import 'package:datapack/blocs/tool_event.dart';
import 'package:datapack/blocs/tool_state.dart';

class ToolBloc extends Bloc<ToolEvent, ToolState> {
  final String _toolsUrl =
      dotenv.env['REGISTRY_URL'] ??
      'https://raw.githubusercontent.com/DataistOS/datapackverse/refs/heads/heuristic/tools.json';

  ToolBloc() : super(ToolInitialState()) {
    on<FetchToolsEvent>(_onFetchTools);
    on<InstallToolEvent>(_onInstallTool);
    on<UninstallToolEvent>(_onUninstallTool);
  }

  Future<void> _onFetchTools(
    FetchToolsEvent event,
    Emitter<ToolState> emit,
  ) async {
    emit(ToolLoadingState());
    try {
      final response = await http.get(Uri.parse(_toolsUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final tools = await Future.wait(
          data.map((item) async {
            final tool = Tool.fromJson(item);
            final bool isInstalled = await _isToolInstalled(tool.name);
            final String? installedVersion = await _getInstalledVersion(
              tool.name,
            );
            final bool hasUpdate =
                isInstalled && installedVersion != tool.version;

            return tool.copyWith(
              isInstalled: isInstalled,
              hasUpdate: hasUpdate,
            );
          }).toList(),
        );

        emit(ToolLoadedState(tools));
      } else {
        emit(ToolErrorState('Failed to load tools: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ToolErrorState('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onInstallTool(
    InstallToolEvent event,
    Emitter<ToolState> emit,
  ) async {
    emit(
      ToolActionInProgressState(
        'Downloading and installing ${event.packageName}...',
      ),
    );
    try {
      final currentState = state;
      if (currentState is ToolLoadedState) {
        final tool = currentState.tools.firstWhere(
          (t) => t.name == event.packageName,
        );

        final client = http.Client();
        final response = await client.get(Uri.parse(tool.debFile));

        if (response.statusCode == 200) {
          final file = File('/tmp/${tool.name}.deb');
          await file.writeAsBytes(response.bodyBytes);

          final result = await Process.run(
            'sudo',
            ['apt-get', 'install', '-y', file.path],
            environment: {'DEBIAN_FRONTEND': 'noninteractive'},
          );

          if (result.exitCode == 0) {
            emit(
              ToolActionSuccessState('${tool.name} installed successfully!'),
            );
          } else {
            emit(ToolActionErrorState('Install failed: ${result.stderr}'));
          }
        } else {
          emit(ToolActionErrorState('Download failed: ${response.statusCode}'));
        }
      }
    } catch (e) {
      emit(ToolActionErrorState('Error: $e'));
    } finally {
      add(FetchToolsEvent());
    }
  }

  Future<bool> _isToolInstalled(String packageName) async {
    try {
      final result = await Process.run('dpkg', ['-s', packageName]);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _getInstalledVersion(String packageName) async {
    try {
      final result = await Process.run('dpkg-query', [
        '-f',
        '\${Version}',
        '-W',
        packageName,
      ]);
      if (result.exitCode == 0 && result.stdout.isNotEmpty)
        return (result.stdout as String).trim();
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _onUninstallTool(
    UninstallToolEvent event,
    Emitter<ToolState> emit,
  ) async {
    emit(ToolActionInProgressState('Uninstalling...'));
    final result = await Process.run('sudo', [
      'apt-get',
      'remove',
      '-y',
      event.packageName,
    ]);
    if (result.exitCode == 0)
      emit(ToolActionSuccessState('Uninstalled!'));
    else
      emit(ToolActionErrorState('Failed: ${result.stderr}'));
    add(FetchToolsEvent());
  }
}
