import 'package:basic_todolist/app/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskStatus {
  List<Widget> statusWidget(Color color, String title, int value) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 3.0.percentWidth,
                  width: 3.0.percentWidth,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color,
                      width: 0.5.percentWidth,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.percentWidth, left: 0.5.percentWidth),
                child: Text(value.toString(),
                    style: TextStyle(
                      fontSize: 17.0.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.combo().fontFamily,
                    )),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 7.8.percentWidth,
              top: 0.5.percentWidth,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.0.sp,
                fontFamily: GoogleFonts.combo().fontFamily,
              ),
            ),
          ),
        ],
      )
    ];
  }
}
