import 'package:flutter/material.dart';
import 'package:nagaja_app/View/main_route_page.dart';

class MainLoadingPage extends StatelessWidget {
  const MainLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'AI is planning an outing course',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 16), // Add some space between the text and the button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainRoutePage()),
                );
              },
              child: Text('경로안내 페이지로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}