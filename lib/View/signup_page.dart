import 'package:flutter/material.dart';
import 'package:nagaja_app/Controller/auth_controller.dart';
import 'package:nagaja_app/Model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nagaja_app/View/signup_completed_page.dart';

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
    // 추가 시작
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    // 추가 끝

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // 글자 색
          title: Text(
            '회원가입',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),

                width: width * 0.9,
                height: height * 0.85,

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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Container(
                        width: 300,
                        height: 50,
                        child: OutlinedButton(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpCompletePage(userModel.email, userModel.nickname),
                                ),
                              );
                            } else {
                              print('회원가입 실패');
                            }
                          }
                              : null,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15, fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
