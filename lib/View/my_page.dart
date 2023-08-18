import 'package:flutter/material.dart';
import 'diary_page.dart';
import 'main_page.dart';
import 'my_page_out_buttons.dart';
import 'my_page_show_user_info.dart';
import 'profile_image_edit_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    int _selectedIndex = 2;
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // 글자 색
        title: Text(
          'my page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        mainAxisSize: MainAxisSize.max, // 전체 화면에 모든 위젯이 표시되도록 설정
        children: [

          // 프로필 이미지
          Expanded(
            flex: 2,
            child: ProfileImgEdit(),
          ),

          // Title: 내 정보 관리
          // 사용자 정보
          Expanded(
            flex: 6,
            child: ShowUserInfo(),
          ),

          // 로그아웃, 탈퇴하기
          Expanded(
            flex: 2,
            child: OutButtons(),
          ),
        ],
      ),
    );
  }
}