import 'dart:io';
import 'package:flutter/material.dart';
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

  Future pickImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    setState(() {
      uploadTask = null;
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
            MyInputFieldMessage(title: "한 줄 일기", hint: "한 줄 일기를 작성해주세요.\n오늘의 나들이는 어땠나요?", controller: _noteController,),
            MyInputField(title: "날짜", hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined,
                    color: Colors.grey
                ),
                onPressed: () {
                  _getDataFromUser();
                },
              ),),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    child: Text('Upload from gallery', style: TextStyle(fontSize: 8)),
                  ),
                ),
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
                    backgroundColor: Color.fromARGB(255, 216, 216, 216),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                // 사진 업로드
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
                  onPressed: ()=>_validateDate(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 216, 216, 216),
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
        print(_selectedDate);
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