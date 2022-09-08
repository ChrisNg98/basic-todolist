import 'package:basic_todolist/app/core/utils/extensions.dart';
import 'package:basic_todolist/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DetailPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task.value;
    var color = HexColor.fromHex(homeCtrl.selectedTask.value!.color);

    return Scaffold(
      body: Form(
        key: homeCtrl.formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(3.0.percentWidth),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                      homeCtrl.taskSelected(null);
                      homeCtrl.newTaskTextController.clear();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.percentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        IconData(homeCtrl.selectedTask.value!.icon, fontFamily: 'MaterialIcons'),
                        color: HexColor.fromHex(homeCtrl.selectedTask.value!.color),
                      ),
                      SizedBox(
                        width: 3.0.percentWidth,
                      ),
                      Text(
                        homeCtrl.selectedTask.value!.title,
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 9.0.percentWidth,
                          top: 0.25.percentHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${homeCtrl.selectedTask.value?.todos?.length ?? 0} Tasks',
                              style: TextStyle(
                                fontSize: 12.0.sp,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 0.5.percentHeight,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: StepProgressIndicator(
                                    totalSteps: homeCtrl.selectedTask.value?.todos?.length ?? 1,
                                    currentStep: homeCtrl.selectedTask.value?.todos?.where((element) => element.completed).length ?? 0,
                                    size: 5,
                                    padding: 0,
                                    selectedColor: HexColor.fromHex(homeCtrl.selectedTask.value?.color ?? '#000000'),
                                    selectedGradientColor: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        HexColor.fromHex(homeCtrl.selectedTask.value?.color ?? '#000000').withOpacity(0.5),
                                        HexColor.fromHex(homeCtrl.selectedTask.value?.color ?? '#000000'),
                                      ],
                                    ),
                                    unselectedGradientColor: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.grey[300]!, Colors.grey[300]!],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 2.0.percentWidth,
                horizontal: 5.0.percentWidth,
              ),
              child: TextFormField(
                controller: homeCtrl.newTaskTextController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Add a new task',
                  hintStyle: TextStyle(
                    fontSize: 12.0.sp,
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.grey[400],
                    size: 15.0.sp,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.done,
                      color: Colors.black,
                      size: 15.0.sp,
                    ),
                  ),
                ),
                cursorHeight: 15.0.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
