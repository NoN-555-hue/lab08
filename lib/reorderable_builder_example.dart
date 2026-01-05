import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/task.dart';

class ReorderableBuilderExample extends StatefulWidget {
  const ReorderableBuilderExample({super.key});

  @override
  State<ReorderableBuilderExample> createState() =>
      _ReorderableBuilderExampleState();
}

class _ReorderableBuilderExampleState extends State<ReorderableBuilderExample> {
  final List<Task> _tasks = [
    Task(id: '1', title: 'เรียนรู้ ListView', description: 'Part 1'),
    Task(id: '2', title: 'เข้าใจ Key', description: 'Part 2'),
    Task(id: '3', title: 'ใช้ Dismissible', description: 'Part 3'),
    Task(id: '4', title: 'Drag and Drop', description: 'Part 4'),
    Task(id: '5', title: 'รวมทุกอย่าง', description: 'Part 5'),
  ];

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final task = _tasks.removeAt(oldIndex);
      _tasks.insert(newIndex, task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Priority'), centerTitle: true),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),

        // จำนวน items
        itemCount: _tasks.length,

        // Callback เมื่อ reorder
        onReorder: _onReorder,

        // Builder function - สร้าง Widget ตาม index
        itemBuilder: (context, index) {
          final task = _tasks[index];

          return Card(
            // Key ต้องอยู่ที่ root widget ที่ return
            key: ValueKey(task.id),
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: task.isCompleted
                    ? Colors.green
                    : Theme.of(context).primaryColor,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Text(task.description),
              trailing: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
            ),
          );
        },

        // Optional: ปรับแต่ง widget ขณะลาก
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final double elevation = lerpDouble(0, 8, animation.value)!;
              return Material(
                elevation: elevation,
                borderRadius: BorderRadius.circular(12),
                shadowColor: Colors.black26,
                child: child,
              );
            },
            child: child,
          );
        },
      ),
    );
  }
}
