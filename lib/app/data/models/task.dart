import 'package:basic_todolist/app/data/models/todo.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final int icon;
  final String color;
  final List<Todo>? todos;

  ///CONSTRUCTOR
  const Task({
    required this.title,
    required this.icon,
    required this.color,
    this.todos,
  });

  Task copyWith({
    String? title,
    int? icon,
    String? color,
    List<Todo>? todos,
  }) {
    return Task(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      todos: todos ?? this.todos,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] as String,
      icon: json['icon'] as int,
      color: json['color'] as String,
      todos: json['todos'] != null ? (json['todos'] as List).map((e) => Todo.fromJson(e)).toList() : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
      'color': color,
      'todos': todos,
    };
  }

  @override
  List<Object?> get props => [title, icon, color];
}
