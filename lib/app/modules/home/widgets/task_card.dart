import 'package:basic_todolist/app/core/utils/extensions.dart';
import 'package:basic_todolist/app/data/models/task.dart';
import 'package:basic_todolist/app/modules/detail/view.dart';
import 'package:basic_todolist/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TaskCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  final Task task;
  TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = HexColor.fromHex(task.color);
    var squareWidth = Get.width - 12.0.percentWidth;
    return GestureDetector(
      onTap: () {
        homeCtrl.taskSelected(task);
        homeCtrl.changeTodos(task.todos ?? []);
        Get.to(() => DetailPage());
      },
      // onTap: () async {
      //   if (task.todos == null) {
      //     await Get.defaultDialog(
      //       titlePadding: EdgeInsets.symmetric(vertical: 5.0.percentWidth),
      //       barrierDismissible: false,
      //       radius: 15,
      //       title: 'No Todos',
      //       content: Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 3.0.percentWidth),
      //         child: Text(
      //           'Please add some todos to this task',
      //           textAlign: TextAlign.center,
      //           style: TextStyle(fontSize: 12.0.sp),
      //         ),
      //       ),
      //       confirm: ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //           primary: blue,
      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      //           minimumSize: const Size(100, 40),
      //         ),
      //         child: const Text('Confirm'),
      //         onPressed: () {
      //           Get.back();
      //         },
      //       ),
      //     );
      //   } else {
      //     homeCtrl.taskSelected(task);
      //     homeCtrl.changeTodos(task.todos ?? []);
      //     Get.to(() => DetailPage());
      //   }
      // },
      child: Container(
        width: squareWidth / 2,
        height: squareWidth / 2,
        margin: EdgeInsets.all(3.0.percentWidth),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 7,
              offset: const Offset(0, 7), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TODO change after finish TODO CRUD
            StepProgressIndicator(
              totalSteps: 100,
              currentStep: 80,
              size: 5,
              padding: 0,
              selectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.5), color],
              ),
              unselectedGradientColor: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.0.percentWidth),
              child: Icon(
                IconData(task.icon, fontFamily: 'MaterialIcons'),
                color: color,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.0.percentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.0.percentWidth),
                  Text(
                    '${task.todos?.length ?? 0} Tasks',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
