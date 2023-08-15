import 'package:flutter/material.dart';

class SignUpCompletePage extends StatelessWidget {
  final String email;
  final String nickname;

  SignUpCompletePage(this.email, this.nickname);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 완료'),
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
            //Text('닉네임: ${nickname ?? 'Unknown'}'), // nickname 값이 null이거나 비어있는 경우 'Unknown' 표시
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 메인 페이지로 이동
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('메인페이지로 이동하기'),
            ),
          ],
        ),
      ),
    );
  }
}


