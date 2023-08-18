import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nagaja_app/View/my_page.dart';
import '../Controller/user_controller.dart';

class PasswordEdit extends StatefulWidget {
  const PasswordEdit({super.key});

  @override
  State<PasswordEdit> createState() => _PasswordEditState();
}

class _PasswordEditState extends State<PasswordEdit> {

  String? passwordFromDB;
  String? passwordChange;
  String? passwordConfirm;
  bool visible = true;

  GlobalKey<FormState> pwFormkey = GlobalKey<FormState>();

  //FocusNode currentFocus = FocusNode();
  FocusNode newFocus = FocusNode();
  FocusNode confirmFocus = FocusNode();

  @override
  void dispose() {
    newFocus.dispose();
    confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //
    Get.put(UserController());
    Get.find<UserController>().fetchUserData();
    passwordFromDB = Get.find<UserController>().userData.value!.userPassword;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // 글자 색
          title: Text(
            '비밀번호 변경',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),

        body: Form(
          key: pwFormkey,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),

                width: width * 0.9,
                height: height * 0.85,

                child: Column(
                  children: [

                    //title: 현재 비밀 번호
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text('현재 비밀번호',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize:14, fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    password(),

                    //title: 새 비밀 번호
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text('새 비밀번호',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize:14, fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    newPassword(),


                    //title: 새 비밀 번호 확인
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text('새 비밀번호 확인',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize:14, fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    newPasswordConfirm(),


                    //저장 하기 버튼
                    stored(),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //현재 비밀 번호
  Widget password() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

      child: TextFormField(

        autofocus: true,
        obscureText: true,

        //focusNode: currentFocus,

        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_)
        => FocusScope.of(context).requestFocus(newFocus),


        validator: (value) {
          if(value!.isEmpty) {
            return '현재 비밀번호를 입력해주세요.';
          }
          else if(passwordFromDB != value) {
            return '비밀번호가 틀립니다.';
          }
          else { return null; }
        },

      ),
    );
  }


  //새 비밀 번호
  Widget newPassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

      child: TextFormField(
        maxLength: 15,

        focusNode: newFocus,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value)
        => FocusScope.of(context).requestFocus(confirmFocus),

        onChanged: (value) {
          setState(() {
            passwordChange = value;
          });
        },

        validator: (value) {
          if(value!.isEmpty) {
            return '새 비밀번호를 입력해주세요.';
          }
          else {
            String pattern =
                r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
            RegExp regExp = RegExp(pattern);
            if (!regExp.hasMatch(value)) {
              return '특수 문자, 영문, 숫자 포함 8자~15자 이내로 입력해주세요.';
            }
            else if (regExp.hasMatch(value)) {
              //
              setState(() {
                passwordChange = value;
              });
              return null;
            }
          }
        },

        obscureText: visible,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              visible? Icons.visibility_off : Icons.visibility,
              color: Colors.black45,
              size: 16,
            ),
            onPressed: () {
              setState(() {
                visible = !visible;
              });
            },
          ),
        ),

      ),
    );
  }


  //새 비밀 번호 확인
  Widget newPasswordConfirm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextFormField(
        maxLength: 15,

        focusNode: confirmFocus,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value)
        => FocusScope.of(context).unfocus(),

        onChanged: (value) {
          setState(() {
            passwordConfirm = value;
          });
        },

        validator: (value) {
          if(value!.isEmpty) {
            return '새 비밀번호를 입력해주세요.';
          }
          else {
            if(passwordChange != passwordConfirm) {
              // 변경한 pw 값과 비교
              return "새로운 비밀번호와 다릅니다.";
            }
            else {
              //삭제
              setState(() {
                passwordConfirm = value;
              });
              return null;
            }
          }
        },

        //
        onSaved: (value) {
          setState(() {
            passwordConfirm = value;
          });
        },

        obscureText: visible,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                visible? Icons.visibility_off : Icons.visibility,
                color: Colors.black45,
                size: 16,
              ),
              onPressed: () {
                setState(() {
                  visible = !visible;
                });
              },
            )
        ),

      ),
    );
  }


  //저장 하기
  Widget stored() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50),

      child: Container(

        width: 300,
        height: 50,

        child: OutlinedButton(
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
            '저장하기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15, fontWeight: FontWeight.bold,
            ),
          ),

          onPressed: () {
            //
            if (pwFormkey.currentState?.validate() == true) {
              pwFormkey.currentState!.save();

              //UserController userController = Get.find();
              //userController.updatePassword(passwordFromDB!);
              Get.find<UserController>().updatePassword(passwordConfirm!);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            }
          },
        ),
      ),
    );
  }

}
