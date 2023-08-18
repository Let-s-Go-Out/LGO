import 'dart:math';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nagaja_app/View/widgets/theme.dart';
import 'package:nagaja_app/View/widgets/diary_view.dart';
import 'package:nagaja_app/View/widgets/diary_edit_view.dart';
import 'package:nagaja_app/View/widgets/action_buttons.dart';

import 'main_page.dart';
import 'my_page.dart';

import 'package:firebase_auth/firebase_auth.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> with TickerProviderStateMixin {
  bool isFrontView = true;
  late User user; // yoojin) 사용자 정보 저장 변수
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late AnimationController controller;

  int _selectedIndex = 1;

  final List<Widget> _navIndex = [
    MainPage(),
    DiaryPage(),
    MyPage(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MainPage(),
            transitionDuration: Duration(seconds: 0), // 애니메이션 시간을 0으로 설정
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DiaryPage(),
            transitionDuration: Duration(seconds: 0), // 애니메이션 시간을 0으로 설정
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MyPage(),
            transitionDuration: Duration(seconds: 0), // 애니메이션 시간을 0으로 설정
          ),
        );
        break;
    // 다른 인덱스에 대한 처리를 추가할 수 있습니다.
    }
  }

  switchView() {
    setState(() {
      if (isFrontView) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _getCurrentUser(); //사용자 정보 가져오기
  }

  // 사용자 정보 가져오는 함수
  Future<void> _getCurrentUser() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        setState(() {
          user = currentUser; // user 객체에 사용자 정보 할당
        });
      }
    } catch (e) {
      print ("사용자 정보 가져오기 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            Text(
              "Diary",
              style: mainPageTitleStyle),
            const SizedBox(height: 5.0),

            // month cards
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: PageView.builder(
                  controller: PageController(
                    initialPage: 0,
                    viewportFraction: 0.78,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3, // 동적 생성
                  itemBuilder: (_, i) => AnimatedBuilder(
                      animation: controller,
                      builder: (_, child) {
                        if (controller.value >= 0.5) {
                          isFrontView = false;
                        } else {
                          isFrontView = true;
                        }

                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(controller.value * pi),
                          alignment: Alignment.center,
                          child: isFrontView
                              ? DiaryView(monthIndex: i + 1)
                              : Transform(
                            transform: Matrix4.rotationY(pi),
                            alignment: Alignment.center,
                            child: DiaryEditView(
                              user: user,
                              monthIndex: i + 1,
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
            const SizedBox(height: 2.0),
            // action buttons
            ActionButtons(change: switchView),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
