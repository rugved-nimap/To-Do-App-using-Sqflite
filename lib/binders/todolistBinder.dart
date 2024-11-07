import 'package:get/get.dart';
import 'package:todo/controllers/toDoListController.dart';

class Todolistbinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => Todolistcontroller(),
    );
  }
}
