import 'package:flutter/material.dart';
import '../diary_page.dart';
import 'package:nagaja_app/View/widgets/diary_edit_view.dart';

class DiaryView extends StatelessWidget {
  final int monthIndex;

  const DiaryView({
    Key? key,
    required this.monthIndex,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Diary\n작성하러 갈까요?',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
                  textAlign: TextAlign.center
              ),
            ),
          ],
        ),
      ),
    );
  }
}