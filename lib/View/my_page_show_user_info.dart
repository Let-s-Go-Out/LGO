import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nagaja_app/View/nickname_edit_page.dart';
import 'package:nagaja_app/View/password_edit_page.dart';
import '../Controller/user_controller.dart';

class ShowUserInfo extends StatefulWidget {
  const ShowUserInfo({super.key});

  @override
  State<ShowUserInfo> createState() => _ShowUserInfoState();
}

class _ShowUserInfoState extends State<ShowUserInfo> {

  @override
  Widget build(BuildContext context) {


    Get.put(UserController());
    Get.find<UserController>().fetchUserData();

    //hide password
    String hidePassword() {
      var hiddenPassword = Get.find<UserController>().userData.value?.userPassword;
      if (hiddenPassword == null || hiddenPassword.isEmpty) {
        return '비밀번호 변경하기';
      }

      return '*' * hiddenPassword.length;
    }


    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          final double availableHeight = constraints.maxHeight;
          //확인


          return Obx(() =>
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  width: availableWidth,
                  height: availableHeight,

                  //수정
                  child: Flexible(
                    flex: 5,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        //title: 내 정보 관리
                        Padding(padding: EdgeInsets.only(left: 20,),
                          child: Text(
                            '내 정보 관리',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Column(
                            children: [

                              //이메일
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return impossibleChange();
                                      }
                                  );
                                },
                                child: ListTile(
                                  title: Text(
                                    'E-mail',
                                    style: TextStyle(fontSize:15, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: Text(
                                      '${Get.find<UserController>().userData.value?.userEmail}', // DB 사용
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.close,
                                    //Icons.arrow_forward_ios,
                                    size: 18,
                                  ),
                                ),
                              ),
                              Divider(
                                indent: 20,
                                endIndent: 10,
                                thickness: 1,
                                color: Colors.black45,
                              ),


                              //닉네임
                              GestureDetector(
                                onTap: () {
                                  //Get.toNamed('nicknameEdit');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => NicknameEdit()),
                                  );
                                },
                                //behavior: HitTestBehavior.translucent, //opaque
                                child: ListTile(
                                  title: Text(
                                    '닉네임',
                                    style: TextStyle(fontSize:15, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: Text(
                                      '${Get.find<UserController>().userData.value?.userNickname}', //DB 사용
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                  ),
                                ),
                              ),
                              Divider(
                                indent: 24,
                                endIndent: 10,
                                thickness: 1,
                                color: Colors.black45,
                              ),


                              //비밀 번호
                              GestureDetector(
                                onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PasswordEdit()),
                                    );
                                },
                                child: ListTile(
                                  title: Text(
                                    '비밀번호',
                                    style: TextStyle(fontSize:15, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: Text(
                                      hidePassword(), //확인
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                  ),
                                ),
                              ),
                              Divider(
                                indent: 20,
                                endIndent: 10,
                                thickness: 1,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          );

        }
    );
  }


  //email 변경 불가 안내 팝업창
  Widget impossibleChange() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          width: MediaQuery.of(context).size.width * 0.5,

          child: Column(
            children: [

              Container(
                padding: EdgeInsets.symmetric(vertical: 15),

                child: IconButton(
                  icon: Icon(Icons.close),
                  iconSize: 20,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),

              Container(
                padding: EdgeInsets.all(0),

                child: Text(
                  '이메일 변경은 불가능합니다. \n탈퇴 후 재가입 해주세요.',
                  style: TextStyle(
                    height: 1.5, //줄간격
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
      ),
    );
  }
}