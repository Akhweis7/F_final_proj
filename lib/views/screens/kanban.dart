import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/models/subtask.dart';
import 'package:getx/models/task.dart';
import 'package:getx/theme/app_theme.dart';
import 'package:getx/views/screens/subtask_tile.dart';

const double kColumnWidth = 260;

class KanbanColumn extends StatefulWidget {
  const KanbanColumn({
    super.key,
    required this.task,
    required this.onaddsubtask,
    required this.ondeletesubtask,
    required this.ondeletetask,
    required this.goal,
    required this.TechStack,
    required this.dueDate,
  });

  final Task task;
  final ValueChanged<String> onaddsubtask;
  final ValueChanged<Subtask> ondeletesubtask;
  final VoidCallback ondeletetask;
  final String goal;
  final String TechStack;
  final String dueDate;

  @override
  State<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends State<KanbanColumn> {
  final TextEditingController _newsubtaskcontroller = TextEditingController();

  @override
  void dispose() {
    _newsubtaskcontroller.dispose();
    super.dispose();
  }

  void submitnewsubtask() {
    final text = _newsubtaskcontroller.text.trim();
    if (text.isEmpty) return;
    widget.onaddsubtask(text);
    _newsubtaskcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kColumnWidth,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.columnBody,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _ColumnHeader(
            task: widget.task,
            ondeletetask: widget.ondeletetask,
          ),
          buildaddsubtaskrow(),
          Expanded(child: buildsubtasklist()),
        ],
      ),
    );
  }

  Widget buildaddsubtaskrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _newsubtaskcontroller,
              onSubmitted: (_) => submitnewsubtask(),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'New subtask',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Add subtask',
            icon: const Icon(Icons.add_circle, color: AppColors.accent),
            onPressed: submitnewsubtask,
          ),
        ],
      ),
    );
  }

  Widget buildsubtasklist() {
    final subtasks = widget.task.subtasks;
    if (subtasks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No subtasks yet.',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: subtasks.length,
      itemBuilder: (context, index) {
        final subtask = subtasks[index];
        return SubtaskTile(
          slidekey: ValueKey('${widget.task.title}-$index-${subtask.title}'),
          subtask: subtask,
          goal: widget.goal,
          TechStack: widget.TechStack,
          dueDate: widget.dueDate,
          ondelete: () => widget.ondeletesubtask(subtask),
        );
      },
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  const _ColumnHeader({required this.task, required this.ondeletetask});

  final Task task;
  final VoidCallback ondeletetask;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: task.effectiveDeadline != null
          ? Stream.periodic(const Duration(seconds: 1), (i) => i)
          : const Stream.empty(),
      builder: (context, _) {
        final failed = task.isFailed;
        final remaining = task.timeRemaining;

        String? statusLabel;
        Color statusColor = Colors.green;

        if (task.effectiveDeadline != null) {
          if (failed) {
            statusLabel = 'FAILED';
            statusColor = Colors.red.shade300;
          } else if (remaining != null) {
            final hours = remaining.inHours;
            final mins = remaining.inMinutes % 60;
            final secs = remaining.inSeconds % 60;
            if (hours > 0) {
              statusLabel = '${hours}h ${mins}m ${secs}s left';
            } else if (mins > 0) {
              statusLabel = '${mins}m ${secs}s left';
            } else {
              statusLabel = '${secs}s left';
            }
            statusColor = remaining.inMinutes < 30
                ? Colors.orange.shade300
                : Colors.green.shade300;
          }
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: failed ? Colors.red.shade700 : AppColors.columnHeader,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (statusLabel != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            color: failed ? Colors.white : statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.white70, size: 20),
                tooltip: 'Delete column',
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Delete Column'),
                      content:
                          Text('Delete "${task.title}" and all its subtasks?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            Get.back();
                            ondeletetask();
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
