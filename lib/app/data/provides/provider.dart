import 'dart:convert';

import 'package:basic_todolist/app/core/utils/keys.dart';
import 'package:basic_todolist/app/data/models/task.dart';
import 'package:basic_todolist/app/data/services/storage/services.dart';
import 'package:get/get.dart';

class TaskProvider {
  StorageService storage = Get.find<StorageService>();

  List<Task> readTasks() {
    var tasks = <Task>[];
    jsonDecode(storage.read(taskKey).toString()).forEach((e) {
      tasks.add(Task.fromJson(e));
    });
    return tasks;
  }

  void writeTasks(List<Task> tasks) {
    storage.write(taskKey, jsonEncode(tasks));
  }
}
