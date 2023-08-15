import 'package:flutter/material.dart';
import './View/home_page.dart';
import 'package:firebase_core/firebase_core.dart';  // Firebase 초기화를 위해 추가
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nagaja_app/View/home_page.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nagaja_app/View/home.dart';
import 'package:nagaja_app/View/main_page.dart';
import 'package:nagaja_app/View/main_page_loading.dart';
import 'package:nagaja_app/firebase_options.dart';

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
      title: "Let's Go Out",
      theme: ThemeData( // Define the default brightness and colors.
        primaryColor: Colors.black,
        // Define the default font family.
        fontFamily: 'Georgia',
      ),
      home: MyAppHomePage(),
      initialRoute: '/', // Set the initial route
      getPages: [
        GetPage(name: '/', page: () => HomePage()), // Define routes here
        /*
        GetPage(name: 'myPage', page: () => MyPage()),
        GetPage(name: 'pwEdit', page: () => PasswordEdit()),
        GetPage(name: 'nicknameEdit', page: () => NicknameEdit() ),
        GetPage(name: 'splash', page: () => Splash()),
         */
      ],// Set the main page as the home screen
    );
  }
}
