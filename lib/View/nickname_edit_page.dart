import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nagaja_app/View/my_page.dart';

import '../Controller/user_controller.dart';

class NicknameEdit extends StatefulWidget {
  const NicknameEdit({super.key});

  @override
  State<NicknameEdit> createState() => _NicknameEditState();
}

class _NicknameEditState extends State<NicknameEdit> {

  String? nicknameFromDB;

  GlobalKey<FormState> nicknameFormkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    //
    Get.put(UserController());
    nicknameFromDB = Get.find<UserController>().userData.value!.userNickname;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          appBar:  AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black, // 글자 색
            title: Text(
              '닉네임 변경',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),

          body: Form(
            key: nicknameFormkey,

            child:  Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: width * 0.8,
                  height: height * 0.85,

                  child: Column(
                    children: [

                      //Title: 닉네임
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text('새 닉네임',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize:14, fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      //닉네임 변경란
                      newNickname(),

                      //저장 하기
                      stored(),

                    ],
                  ),

                ),
              ),
            ),
          )
      ),
    );
  }


  //닉네임 변경란
  Widget newNickname() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

      child: TextFormField(
        maxLength: 12,

        autofocus: true,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value)
        => FocusScope.of(context).unfocus(),


        validator: (value) {
          if(value!.isEmpty) {
            return '새 닉네임을 입력해주세요.';
          }
          else {
            return null;
          }
        },

        onSaved: (value) {
          setState(() {
            nicknameFromDB = value;
          });
        },

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
            if (nicknameFormkey.currentState?.validate() == true) {
              nicknameFormkey.currentState!.save();

              //UserController userController = Get.find();
              //userController.updateNickname(nicknameFromDB!);
              Get.find<UserController>().updateNickname(nicknameFromDB!);

              print('new nickname: $nicknameFromDB');

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