/// SubtaskTile widget.
///
/// Renders a single [Subtask] inside a kanban column. Shows the subtask
/// title together with a small meta line (`username  date`) and exposes
/// slide-to-action gestures (delete / share / archive / save).
library;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:getx/models/subtask.dart';
import 'package:getx/theme/app_theme.dart';

class SubtaskTile extends StatefulWidget {
  const SubtaskTile({
    super.key,
    required this.subtask,
    required this.goal,
    required this.TechStack,
    required this.slidekey,
    required this.ondelete,
    required this.dueDate,
  });
  final String goal;
  final String dueDate;
  final String TechStack;
  final Subtask subtask;
  final Key slidekey;
  final VoidCallback ondelete;

  @override
  State<SubtaskTile> createState() => _SubtaskTileState();
}

class _SubtaskTileState extends State<SubtaskTile> {
  bool isExpanded = false;

  String buildmetaline() {
    final d = widget.subtask.date;
    String two(int n) => n.toString().padLeft(2, '0');
    final formatted =
        '${d.year}-${two(d.month)}-${two(d.day)} '
        '${two(d.hour)}:${two(d.minute)}';
    final user =
        widget.subtask.username.isEmpty ? 'unknown' : widget.subtask.username;
    return '$user  $formatted';
  }

  void confirmdelete(BuildContext _) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Delete subtask',
      desc: 'Are you sure you want to delete "${widget.subtask.title}"?',
      btnCancelOnPress: () {},
      btnOkOnPress: () => widget.ondelete(),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.slidekey,
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
   
    //   Column(
    //   children: [
    //      Icon(Icons.star),
    //     Text("0"),
    //     Text("|"),
    //     Text("|"),
    //     Text("|"),
    //     Text("0"),
    //     Text("|"),
    //     Text("|"),
    //     Text("|"),
    //   ],
    // ),
   
          SlidableAction(
            onPressed: confirmdelete,
            backgroundColor: const Color.fromARGB(255, 13, 83, 110),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          const SlidableAction(
            onPressed: null,
            backgroundColor: AppColors.info,
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),
      endActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: null,
            backgroundColor: AppColors.archive,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: null,
            backgroundColor: AppColors.save,
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(Icons.star),
                Text(""),
                Text(""),
                if (isExpanded) ...[
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 15, 87, 219),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                    height: 70,
                    child: Container(
                      decoration: BoxDecoration(
                        color:const Color.fromARGB(255, 15, 87, 219),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color:const Color.fromARGB(255, 15, 87, 219),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                    height: 70,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 15, 87, 219),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 15, 87, 219),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                    height: 70,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 15, 87, 219),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 15, 87, 219),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExpansionTile(
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isExpanded = expanded;
                      });
                    },
                    title: Text(
                      widget.subtask.title,
                      style: const TextStyle(fontSize: 14),
                    ),
                    // subtitle: Text('Leading expansion arrow icon'),
                    controlAffinity: ListTileControlAffinity.leading,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.description),
                        title: const Text('Describtion'),
                        subtitle: Text('Create by ${widget.subtask.username}'),
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      ListTile(
                        leading: const Icon(Icons.task_alt),
                        title: const Text('Goal'),
                        subtitle: Text(widget.goal),
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      ListTile(
                        leading: const Icon(Icons.code),
                        title: const Text('Tech Stack'),
                        subtitle: Text(widget.TechStack),
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      ListTile(
                        leading: const Icon(Icons.calendar_month),
                        title: const Text('Due Date'),
                        subtitle: Text(widget.dueDate),
                      ),
                    ],
                  ),
                  // Text(
                  //   subtask.title,
                  //   style: const TextStyle(fontSize: 14),
                  // ),
                  const SizedBox(height: 2),
                  Text(
                    buildmetaline(),
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
