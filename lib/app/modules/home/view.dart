import 'package:basic_todolist/app/core/utils/extensions.dart';
import 'package:basic_todolist/app/core/values/colors.dart';
import 'package:basic_todolist/app/data/models/task.dart';
import 'package:basic_todolist/app/modules/home/controller.dart';
import 'package:basic_todolist/app/modules/home/widgets/add_card.dart';
import 'package:basic_todolist/app/modules/home/widgets/add_dialog.dart';
import 'package:basic_todolist/app/modules/home/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0.percentWidth),
              child: Text(
                'My List',
                style: TextStyle(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Obx(
              () => GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  ...controller.tasks
                      .map(
                        (element) => LongPressDraggable(
                          data: element,
                          onDragStarted: () => controller.changeDeleting(true),
                          onDraggableCanceled: (_, __) => controller.changeDeleting(false),
                          onDragEnd: (_) => controller.changeDeleting(false),
                          feedback: Opacity(
                            opacity: 0.8,
                            child: TaskCard(task: element),
                          ),
                          child: TaskCard(task: element),
                        ),
                      )
                      .toList(),
                  AddCard(),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: DragTarget(
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              backgroundColor: controller.deleting.value ? Colors.red : Colors.blue,
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(() => AddDialog(), transition: Transition.downToUp);
                } else {
                  EasyLoading.showError('Please create your task type first');
                }
              },
              child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
            ),
          );
        },
        onAccept: (Task task) async {
          await Get.defaultDialog(
            titlePadding: EdgeInsets.symmetric(vertical: 5.0.percentWidth),
            barrierDismissible: false,
            radius: 15,
            title: 'Delete Task',
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0.percentWidth),
              child: Text('Are you sure you want to delete this task?', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0.sp)),
            ),
            confirm: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                minimumSize: const Size(100, 40),
              ),
              child: const Text('Confirm'),
              onPressed: () {
                controller.deleteTask(task);
                EasyLoading.showSuccess('Task deleted');
                Get.back();
              },
            ),
            cancel: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                minimumSize: const Size(100, 40),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Get.back();
              },
            ),
          );
        },
      ),
    );
  }
}
