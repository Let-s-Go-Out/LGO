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
<<<<<<< HEAD
    return MaterialApp(
      title: "Let's Go Out",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
=======
    return GetMaterialApp(
      title: 'Outing Routes App',
      theme: ThemeData( // Define the default brightness and colors.
        primaryColor: Colors.black,
        // Define the default font family.
        fontFamily: 'Georgia',
      ),
      home: MyAppHomePage(), // Set the main page as the home screen
>>>>>>> GaEun
    );
  }
}