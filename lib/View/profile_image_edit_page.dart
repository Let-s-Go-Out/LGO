import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImgEdit extends StatefulWidget {
  const ProfileImgEdit({Key? key}) : super(key: key);

  @override
  State<ProfileImgEdit> createState() => _ProfileImgEditState();
}

class _ProfileImgEditState extends State<ProfileImgEdit> {

  File? profileImg;
  String? uid;
  String? imgUrl;

  Future<String?> getUid() async {
    var auth = await FirebaseAuth.instance;
    uid = auth.currentUser!.uid;
  }

  Widget defaultImage(double height, double width) {
    return Container(
      constraints: BoxConstraints(
        minHeight: height * 0.8,
        minWidth: width * 0.8,
      ),

      child: GestureDetector(
        onTap: () {
          showBottomSheet();
        },
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
  void initState() {
    super.initState();
    getUid();
    loadProfileImg();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth * 0.33;
          final double availableHeight = constraints.maxHeight;

          return Padding(
            padding: EdgeInsets.only(top: 15,),
            child: Center(
              child: Column(
                children: [
                  if (profileImg == null)
                    defaultImage(availableHeight, availableWidth)

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
                            //shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(File(profileImg!.path)),
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

        constraints: BoxConstraints(maxHeight: 220),
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
                    removeProfileImg();
                    Get.back();
                  },
                ),
              ],
            ),
          );
        }
    );
  }


  Future getImage(ImageSource source) async {
    XFile? tempImgFile = await ImagePicker().pickImage(source: source);
    if (tempImgFile == null) {
      return;
    }
    //image cropper
    /*
    else {
      ImageCropper().cropImage(
        sourcePath: tempImgFile!.path,
        cropStyle: CropStyle.circle,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        //
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '사진 선택',
            //?
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          )
        ],
      ).then((croppedImg) {
        if(croppedImg != null) {
          setState(() {
            profileImg = File(croppedImg!.path);
            uploadFile(profileImg!);
          });
        }
      });

     */

    setState(() {
      profileImg = File(tempImgFile.path);
      uploadFile(tempImgFile);
    });
  }


  Future uploadFile(XFile img) async {
    final path = '/user_profile_image/$uid';
    final file = File(img.path);

    Reference storageRef = FirebaseStorage.instance.ref().child(path);
    await storageRef.putFile(file);

    //
    imgUrl = await storageRef.getDownloadURL();
  }

  //추가
  Future<File?> loadProfileImg() async {
    final path = '/user_profile_image/$uid';
    Reference storageRef = FirebaseStorage.instance.ref().child(path);

    try {
      imgUrl = await storageRef.getDownloadURL();
      setState(() {
        profileImg = File(imgUrl!);
      });
    } catch (e) {
      setState(() {
        profileImg = null;
      });
    }
  }


  Future removeProfileImg() async {
    setState(() {
      profileImg = null;
    });

    final path = 'user_profile_image/$uid';

    Reference storageRef = FirebaseStorage.instance.ref().child(path);

    try {
      await storageRef.delete();
    }
    catch (e) {
      print('Error while deleting profile image: $e');
    }
  }


}
