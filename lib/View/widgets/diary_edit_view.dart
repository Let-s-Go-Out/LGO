import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nagaja_app/View/widgets/diary_view.dart';
import '../diary_page.dart';
import 'package:nagaja_app/View/widgets/theme.dart';
import 'package:nagaja_app/View/widgets/input_field.dart';
import 'package:nagaja_app/View/widgets/input_field_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nagaja_app/View/widgets/action_buttons.dart';

class DiaryEditView extends StatefulWidget {
  final int monthIndex;
  final User user; // User 객체를 인자로 받아옴

  const DiaryEditView({
    Key? key,
    required this.monthIndex,
    required this.user, // User 객체를 전달받음
  }) : super(key: key);

  @override
  State<DiaryEditView> createState() => _DiaryEditViewState();
}

class _DiaryEditViewState extends State<DiaryEditView> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime="9:30 PM";
  File? image;
  PlatformFile? pickedFile; // 첫 번째 사진을 나타내는 변수
  PlatformFile? pickedSecondFile; // 두 번째 사진을 나타내는 변수
  UploadTask? uploadTask;

  // 첫 번째 사진 선택
  Future pickImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      // 선택된 파일리스트 중 첫번째 파일의 정보
      pickedFile = result.files.first;
    });
  }

  // 두 번째 사진 사진 선택
  Future _uploadSecondImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedSecondFile = result.files.first;
    });
  }

  // 선택한 함수 Firebase Storage에 업로드
  Future uploadFile() async {
    // 업로드할 파일의 경로 지정 (files 폴더 안에 선택한 파일의 이름으로 저장)
    final path = 'files/${pickedFile!.name}';
    // 선택한 이미지 파일의 내용
    final file = File(pickedFile!.path!);

    // Firebase Storage에서 사용할 업로드 경로를 나타내는 참조 객체
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      // 파일을 업로드하는 작업을 uploadTask 변수에 할당 (이 작업은 ref.putFile(file)을 통해 생성됨)
      uploadTask = ref.putFile(file);
    });

    // uploadTask 작업이 완료될 때까지 기다린 후, 해당 작업의 상태 정보를 저장하는 스냅샷(snapshot)을 얻음
    final snapshot = await uploadTask!.whenComplete(() {});

    // 업로드된 파일의 다운로드 URL을 얻습니다. 이 URL을 통해 나중에 이미지를 표시하거나 다운로드할 수 있습니다.
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    // 업로드 작업이 완료되면 uploadTask 변수를 초기화하여 업로드가 끝났음을 나타냅니다.
    setState(() {
      uploadTask = null;
    });
  }

  // 첫 번째 이미지 삭제 함수 (Firebase에는 그대로 남아있음)
  void _removeSelectedImage() {
    setState(() {
      pickedFile = null;
    });
  }

  // 두 번째 이미지 삭제 함수
  void _removeSecondImage() {
    setState(() {
      pickedSecondFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 8.0),
          ],
        ),
        child: Column(
          children: [
            // New
            MyInputFieldMessage(
              title: "한 줄 일기",
              hint: "한 줄 일기를 작성해주세요.\n오늘의 나들이는 어땠나요?",
              controller: _noteController,),
            MyInputField(title: "날짜", hint: DateFormat.yMEd().format(_selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined,
                    color: Colors.grey
                ),
                onPressed: () {
                  _getDataFromUser();
                },
              ),
            ),
            // 추가
            /*DiaryView(
                monthIndex: widget.monthIndex,
                selectedDate: _selectedDate),*/
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 첫 번째 사진
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  child: GestureDetector(
                    onTap: _removeSelectedImage, // 이미지 누르면 삭제하는 함수 호출
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: pickedFile != null
                          ? Image.file(
                        File(pickedFile!.path!),
                        width: 95,
                        height: 95,
                        fit: BoxFit.cover,
                      )
                          : InkWell(
                        onTap: pickImage, // 이미지를 누르면 _uploadSecondImage() 함수 호출
                        child: Center(
                          child: Text('사진', style: TextStyle(fontSize: 10)),
                        ),
                      ),
                    ),
                  ),
                ),
                // 두번째 사진
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  child: GestureDetector(
                    onTap: pickedSecondFile != null ? _removeSecondImage : _uploadSecondImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: pickedSecondFile != null
                          ? Image.file(
                        File(pickedSecondFile!.path!),
                        width: 95,
                        height: 95,
                        fit: BoxFit.cover,
                      )
                          : Center(
                        child: Text('사진', style: TextStyle(fontSize: 10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 갤러리에서 사진 선택
                ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.image_outlined),
                    ],
                  ),
                  onPressed: ()=>pickImage(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),

                // 사진 업로드 -> 다이어리 업로드 버튼에 병합
                /*ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.check),
                    ],
                  ),
                  onPressed: ()=>uploadFile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 216, 216, 216),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),*/
                //buildProgress(),

                // 다이어리 업로드
                ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.check)
                    ],
                  ),
                  onPressed: () async {
                    uploadFile(); // 사진 업로드
                    bool isValid = await _validDate();
                    if (isValid) {
                      await createPicnicDiary(
                          shortDiary: _noteController.text); // 다이어리 업로드
                      Get.snackbar(
                        "Success",
                        "다이어리 저장 완료!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black,
                        colorText: Colors.white,
                        icon: Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                      );

                      // 새로고침
                      //_savedDiary.add(_noteController.text);
                      //_noteController.clear();
                      setState(() {}); // 화면 새로고침?

                      //Navigator.pop(context);
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
            /*Row(
              children: [
                if (pickedFile != null)
                  Expanded(
                    child: Container(
                      color: Colors.blue[100],
                      child: Center(
                        child: Image.file(
                          File(pickedFile!.path!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
              ],
            )*/
          ],
        ),
      ),
    );
  }

// 사용자 입력의 유효성을 검증 함수
  Future<bool> _validDate() async {
    if (_noteController.text.isNotEmpty) {
      try {
        await createPicnicDiary(shortDiary: _noteController.text);
        print('다이어리 업로드 성공!');
        // 데이터 제출 후 전 페이지로 돌아감
        Get.back();
        return true; // 유효성 검사 통과
      } catch (error) {
        print('Error uploading diary: $error');
        Get.snackbar(
          "Error",
          "다이어리를 업로드하는 도중 오류가 발생했습니다.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.pinkAccent,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ),
        );
        return false; // 유효성 검사 실패
      }
    }
    return true; // _noteController.text가 비어있을 경우에는 true 반환
  }



  // 데이터 제출 후, 전 페이지로 돌아감
  // Get.back();
  // }else if(_noteController.text.isEmpty){
  //   Get.snackbar("Error", "다이어리를 완성해주세요.",
  //     snackPosition: SnackPosition.BOTTOM,
  //     backgroundColor: Colors.white,
  //     colorText: Colors.pinkAccent,
  //     icon: Icon(Icons.warning_amber_rounded,
  //         color: Colors.red),
  //   );
  //   }
  // }

  // 데이터를 Firebase에 업로드
  Future createPicnicDiary({required String shortDiary}) async {
    try {
      // id 생성
      final docPicnicDiary = FirebaseFirestore.instance.collection('PicnicRecord')
          .doc(widget.user.uid)
          .collection('Diary')
          .doc();

      final picnicDiary = PicnicDiary(
        //id : docPicnicDiary.id,
        //uid: user.uid,
        shortDiary: shortDiary,
        picnicDate: _selectedDate,
      );
      //final json = picnicDiary.toJson();

      // create document and write data to Firebase
      //  await docPicnicDiary.set(json);
      await docPicnicDiary.set(picnicDiary.toJson());
      // Create document and write data to Firebase

      print('다이어리 저장 성공!');
    } catch (e) {
      print('다이어리 저장 실패: $e');
    }
  }


  _getDataFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030)
    );

    if(_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }else{
      print("it's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime==null){
      print("Time canceled");
    }else if(isStartTime==true){
      setState(() {
        _startTime=_formatedTime;
      });
    }else if(isStartTime==false){
      setState(() {
        _endTime=_formatedTime;
      });
    }
  }

  _showTimePicker(){
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          // startTime -> 10:30 AM
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        )
    );
  }

/*Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.lightGreen,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(height: 50);
        }
      });*/
}

class PicnicDiary {
  //String id;
  //final String uid;
  final String shortDiary;
  final DateTime picnicDate;

  PicnicDiary({
    //this.id = '',
    //required this.uid,
    required this.shortDiary,
    required this.picnicDate,
  });

  Map<String, dynamic> toJson() => {
    //'id': id,
    //'uid': uid,
    'shortDiary': shortDiary,
    'picnicDate': picnicDate,
  };
}