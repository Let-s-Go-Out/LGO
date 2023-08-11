import 'package:flutter/material.dart';
import 'package:nagaja_app/View/diary_page.dart';
import 'package:nagaja_app/View/diary_page_2.dart';
import 'package:nagaja_app/View/main_page.dart';
import 'package:nagaja_app/View/my_page.dart';

class MyAppHomePage extends StatefulWidget {
  const MyAppHomePage({super.key});

  @override
  State<MyAppHomePage> createState() => _MyAppHomePageState();
}

class _MyAppHomePageState extends State<MyAppHomePage> {
  // Bottom Navigation Bar 옵션 설정

  int _selectedIndex = 0;

  final List<Widget> _navIndex = [
    MainPage(),
    SecondDiaryPage(),
    MyPage(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navIndex.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mypage',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
