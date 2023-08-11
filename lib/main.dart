<<<<<<< HEAD
/*
import 'package:flutter/material.dart';
import './views/home_page.dart';
import 'package:firebase_core/firebase_core.dart';  // Firebase 초기화를 위해 추가

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Firebase 초기화
  runApp(MyApp());
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_go_out/View/home_page.dart';
=======
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nagaja_app/View/home.dart';
import 'package:nagaja_app/View/main_page.dart';
import 'package:nagaja_app/View/main_page_loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nagaja_app/firebase_options.dart';

>>>>>>> 45f67e51b94ae5e6c9c23c1c75ba9a391866e52f

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
    );
  }
}
=======
    return GetMaterialApp(
      title: 'Outing Routes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAppHomePage(), // Set the main page as the home screen
    );
  }
}
>>>>>>> 45f67e51b94ae5e6c9c23c1c75ba9a391866e52f
