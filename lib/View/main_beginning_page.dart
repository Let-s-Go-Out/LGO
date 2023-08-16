import 'package:flutter/material.dart';
import 'main_page.dart';

class MainBeginningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // App bar 배경색 검정색으로 수정
        title: SizedBox.shrink(), // App bar에 있는 텍스트를 없애기
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '나가자!\n시작할까요?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // 버튼 배경색 검정색으로 수정
              ),
              child: Text('GO'),
            ),
          ],
        ),
      ),
    );
  }
}

