import 'package:flutter/material.dart';
import 'package:nagaja_app/View/home.dart';
import 'package:nagaja_app/View/login_page.dart';
import 'package:nagaja_app/View/signup_page.dart';
import 'package:nagaja_app/Controller/auth_controller.dart';

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
                height: height,
                child: Image.asset(
                    'assets/images/background_1.png', height: height),
              ),
              Container(
                height: height,
                child: Image.asset(
                    'assets/images/lets_go_out.png', height: height),
              ),
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // 버튼 배경색을 검정색으로 설정
                  onPrimary: Colors.white, // 텍스트 색상을 흰색으로 설정
                ),
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // 버튼 배경색을 검정색으로 설정
                  onPrimary: Colors.white, // 텍스트 색상을 흰색으로 설정
                ),
                child: Text('회원가입'),
              ),
            ],
          ),
        ),
      ),*/


