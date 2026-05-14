import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/controllers/kanban_controller.dart';
import 'package:getx/views/screens/kanban.dart';

class KanbanBoardScreen extends StatelessWidget {
  const KanbanBoardScreen({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KanbanController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Kanban Board - $username'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildAddColumnBar(context, controller),
          Expanded(child: _buildBoard(controller)),
        ],
      ),
    );
  }

  Widget _buildAddColumnBar(BuildContext context, KanbanController controller) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showAddColumnDialog(controller),
          icon: const Icon(Icons.add),
          label: const Text('Add Column'),
        ),
      ),
    );
  }

  void _showAddColumnDialog(KanbanController controller) {
    final nameController = TextEditingController();
    final minutesController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('New Column'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Column name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final minutes = int.tryParse(minutesController.text.trim()) ?? 0;
              if (name.isEmpty) return;
              controller.addTask(
                title: name,
                durationMinutes: minutes,
              );
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildBoard(KanbanController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.tasks.isEmpty) {
        return const Center(
          child: Text(
            'No columns yet. Add one above to get started.',
            style: TextStyle(color: Colors.black54),
          ),
        );
      }
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.tasks.length,
        itemBuilder: (context, index) {
          final task = controller.tasks[index];
          return KanbanColumn(
            goal: 'Goal',
            TechStack: 'TechStack',
            dueDate: 'Due Date',
            task: task,
            onaddsubtask: (title) =>
                controller.addSubtask(task.id, title, username),
            ondeletesubtask: (subtask) =>
                controller.deleteSubtask(task.id, subtask),
            ondeletetask: () => controller.deleteTask(task.id),
          );
        },
      );
    });
  }
}
