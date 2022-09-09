import 'package:basic_todolist/app/core/utils/extensions.dart';
import 'package:basic_todolist/app/modules/home/controller.dart';
import 'package:basic_todolist/app/modules/report/widgets/task_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Obx(
        () {
          var totalCreatedTaskTodos = homeCtrl.getTotalTaskCreatedTodos;
          var totalTaskCompletedTodos = homeCtrl.getTotalTaskCompletedTodos;
          var totalLiveTaskTodos = totalCreatedTaskTodos - totalTaskCompletedTodos;
          var percentage = (totalTaskCompletedTodos / totalCreatedTaskTodos * 100).toStringAsFixed(0);
          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.percentWidth),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        homeCtrl.changeTabIndex(0);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0.percentWidth),
                child: Row(
                  children: [
                    Icon(
                      Icons.assessment_rounded,
                      color: Colors.blue[800]!,
                      size: 12.0.percentWidth,
                    ),
                    SizedBox(
                      width: 3.0.percentWidth,
                    ),
                    Text(
                      'My Report',
                      style: TextStyle(
                        fontSize: 25.0.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.combo().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 7.0.percentWidth,
                  vertical: 3.0.percentWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMMMMd().format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontFamily: GoogleFonts.combo().fontFamily,
                        )),
                    SizedBox(
                      height: 2.0.percentWidth,
                    ),
                    Divider(
                      color: Colors.grey[350]!,
                      thickness: 2.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 7.0.percentWidth,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ...TaskStatus().statusWidget(Colors.green, 'Live Tasks', totalLiveTaskTodos),
                    ...TaskStatus().statusWidget(Colors.orange, 'Completed', totalTaskCompletedTodos),
                    ...TaskStatus().statusWidget(Colors.blue, 'Created', totalCreatedTaskTodos),
                  ],
                ),
              ),
              SizedBox(
                height: 12.0.percentWidth,
              ),
              UnconstrainedBox(
                child: SizedBox(
                  width: 70.0.percentWidth,
                  height: 70.0.percentWidth,
                  child: CircularStepProgressIndicator(
                    totalSteps: totalCreatedTaskTodos < 1 ? 1 : totalCreatedTaskTodos,
                    currentStep: totalTaskCompletedTodos < 1 ? 0 : totalTaskCompletedTodos,
                    stepSize: 20,
                    selectedColor: Colors.greenAccent,
                    unselectedColor: Colors.grey[200],
                    padding: 0,
                    width: 150,
                    height: 150,
                    selectedStepSize: 20,
                    roundedCap: (_, __) => true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${totalCreatedTaskTodos == 0 ? 0 : percentage}%',
                          style: TextStyle(
                            fontSize: 25.0.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.combo().fontFamily,
                          ),
                        ),
                        SizedBox(
                          height: 2.0.percentWidth,
                        ),
                        Text(
                          homeCtrl.getTaskCompletedStatus,
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            fontFamily: GoogleFonts.combo().fontFamily,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ));
  }
}
