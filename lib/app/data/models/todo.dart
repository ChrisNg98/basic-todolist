import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String title;
  final bool completed;

  ///CONSTRUCTOR
  const Todo({
    required this.title,
    this.completed = false,
  });

  Todo copyWith({
    String? title,
    bool? completed,
  }) {
    return Todo(
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
    };
  }

  @override
  List<Object?> get props => [title];
}
