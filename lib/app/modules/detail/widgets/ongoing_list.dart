import 'package:basic_todolist/app/core/utils/extensions.dart';
import 'package:basic_todolist/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnGoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  OnGoingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeCtrl.onGoingTodos.isEmpty && homeCtrl.completedTodos.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 10.0.percentHeight,
                ),
                Image.asset(
                  'assets/images/task.png',
                  fit: BoxFit.cover,
                  width: 65.0.percentWidth,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    homeCtrl.newTaskTextFocusNode.requestFocus();
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 1.0.percentHeight,
                      ),
                      Text(
                        'Add Tasks',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0.sp,
                          fontFamily: GoogleFonts.combo().fontFamily,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                if (homeCtrl.onGoingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0.percentWidth,
                      vertical: 3.0.percentWidth,
                    ),
                    child: Text(
                      'On Going (${homeCtrl.onGoingTodos.length})',
                      style: TextStyle(
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: GoogleFonts.combo().fontFamily,
                      ),
                    ),
                  ),
                ...homeCtrl.onGoingTodos
                    .map(
                      (e) => Dismissible(
                        key: ObjectKey(e),
                        direction: DismissDirection.horizontal,
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
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            homeCtrl.newTaskTextFocusNode.requestFocus();
                            homeCtrl.newTaskTextController.text = e.title;
                            homeCtrl.isEditing.value = true;
                            homeCtrl.editOnGoingTodo(e.title);
                          } else {
                            homeCtrl.deleteOnGoingTodo(e.title);
                          }
                          homeCtrl.updateTodos();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.0.percentWidth,
                            horizontal: 8.5.percentWidth,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.resolveWith((states) => Colors.grey),
                                  value: e.completed,
                                  onChanged: (value) {
                                    homeCtrl.doneTodo(e.title);
                                    homeCtrl.updateTodos();
                                  },
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.0.percentWidth),
                                  child: Text(
                                    e.title,
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
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
                if (homeCtrl.onGoingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                      left: 5.0.percentWidth,
                      right: 5.0.percentWidth,
                    ),
                    child: Divider(
                      color: Colors.grey[300]!,
                      thickness: 2,
                    ),
                  ),
              ],
            ),
    );
  }
}
