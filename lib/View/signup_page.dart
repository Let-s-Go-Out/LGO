import 'package:flutter/material.dart';
import 'package:nagaja_app/Controller/auth_controller.dart';
import 'package:nagaja_app/Model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  final String? initialEmail;

  SignUpPage({this.initialEmail});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isPasswordConditionsMet = false;
  bool _isNicknameValid = false;

  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
              onChanged: (value) {
                setState(() {
                  _isEmailValid = value.isNotEmpty;
                });
              },
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _isPasswordValid = value.isNotEmpty;
                  _isPasswordConditionsMet = value.length >= 8 && value.contains(RegExp(r'\d'));
                });
              },
            ),
            if (_isEmailValid && _isPasswordValid && !_isPasswordConditionsMet)
              Text(
                '비밀번호는 8자 이상이어야 하며, 숫자를 포함해야 합니다.',
                style: TextStyle(color: Colors.red),
              ),
            if (_isEmailValid && _isPasswordValid && _isPasswordConditionsMet)
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: '닉네임'),
                onChanged: (value) {
                  setState(() {
                    _isNicknameValid = value.isNotEmpty;
                  });
                },
              ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isEmailValid &&
                  _isPasswordValid &&
                  _isPasswordConditionsMet &&
                  _isNicknameValid
                  ? () async {
                final String email = _emailController.text;
                final String password = _passwordController.text;
                final String nickname = _nicknameController.text;

                // 회원가입 처리
                User? user = await _authController.signUpWithEmailAndPassword(email, password, nickname);
                if (user != null) {
                  UserModel userModel = UserModel.fromUser(user,nickname);
                  print('회원가입 성공: ${userModel.email}');
                } else {
                  print('회원가입 실패');
                }

              }
                  : null,
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}




