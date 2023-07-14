import 'package:flutter/material.dart';

class MainLoadingPage extends StatelessWidget {
  const MainLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
            'AI가 나들이 코스를 계획하고 있어요',
            style: TextStyle(fontSize: 20, color:Colors.black),
        ),
        // loading 완료 후

      ),
    );
  }
}
