import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/toDoListController.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Todolistcontroller>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'To Do List',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.purple.shade100,
          ),
          body: ListView.builder(
            itemCount: controller.toDoList.length,
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.purple.shade50),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            controller.toDoList[index].status == 1
                                ? Icons.task_alt_rounded
                                : Icons.pending_actions_sharp,
                            color: controller.toDoList[index].status == 1
                                ? Colors.lightGreen
                                : Colors.redAccent.shade100,
                          )),
                      Expanded(
                        child: Text(
                          controller.toDoList[index].task,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'update') {
                            controller.textEditingController.text = controller.toDoList[index].task;
                            controller.updateTaskInList(controller.toDoList[index].id);
                          } else if (value == 'completed') {
                            controller.completeTaskInList(
                                controller.toDoList[index].id);
                          } else if (value == 'delete') {
                            controller.deleteTaskInList(
                                controller.toDoList[index].id);
                          } else if (value == 'not_completed') {
                            controller.uncompleteTaskInList(
                                controller.toDoList[index].id);
                          }
                        },
                        itemBuilder: (context) {
                          return <PopupMenuEntry<String>>[
                            const PopupMenuItem(
                                value: 'update', child: Text('Update')),
                            controller.toDoList[index].status == 0
                                ? const PopupMenuItem(
                                    value: 'completed',
                                    child: Text('Completed'))
                                : const PopupMenuItem(
                                    value: 'not_completed',
                                    child: Text('Not-Completed')),
                            const PopupMenuItem(
                                value: 'delete', child: Text('Delete')),
                          ];
                        },
                      )
                    ],
                  ));
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.addTaskToList();
            },
            backgroundColor: Colors.purple.shade100,
            elevation: 5,
            child: Icon(Icons.add, color: Colors.purple.shade900),
          ),
        );
      },
    );
  }
}
