import 'package:equatable/equatable.dart';
import 'package:datapack/models/tool_model.dart';

abstract class ToolState extends Equatable {
  const ToolState();

  @override
  List<Object> get props => [];
}

class ToolInitialState extends ToolState {}

class ToolLoadingState extends ToolState {}

class ToolLoadedState extends ToolState {
  final List<Tool> tools;

  const ToolLoadedState(this.tools);

  @override
  List<Object> get props => [tools];
}

class ToolErrorState extends ToolState {
  final String message;

  const ToolErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ToolActionInProgressState extends ToolState {
  final String message;

  const ToolActionInProgressState(this.message);

  @override
  List<Object> get props => [message];
}

class ToolActionSuccessState extends ToolState {
  final String message;

  const ToolActionSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class ToolActionErrorState extends ToolState {
  final String message;

  const ToolActionErrorState(this.message);

  @override
  List<Object> get props => [message];
}
