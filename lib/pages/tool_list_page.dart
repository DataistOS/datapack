import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:datapack/widget/custom_app_bar.dart';
import 'package:datapack/widget/tool_card_widget.dart';
import 'package:datapack/widget/sort_filter_bar.dart';
import 'package:datapack/blocs/tool_bloc.dart';
import 'package:datapack/blocs/tool_event.dart';
import 'package:datapack/blocs/tool_state.dart';

class ToolListPage extends StatefulWidget {
  const ToolListPage({super.key});

  @override
  State<ToolListPage> createState() => _ToolListPageState();
}

class _ToolListPageState extends State<ToolListPage> {
  final TextEditingController _searchController = TextEditingController();
  SortOption _currentSortOption = SortOption.nameAsc;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    context.read<ToolBloc>().add(FetchToolsEvent());
  }

  void _onInstallTool(BuildContext context, tool) {
    context.read<ToolBloc>().add(InstallToolEvent(tool.name));
  }

  void _onUninstallTool(BuildContext context, tool) {
    context.read<ToolBloc>().add(UninstallToolEvent(tool.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onRefresh: _onRefresh),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              leading: const Icon(Icons.search),
              hintText: 'Search for tools...',
            ),
          ),
          BlocBuilder<ToolBloc, ToolState>(
            builder: (context, state) {
              return SortFilterBar(
                selectedOption: _currentSortOption,
                onOptionChanged: (SortOption? newOption) {
                  if (newOption != null) {
                    setState(() {
                      _currentSortOption = newOption;
                    });
                  }
                },
              );
            },
          ),
          Expanded(
            child: BlocConsumer<ToolBloc, ToolState>(
              listener: (context, state) {
                if (state is ToolActionSuccessState) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is ToolActionErrorState) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is ToolLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ToolLoadedState) {
                  final tools = state.tools;
                  final searchTerm = _searchController.text.toLowerCase();
                  final filteredTools = tools.where((tool) {
                    final toolName = tool.name.toLowerCase();
                    final toolDescription =
                        tool.description?.toLowerCase() ?? '';
                    final toolTags = tool.tags.join(' ').toLowerCase();
                    return toolName.contains(searchTerm) ||
                        toolDescription.contains(searchTerm) ||
                        toolTags.contains(searchTerm);
                  }).toList();

                  filteredTools.sort((a, b) {
                    switch (_currentSortOption) {
                      case SortOption.nameAsc:
                        return a.name.compareTo(b.name);
                      case SortOption.nameDesc:
                        return b.name.compareTo(a.name);
                      case SortOption.versionAsc:
                        return a.version.compareTo(b.version);
                      case SortOption.versionDesc:
                        return b.version.compareTo(a.version);
                      case SortOption.tagsAsc:
                        if (a.tags.isEmpty && b.tags.isEmpty) {
                          return 0;
                        }
                        if (a.tags.isEmpty) {
                          return 1;
                        }
                        if (b.tags.isEmpty) {
                          return -1;
                        }
                        return a.tags.first.compareTo(b.tags.first);
                    }
                  });

                  if (filteredTools.isEmpty) {
                    return const Center(
                      child: Text('No tools found for this search.'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ToolBloc>().add(FetchToolsEvent());
                    },
                    child: ListView.builder(
                      itemCount: filteredTools.length,
                      itemBuilder: (context, index) {
                        final tool = filteredTools[index];
                        return ToolCard(
                          tool: tool,
                          onInstall: _onInstallTool,
                          onUninstall: _onUninstallTool,
                        );
                      },
                    ),
                  );
                } else if (state is ToolActionInProgressState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(state.message),
                      ],
                    ),
                  );
                } else if (state is ToolErrorState) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
