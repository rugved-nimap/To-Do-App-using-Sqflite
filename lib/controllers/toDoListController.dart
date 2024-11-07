import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/model/task_data_model.dart';

import '../database/database_service.dart';

class Todolistcontroller extends GetxController {
  List<TaskDataModel> toDoList = [];

  final DatabaseService databaseService = DatabaseService.instance;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() async {
    toDoList = await databaseService.getToDoList();
    update();
    super.onInit();
  }

  int generateUniqueId() {
    int newId;
    do {
      newId = Random().nextInt(10000);
    } while (toDoList.any((task) => task.id == newId));

    return newId;
  }

  void addTaskToList() {
    showDialogBox(
      'Add Task',
      'Enter Task here',
      'Add',
      () {
        if (textEditingController.text.toString().isNotEmpty &&
            textEditingController.text.trim().toString() != "") {
          int id = generateUniqueId();
          toDoList.add(TaskDataModel(
              id: id,
              task: textEditingController.text,
              status: 0,
              currentTimeStamp: DateTime.now().millisecondsSinceEpoch));
          databaseService.addTaskToDatabase(id, textEditingController.text, 0);
        }

        textEditingController.clear();
        Get.back();
        update();
      },
    );
  }

  void updateTaskInList(int id) {
    showDialogBox(
      'Add Task',
      'Enter Task here',
      'Add',
      () {
        if (textEditingController.text.toString().isNotEmpty &&
            textEditingController.text.trim().toString() != "") {
          int index = toDoList.indexWhere((element) => element.id == id);

          toDoList[index].task = textEditingController.text.toString();

          databaseService.changeTaskToDatabase(
              id, textEditingController.text.toString());
        }

        textEditingController.clear();
        Get.back();
        update();
      },
    );
  }

  void deleteTaskInList(int id) {
    int index = toDoList.indexWhere((element) => element.id == id);
    toDoList.removeAt(index);
    databaseService.deleteTaskFromDatabase(id);
    update();
  }

  void completeTaskInList(int id) {
    int index = toDoList.indexWhere((element) => element.id == id);
    toDoList[index].status = 1;
    databaseService.changeStatusToDatabase(id, 1);
    update();
  }

  void uncompleteTaskInList(int id) {
    int index = toDoList.indexWhere((element) => element.id == id);
    toDoList[index].status = 0;
    databaseService.changeStatusToDatabase(id, 0);
    update();
  }

  void showDialogBox(
      String title, String hint, String button, VoidCallback todoFunction) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      content: TextField(
        keyboardType: TextInputType.multiline,
        controller: textEditingController,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: todoFunction,
          style: const ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              backgroundColor: WidgetStatePropertyAll(Colors.lightGreen)),
          child: Text(button),
        ),
      ],
    );
  }
}
