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
  final newTaskTextFocusNode = FocusNode();
  final chipIndex = 0.obs;
  final tabIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final selectedTask = Rx<Task?>(null);
  final onGoingTodos = <Todo>[].obs;
  final completedTodos = <Todo>[].obs;
  final isEditing = false.obs;
  RxInt totalTodos = 0.obs;

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
    newTaskTextFocusNode.dispose();
    super.onClose();
  }

  int get totalTodosCount {
    return onGoingTodos.length + completedTodos.length;
  }

  int get totalCompletedTodosCount {
    return completedTodos.length;
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void resetIsEditingStatus() {
    isEditing.value = false;
  }

  void isEditingStatus(String value) {
    if (value.isNotEmpty) {
      isEditing.value = true;
    } else {
      isEditing.value = false;
    }
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

  void updateTodos() {
    var newTodos = <Todo>[];
    newTodos.addAll([
      ...onGoingTodos,
      ...completedTodos,
    ]);

    var newTask = selectedTask.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(selectedTask.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
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

  bool addTodo(String title) {
    var todo = Todo(
      title: title,
    );

    ///if t.odo exist in onGoingTodos or completedTodos, return false
    if (onGoingTodos.contains(todo) || completedTodos.contains(todo)) {
      return false;
    }
    onGoingTodos.add(todo);
    return true;
  }

  void doneTodo(String title) {
    int index = onGoingTodos.indexWhere((e) => e.title == title);
    onGoingTodos.removeAt(index);
    completedTodos.add(
      Todo(
        title: title,
        completed: true,
      ),
    );
    onGoingTodos.refresh();
    completedTodos.refresh();
  }

  void undoneTodo(String title) {
    int index = completedTodos.indexWhere((e) => e.title == title);
    completedTodos.removeAt(index);
    onGoingTodos.add(
      Todo(
        title: title,
        completed: false,
      ),
    );
    onGoingTodos.refresh();
    completedTodos.refresh();
  }

  void deleteCompletedTodo(String title) {
    int index = completedTodos.indexWhere((e) => e.title == title);
    completedTodos.removeAt(index);
    completedTodos.refresh();
  }

  void deleteOnGoingTodo(String title) {
    int index = onGoingTodos.indexWhere((e) => e.title == title);
    onGoingTodos.removeAt(index);
    onGoingTodos.refresh();
  }

  void editOnGoingTodo(String title) {
    int index = onGoingTodos.indexWhere((e) => e.title == title);
    onGoingTodos.removeAt(index);
    // onGoingTodos[index] = onGoingTodos[index].copyWith(title: newTaskTextController.text);
    onGoingTodos.refresh();
  }

  void editCompletedTodo(String title) {
    int index = completedTodos.indexWhere((e) => e.title == title);
    completedTodos.removeAt(index);
    // onGoingTodos[index] = onGoingTodos[index].copyWith(title: newTaskTextController.text);
    completedTodos.refresh();
  }

  bool isTodosEmpty(Task task) {
    if (task.todos == null || task.todos!.isEmpty) {
      return true;
    }
    return false;
  }

  int totalCompletedTodos(Task task) {
    if (task.todos == null || task.todos!.isEmpty) {
      return 0;
    }
    return task.todos!.where((e) => e.completed).toList().length;
  }

  int get getTotalTaskCreatedTodos {
    ///get total tasks todos
    var totalTodos = 0;
    for (var task in tasks) {
      if (task.todos != null) {
        totalTodos += task.todos!.length;
      }
    }
    return totalTodos;
  }

  int get getTotalTaskCompletedTodos {
    ///get total tasks completed todos
    var totalCompletedTodos = 0;
    for (var task in tasks) {
      if (task.todos != null) {
        totalCompletedTodos += task.todos!.where((e) => e.completed).toList().length;
      }
    }
    return totalCompletedTodos;
  }

  String get getTaskCompletedStatus {
    var percentage = 0;
    if (getTotalTaskCreatedTodos != 0) {
      percentage = (getTotalTaskCompletedTodos / getTotalTaskCreatedTodos * 100).round();
    }
    if (percentage < 1) {
      return 'Try Harder!';
    } else if (percentage < 30) {
      return 'Keep Going!';
    } else if (percentage < 50) {
      return 'Good Job!';
    } else if (percentage < 70) {
      return 'Almost There!';
    } else if (percentage < 100) {
      return 'Almost There!';
    } else {
      return 'You\'re Awesome!';
    }
  }
}
