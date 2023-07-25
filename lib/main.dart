import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nagaja_app/View/home.dart';
import 'package:nagaja_app/View/main_page.dart';
import 'package:nagaja_app/View/main_page_loading.dart';
import 'package:firebase_core/firebase_core.dart';
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
      title: 'Outing Routes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAppHomePage(), // Set the main page as the home screen
    );
  }
}