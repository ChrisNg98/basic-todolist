import 'package:basic_todolist/app/data/models/task.dart';
import 'package:basic_todolist/app/data/models/todo.dart';
import 'package:basic_todolist/app/data/services/storage/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});
  final formKey = GlobalKey<FormState>();
  final editTextController = TextEditingController();
  final newTaskTextController = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final selectedTask = Rx<Task?>(null);
  final onGoingTodos = <Todo>[].obs;
  final completedTodos = <Todo>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    editTextController.dispose();
    newTaskTextController.dispose();
    super.onClose();
  }

  void changeChipIndex(int index) {
    chipIndex.value = index;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  void changeTask(Task? select) {
    if (task.value == select) {
      task.value = null;
    } else {
      task.value = select;
    }
  }

  void taskSelected(Task? select) {
    selectedTask.value = select;
  }

  void changeTodos(List<Todo> select) {
    onGoingTodos.assignAll(select.where((e) => !e.completed).toList());
    completedTodos.assignAll(select.where((e) => e.completed).toList());
  }

  bool updateTask(Task task, String title) {
    var todos = task.todos ?? [];
    if (containTodo(todos, title)) {
      return false;
    }
    var todo = Todo(title: title);
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  }

  bool containTodo(List todos, String title) {
    ///check if todos contain title
    for (var todo in todos) {
      if (todo.title == title) {
        return true;
      }
    }
    return false;
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }
}
