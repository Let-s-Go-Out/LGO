import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutButtons extends StatelessWidget {
  const OutButtons({super.key});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth * 0.5;
        final double availableHeight = constraints.maxHeight * 0.3;
        //수정 >>

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,

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

            SizedBox(height: 5,),

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
        width: width * 0.5,
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            TextButton(
              child: const Text(
                '로그아웃', style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                //Auth.auth().signOut();
                Get.toNamed('/');
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

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        width: width * 0.5,
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
                '탈퇴 시, \n기존 정보가 모두 소멸됩니다. \n탈퇴 하시겠습니까?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

            TextButton(
              child: const Text(
                '탈퇴하기', style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                //UserController.deleteAccount();
                Get.toNamed('/');
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
