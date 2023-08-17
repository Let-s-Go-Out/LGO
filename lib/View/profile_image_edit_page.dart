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

  XFile? file;

  Widget defaultImage(double height, double width) {
    return Container(
      constraints: BoxConstraints(
        minHeight: height * 0.8,
        minWidth: width * 0.8,
      ),

      child: GestureDetector(
        onTap: () { showBottomSheet(); },
        child: Center(
          child: Icon(
            Icons.account_circle,
            size: height * 0.8,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }

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
                  if (file == null)
                    defaultImage(availableHeight, availableWidth)

                  else
                    GestureDetector(
                      onTap: () { showBottomSheet(); },

                      child: Center(
                        child: Container(
                          width: availableWidth * 0.8,
                          height: availableHeight * 0.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(file!.path)),
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


  showBottomSheet() {
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

                //갤러리
                TextButton(
                  child: Text(
                    '갤러리',
                    style: TextStyle(fontSize: 15,),
                  ),
                  onPressed: () {
                    getImage(ImageSource.gallery);
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


                //카메라
                TextButton(
                  child: Text(
                    '카메라',
                    style: TextStyle(fontSize: 15,),
                  ),
                  onPressed: () {
                    getImage(ImageSource.camera);
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
                    Get.back();
                    setState(() {
                      file == null;
                    });
                  },
                ),
              ],
            ),
          );
        }
    );
  }


  Future getImage(ImageSource source) async {
    XFile? tempFile = await ImagePicker().pickImage(source:source);
    if (tempFile != null) {
      setState(() {
        file = tempFile;
      });
      //Get.back();
    }
  }

}
