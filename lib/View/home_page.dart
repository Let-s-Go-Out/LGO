import 'package:flutter/material.dart';
import 'package:nagaja_app/View/home.dart';
import 'login_page.dart';
import 'signup_page.dart';
import '../Controller/auth_controller.dart';

class HomePage extends StatelessWidget {
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 버튼 동작을 막음
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                // 글자 포함한 배경 이미지
                height: height,
                color: Colors.white,
                child: Image.asset(
                    'assets/images/login_background.jpg', height: height),
              ),
              // 마커-1 이미지
              /*Positioned(
                // 마커-1 위치
                left: 30,
                bottom: 260,
                child: Image.asset(
                  'assets/images/map_marker.png',
                  width: 50,
                  height: 100,
                ),
              ),
              // 마커-2 이미지
              Positioned(
                // 마커 이미지
                // 마커-2 위치
                left: 100,
                bottom: 280,
                child: Image.asset(
                  'assets/images/map_marker.png',
                  width: 50,
                  height: 100,
                ),
              ),
              // 마커-3 이미지
              Positioned(
                // 마커 이미지
                // 마커-3 위치
                left: 200,
                bottom: 310,
                child: Image.asset(
                  'assets/images/map_marker.png',
                  width: 50,
                  height: 100,
                ),
              ),*/
              // 로그인
              Positioned(
                left: 50,
                right: 50,
                bottom: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black87,
                      padding: EdgeInsets.symmetric(vertical: 17,),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text('로그인'),
                  ),),
              // 회원가입
              Positioned(
                left: 50,
                right: 50,
                bottom: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black87,
                      padding: EdgeInsets.symmetric(vertical: 17,),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: Text('회원가입'),
                  ),)
            ],
          )
      ),
    );
  }
}

 /*       Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Let's Go Out!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8), // 조절 가능한 공간
            Text(
              "나가자!",
              style: TextStyle(
                fontSize: 16, // 작은 글씨 크기 조절
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text('로그인'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ),
                );
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),*/

