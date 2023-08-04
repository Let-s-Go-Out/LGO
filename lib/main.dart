import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Set status bar color to transparent
    statusBarIconBrightness: Brightness.dark, // Set status bar icons to dark color
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top, // Enable manual control of the status bar
    SystemUiOverlay.bottom, // Enable manual control of the navigation bar (if present)
  ]);
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