import 'package:flutter/material.dart';
import 'package:nagaja_app/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outing Routes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(), // Set the main page as the home screen
    );
  }
}