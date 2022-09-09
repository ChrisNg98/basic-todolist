import 'package:basic_todolist/app/core/utils/extensions.dart';
import 'package:basic_todolist/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CompletedList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  CompletedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeCtrl.completedTodos.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0.percentWidth,
                    vertical: 3.0.percentWidth,
                  ),
                  child: Text(
                    'Completed (${homeCtrl.completedTodos.length})',
                    style: TextStyle(
                      fontSize: 15.0.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: GoogleFonts.combo().fontFamily,
                    ),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    ...homeCtrl.completedTodos
                        .map(
                          (element) => Dismissible(
                            key: ObjectKey(element),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                homeCtrl.newTaskTextFocusNode.requestFocus();
                                homeCtrl.newTaskTextController.text = element.title;
                                homeCtrl.isEditing.value = true;
                                homeCtrl.editCompletedTodo(element.title);
                              } else {
                                homeCtrl.deleteCompletedTodo(element.title);
                              }
                              homeCtrl.updateTodos();
                            },
                            background: Container(
                              color: Colors.yellow.withOpacity(0.8),
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.0.percentWidth,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red.withOpacity(0.8),
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.0.percentWidth,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 4.0.percentWidth,
                                horizontal: 8.5.percentWidth,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      fillColor: MaterialStateProperty.resolveWith((states) => Colors.grey),
                                      value: element.completed,
                                      onChanged: (value) {
                                        homeCtrl.undoneTodo(element.title);
                                        homeCtrl.updateTodos();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.0.percentWidth),
                                      child: Text(
                                        element.title,
                                        style: TextStyle(
                                          fontSize: 12.0.sp,
                                          decoration: TextDecoration.lineThrough,
                                          fontFamily: GoogleFonts.combo().fontFamily,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ],
            )
          : Container(),
    );
  }
}
