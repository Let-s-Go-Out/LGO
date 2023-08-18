import 'package:flutter/material.dart';
import './View/home_page.dart';
import 'package:firebase_core/firebase_core.dart';  // Firebase 초기화를 위해 추가
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 디버그 리본 삭제
      debugShowCheckedModeBanner: false,
      title: "Let's Go Out",
      theme: ThemeData( // Define the default brightness and colors.
        primaryColor: Colors.black,
        // Define the default font family.
        fontFamily: 'Georgia',
      ),
      initialRoute: '/', // Set the initial route
      getPages: [
        GetPage(name: '/', page: () => HomePage()), // Define routes here

      ],// Set the main page as the home screen
    );
  }
}
