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
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 날짜
            Text(
              '2023.08.14',
              //textScaleFactor: 3.5,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            // 나들이 경로

            const Spacer(),
            // 사진
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  child: Center(
                    child: Text('Upload from gallery', style: TextStyle(fontSize: 8)),
                  ),
                ),
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  child: Center(
                    child: Text('Upload from gallery', style: TextStyle(fontSize: 8),),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // 한 줄 일기
            Container(
              width: 250,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Center(
                  child: Text('한 줄 일기', style: TextStyle(fontSize: 8))
              ),
            ),
          ],
        ),
      ),
    );
  }
}