import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImgEdit extends StatefulWidget {
  const ProfileImgEdit({super.key});

  @override
  State<ProfileImgEdit> createState() => _ProfileImgEditState();
}

class _ProfileImgEditState extends State<ProfileImgEdit> {

  //수정 >> 기본 이미지로 돌아가기, 앱 종료 후에도 유지
  XFile? pickedFile;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          final double availableHeight = constraints.maxHeight;
          //수정 >>

          return Padding(
            padding: EdgeInsets.only(top: 15,),
            child: Center(
              child: Column(
                children: [
                  if(pickedFile == null)
                    Container(
                      constraints: BoxConstraints(
                        minHeight: availableHeight * 0.8,
                        minWidth: availableWidth * 0.8,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showBottomSheet();
                        },

                        child: Center(
                          child: Icon(
                            Icons.account_circle,
                            size: availableHeight * 0.8,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    )

                  else
                    GestureDetector(
                      onTap: () {
                        showBottomSheet();
                      },

                      child: Center(
                        child: Container(
                          width: availableWidth * 0.8,
                          height: availableHeight * 0.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(pickedFile!.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),

            ),
          );
        }
    );
  }


  void showBottomSheet() {
    showModalBottomSheet(
        context: context,

        constraints: BoxConstraints( maxHeight: 220 ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)
          ),
        ),

        builder: (context) {
          return Center(
            child: Column(
              children: [
                SizedBox(height: 30,),

                //버튼 터치 범위 수정 >>
                //갤러리
                TextButton(
                  child: Text(
                    '갤러리',
                    style: TextStyle(fontSize: 15,),
                  ),
                  onPressed: () {
                    getGallery();
                    Get.back();
                    //Navigator.pop(context);
                  },
                ),


                SizedBox(height: 10,),
                Divider(
                  indent: 40,
                  endIndent: 40,
                  thickness: 1,
                  color: Colors.black45,
                ),
                SizedBox(height: 10,),


                //카메라
                TextButton(
                  child: Text(
                    '카메라',
                    style: TextStyle(fontSize: 15,),
                  ),
                  onPressed: () {
                    getCamera();
                    Get.back();
                  },
                ),


                SizedBox(height: 10,),
                Divider(
                  indent: 40,
                  endIndent: 40,
                  thickness: 1,
                  color: Colors.black45,
                ),
                SizedBox(height: 10,),


                //기본 이미지
                TextButton(
                  child: Text(
                    '기본 이미지',
                    style: TextStyle(fontSize: 15, color: Colors.red,),
                  ),
                  onPressed: () {
                    //Navigator.pop(context);
                    Get.back();
                    setState(() {
                      pickedFile == null;
                    });
                  },
                ),
                //SizedBox(height: 20,),
              ],
            ),
          );
        }
    );
  }



  Future getGallery() async {
    pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        pickedFile = pickedFile;
      });
    }
    else { print('pickedFile == null'); }
  }


  Future getCamera() async {
    pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        pickedFile = pickedFile;
      });
    }
    else { print('pickedFile == null'); }
  }

}

