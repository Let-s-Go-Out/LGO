import 'dart:io';
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

class DiaryEditView extends StatefulWidget {
  final int monthIndex;
  const DiaryEditView({
    Key? key,
    required this.monthIndex,
  }) : super(key: key);

  @override
  State<DiaryEditView> createState() => _DiaryEditViewState();
}

class _DiaryEditViewState extends State<DiaryEditView> {
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime="9:30 PM";
  File? image;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  // 갤러리에서 사진 선택
  Future pickImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      // 선택된 파일리스트 중 첫번째 파일의 정보
      pickedFile = result.files.first;
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

  // 이미지 삭제 함수 (Firebase에는 그대로 남아있음)
  void _removeSelectedImage() {
    setState(() {
      pickedFile = null;
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
                // 첫번째 사진

                // 사진 선택
                if (pickedFile != null)
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
                    child: Image.file(
                      File(pickedFile!.path!),
                      width: 94,
                      height: 94,
                      fit: BoxFit.cover,
                    )
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
                  child: Center(
                    child: Text('Upload from gallery', style: TextStyle(fontSize: 8),),
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
                // 사진 업로드
                ElevatedButton(
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
                ),
                //buildProgress(),
                // 다이어리 업로드
                ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.check)
                    ],
                  ),
                  onPressed: () {
                    uploadFile();
                    _validateDate();
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

  _validateDate(){
    if(_noteController.text.isNotEmpty){
      //add to database
      Get.back();
    }else if(_noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.pinkAccent,
        icon: Icon(Icons.warning_amber_rounded,
            color: Colors.red),
      );
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