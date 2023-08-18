import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nagaja_app/View/login_page.dart';

import '../Controller/user_controller.dart';

class OutButtons extends StatelessWidget {
  const OutButtons({super.key});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth * 0.5;
        final double availableHeight = constraints.maxHeight * 0.3;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            //로그 아웃
            SizedBox(
              width: availableWidth,
              height: availableHeight,

              child: TextButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return LogOutButton();
                      });
                },

                child: const Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
              ),
            ),

            //SizedBox(height: 5,),

            //탈퇴 하기
            SizedBox(
              width: availableWidth,
              height: availableHeight,

              child: TextButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext conte) {
                        return DeleteButton();
                      });
                },

                child: const Text(
                  '탈퇴하기',
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
              ),
            ),
          ],

        );
      },
    );
  }
}


//로그 아웃 팝업창
class LogOutButton extends StatefulWidget {
  const LogOutButton({super.key});

  @override
  State<LogOutButton> createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        width: width * 0.65,
        height: height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                '로그아웃 하시겠습니까?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            TextButton(
              child: const Text(
                '로그아웃', style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                //
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),

            const Divider(
              indent: 40,
              endIndent: 40,
              thickness: 1,
              color: Colors.black45,
            ),

            TextButton(
              child: const Text(
                  '취소', style: TextStyle(color: Colors.blueAccent)
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}


//탈퇴 하기 팝업창
class DeleteButton extends StatefulWidget {
  const DeleteButton({super.key});

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {

    Get.put(UserController());

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        width: width * 0.6,
        height: height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                '탈퇴 시, \n기존 정보가 모두 소멸됩니다. \n탈퇴 하시겠습니까?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            TextButton(
              child: const Text(
                '탈퇴하기', style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                //UserController userController = Get.find();
                //userController.deleteAccount();
                Get.find<UserController>().deleteAccount();
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),

            const Divider(
              indent: 40,
              endIndent: 40,
              thickness: 1,
              color: Colors.black45,
            ),

            TextButton(
              child: const Text(
                  '취소', style: TextStyle(color: Colors.blueAccent)
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
