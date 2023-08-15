import 'package:flutter/material.dart';

import 'my_page_out_buttons.dart';
import 'my_page_show_user_info.dart';
import 'profile_image_edit_page.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // 글자 색
        title: Text(
          'my page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: width * 0.8,
              height: height * 0.9,

              child: const Column(
                children: [

                  //프로필 이미지
                  Flexible(
                    flex: 4,
                    child: ProfileImgEdit(),
                  ),


                  //Title: 내 정보 관리
                  //사용자 정보
                  Flexible(
                    flex: 5,
                    child:  Padding(
                      padding: EdgeInsets.all(0),
                      child: ShowUserInfo(),
                    ),
                  ),


                  //로그 아웃, 탈퇴 하기 버튼
                  Flexible(
                    flex: 2,
                    child:  Padding(
                      padding: EdgeInsets.all(0),
                      child: OutButtons(),
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

