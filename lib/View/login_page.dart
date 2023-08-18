import 'package:flutter/material.dart';
import '../Controller/auth_controller.dart';
import '../View/signup_page.dart';
import '../View/signup_completed_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../View/main_beginning_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  final AuthController _authController = AuthController(); // AuthController 인스턴스 생성
  
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
          '로그인',
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
                        onPressed: _isEmailValid && _isPasswordValid
                            ? () async {
                          final String email = _emailController.text;
                          final String password = _passwordController.text;

                          // 로그인 처리
                          User? user = await _authController.signInWithEmailAndPassword(email, password);
                          if (user != null) {
                            // 로그인 성공 시 처리 로직
                            print('로그인 성공: ${user.email}');

                            // 로그인 완료 후 페이지 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainBeginningPage(),
                              ),
                            );
                          } else {
                            // 로그인 실패 시 처리 로직
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('로그인 실패'),
                                content: Text('등록되지 않은 이메일이거나 비밀번호가 올바르지 않습니다.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('확인'),
                                  ),
                                ],
                              ),
                            );
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
                          '로그인',
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
      ),
    );
  }
}
