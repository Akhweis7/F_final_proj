import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/task.dart';
import '../models/subtask.dart';

class KanbanController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = true.obs;

  StreamSubscription? _subscription;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _tasksRef =>
      _db.collection('users').doc(_uid).collection('tasks');

  @override
  void onInit() {
    super.onInit();
    _listenToTasks();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _listenToTasks() {
    _subscription = _tasksRef
        .orderBy('createdAt')
        .snapshots()
        .listen((snapshot) {
      tasks.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Task.fromMap({'id': doc.id, ...data});
      }).toList();
      isLoading.value = false;
    });
  }

  Future<void> addTask({
    required String title,
    required int durationMinutes,
  }) async {
    await _tasksRef.add({
      'title': title,
      'durationMinutes': durationMinutes,
      'subtasks': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addSubtask(String taskId, String title, String username) async {
    final subtask = Subtask(title: title, username: username);
    await _tasksRef.doc(taskId).update({
      'subtasks': FieldValue.arrayUnion([subtask.toMap()]),
    });
  }

  Future<void> deleteSubtask(String taskId, Subtask subtask) async {
    final doc = await _tasksRef.doc(taskId).get();
    final data = doc.data() as Map<String, dynamic>;
    final updated = (data['subtasks'] as List)
        .where((s) => s['id'] != subtask.id)
        .toList();
    await _tasksRef.doc(taskId).update({'subtasks': updated});
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksRef.doc(taskId).delete();
  }
}
