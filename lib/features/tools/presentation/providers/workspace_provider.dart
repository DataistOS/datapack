// lib/features/tools/presentation/providers/workspace_provider.dart
import 'package:flutter/material.dart';
import 'package:datapack/features/tools/data/models/workspace_model.dart';
import 'package:datapack/features/tools/data/services/workspace_service.dart';

class WorkspaceProvider extends ChangeNotifier {
  final WorkspaceService _workspaceService = WorkspaceService();

  List<WorkspaceCategory> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<WorkspaceCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWorkspaces({bool forceRefresh = false}) async {
    if (_categories.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _workspaceService.loadWorkspaces();
    } catch (e) {
      _errorMessage = 'Failed to load workspaces: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
