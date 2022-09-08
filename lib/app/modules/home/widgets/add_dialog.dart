import 'package:basic_todolist/app/core/utils/extensions.dart';
import 'package:basic_todolist/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddDialog extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(3.0.percentWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                    homeCtrl.newTaskTextController.clear();
                    homeCtrl.changeTask(null);
                  },
                  icon: const Icon(Icons.close),
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    if (homeCtrl.newTaskTextController.text.isNotEmpty) {
                      if (homeCtrl.task.value == null) {
                        EasyLoading.showError('Please select a task type');
                      } else {
                        var success = homeCtrl.updateTask(
                          homeCtrl.task.value!,
                          homeCtrl.newTaskTextController.text,
                        );
                        if (success) {
                          Get.back();
                          homeCtrl.newTaskTextController.clear();
                          homeCtrl.changeTask(null);
                          EasyLoading.showSuccess('Todo item added successfully');
                        } else {
                          EasyLoading.showError('Todo item already exists');
                        }
                      }
                    } else {
                      EasyLoading.showError('Please enter a task title');
                    }
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: 14.0.sp),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.percentWidth),
            child: Text(
              'New Task',
              style: TextStyle(
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.percentWidth),
            child: TextFormField(
              controller: homeCtrl.newTaskTextController,
              decoration: InputDecoration(
                hintText: 'Enter your task',
                hintStyle: TextStyle(fontSize: 14.0.sp),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your task title';
                }
                return null;
              },
              autofocus: true,
              style: TextStyle(fontSize: 14.0.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 5.0.percentWidth,
              left: 5.0.percentWidth,
              right: 5.0.percentWidth,
              bottom: 2.0.percentWidth,
            ),
            child: Text(
              'Add to',
              style: TextStyle(
                fontSize: 14.0.sp,
                color: Colors.grey,
              ),
            ),
          ),
          ...homeCtrl.tasks
              .map(
                (element) => Obx(
                  () => InkWell(
                    onTap: () => homeCtrl.changeTask(element),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 3.0.percentWidth,
                        horizontal: 5.0.percentWidth,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                IconData(
                                  element.icon,
                                  fontFamily: 'MaterialIcons',
                                ),
                                color: HexColor.fromHex(element.color),
                              ),
                              SizedBox(
                                width: 3.0.percentWidth,
                              ),
                              Text(
                                element.title,
                                style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (homeCtrl.task.value == element)
                            const Icon(
                              Icons.check,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
