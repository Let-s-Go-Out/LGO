import 'package:flutter/material.dart';
import '../diary_page.dart';

class DiaryView extends StatelessWidget {
  final int monthIndex;
  //final DateTime selectedDate;
  const DiaryView({
    Key? key,
    required this.monthIndex,
    //required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 216, 216, 216),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 8.0),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜
            Text(
              '날짜',
              textScaleFactor: 3.5,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}