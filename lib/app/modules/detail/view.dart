import 'package:basic_todolist/app/core/utils/extensions.dart';
import 'package:basic_todolist/app/modules/detail/widgets/completed_list.dart';
import 'package:basic_todolist/app/modules/detail/widgets/ongoing_list.dart';
import 'package:basic_todolist/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DetailPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();

  DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      Expanded(
                        child: Text(
                          homeCtrl.selectedTask.value!.title,
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.combo().fontFamily,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                              homeCtrl.totalTodosCount < 1 ? '0 Tasks' : '${homeCtrl.totalCompletedTodosCount}/${homeCtrl.totalTodosCount} Tasks Completed',
                              style: TextStyle(
                                fontSize: 11.0.sp,
                                color: Colors.grey,
                                fontFamily: GoogleFonts.combo().fontFamily,
                              ),
                            ),
                            SizedBox(
                              height: 0.5.percentHeight,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: StepProgressIndicator(
                                      totalSteps: (homeCtrl.totalTodosCount) < 1 ? 1 : (homeCtrl.totalTodosCount),
                                      currentStep: homeCtrl.completedTodos.length,
                                      size: 10.0,
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
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.0.percentWidth,
                  horizontal: 5.0.percentWidth,
                ),
                child: TextFormField(
                  controller: homeCtrl.newTaskTextController,
                  style: TextStyle(
                    fontFamily: GoogleFonts.combo().fontFamily,
                  ),
                  focusNode: homeCtrl.newTaskTextFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Add a new task',
                    hintStyle: TextStyle(
                      fontSize: 12.0.sp,
                      color: Colors.grey[400]!,
                      fontFamily: GoogleFonts.combo().fontFamily,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 2.0,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey[400]!,
                    ),
                    suffixIcon: homeCtrl.isEditing.value
                        ? IconButton(
                            splashRadius: 20.0,
                            onPressed: () {
                              if (homeCtrl.newTaskTextController.text.isNotEmpty) {
                                var success = homeCtrl.addTodo(homeCtrl.newTaskTextController.text);
                                if (success) {
                                  homeCtrl.newTaskTextFocusNode.unfocus();
                                  EasyLoading.showSuccess('Todo item added successfully');
                                } else {
                                  EasyLoading.showError('Todo item already exists');
                                }
                                homeCtrl.updateTodos();
                                homeCtrl.resetIsEditingStatus();
                                homeCtrl.newTaskTextController.clear();
                              }
                            },
                            icon: Icon(
                              Icons.done,
                              color: Colors.black,
                              size: 15.0.sp,
                            ),
                          )
                        : null,
                  ),
                  cursorHeight: 15.0.sp,
                  onChanged: (value) {
                    homeCtrl.isEditingStatus(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your todo item';
                    }
                    return null;
                  },
                ),
              ),
            ),
            OnGoingList(),
            CompletedList(),
          ],
        ),
      ),
    );
  }
}
