import 'package:basic_todolist/app/data/provides/provider.dart';
import 'package:basic_todolist/app/data/services/storage/repository.dart';
import 'package:basic_todolist/app/modules/home/controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        taskRepository: TaskRepository(
          taskProvider: TaskProvider(),
        ),
      ),
    );
  }
}
