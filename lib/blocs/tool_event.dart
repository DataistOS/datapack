import 'package:equatable/equatable.dart';

abstract class ToolEvent extends Equatable {
  const ToolEvent();

  @override
  List<Object> get props => [];
}

class FetchToolsEvent extends ToolEvent {}

class InstallToolEvent extends ToolEvent {
  final String packageName;

  const InstallToolEvent(this.packageName);

  @override
  List<Object> get props => [packageName];
}

class UninstallToolEvent extends ToolEvent {
  final String packageName;

  const UninstallToolEvent(this.packageName);

  @override
  List<Object> get props => [packageName];
}

class SearchToolsEvent extends ToolEvent {
  final String query;

  const SearchToolsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class SortToolsEvent extends ToolEvent {
  final String sortOption;

  const SortToolsEvent(this.sortOption);

  @override
  List<Object> get props => [sortOption];
}
