import 'package:flutter/material.dart';
import 'package:nagaja_app/View/login_page.dart';

class SignUpCompletePage extends StatelessWidget {
  final String email;
  final String nickname;

  SignUpCompletePage(this.email, this.nickname);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 완료'),
        backgroundColor: Colors.black, // AppBar 배경색을 검정색으로 설정
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '회원가입이 완료되었습니다!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('이메일: $email'),
            SizedBox(height: 10),
            Text('닉네임: $nickname'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 시작 페이지로 이동
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // 버튼 배경색을 검정색으로 설정
                    onPrimary: Colors.white, // 텍스트 색상을 흰색으로 설정
                  ),
                  child: Text('시작 페이지'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // 로그인 페이지로 이동
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
