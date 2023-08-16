import 'dart:async';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:nagaja_app/View/home.dart';
import 'package:nagaja_app/View/map_browse_screen.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:nagaja_app/View/main_page_loading.dart';
import 'package:nagaja_app/Controller/user_route_data.dart';
import 'package:nagaja_app/View/widgets/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'diary_page.dart';
import 'my_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedConcept = '';
  String selectedStartTime = '';

  String text = '검색어를 입력하세요.';
  String startPlaceAddress='';
  String startPlaceName='';
  LatLng startPlaceLatLng=LatLng(0, 0);

  // create TimeOfDay variable
  TimeOfDay _timeOfDay = TimeOfDay.now();
  //TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);

  int _selectedIndex = 0;

  final List<Widget> _navIndex = [
    MainPage(),
    DiaryPage(),
    MyPage(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MainPage(),
            transitionDuration: Duration(seconds: 0), // 애니메이션 시간을 0으로 설정
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DiaryPage(),
            transitionDuration: Duration(seconds: 0), // 애니메이션 시간을 0으로 설정
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MyPage(),
            transitionDuration: Duration(seconds: 0), // 애니메이션 시간을 0으로 설정
          ),
        );
        break;
    // 다른 인덱스에 대한 처리를 추가할 수 있습니다.
    }
  }

  // show time picker method
  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // This uses the _timePickerTheme defined above
            timePickerTheme: _timePickerTheme,
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.black, width: 2)
                  )
                )
              ),
            ),
          ),
          child: child!,
        );
      }
    ).then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }

  final _timePickerTheme = TimePickerThemeData(
    backgroundColor: Colors.white,
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    //dayPeriodBorderSide: const BorderSide(color: Colors.orange, width: 4),
    dayPeriodColor: Colors.white, // AM | PM
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    dayPeriodTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? Colors.black : Color.fromARGB(255, 198, 198, 198)),
    dayPeriodShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      side: BorderSide(color: Colors.black, width: 8),
    ),
    hourMinuteColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected) ? Colors.black : Color.fromARGB(255, 216, 216, 216),),
    hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? Colors.white : Colors.black),
    dialHandColor: Colors.white,
    dialBackgroundColor: Color.fromARGB(255, 216, 216, 216),
    hourMinuteTextStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    dayPeriodTextStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    helpTextStyle:
    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    dialTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? Colors.black : Colors.black),
    entryModeIconColor: Colors.black,
  );

  double _value = 4.0;



  // Firestore에 사용자에게 입력받은 경로 데이터를 저장하는 함수
  void saveUserRouteData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      print('로그인이 필요합니다.');
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // 사용자 경로 데이터
    Map<String, dynamic> userRouteData = {
      'picnicConcept': selectedConcept,
      'DepartureTime': _timeOfDay.format(context),
      'placeCount': _value.toStringAsFixed(0),
      'startPlaceAddress': startPlaceAddress,
      'startPlaceName': startPlaceName,
      'startPlaceGeopoint': GeoPoint(startPlaceLatLng.latitude, startPlaceLatLng.longitude),
    };

    try {
      await firestore.collection('PicnicRecord').doc(user.uid).set(userRouteData);
      print('사용자 경로 정보 저장 성공');
    } catch (e) {
      print('사용자 경로 정보 저장 실패: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // 뒤로가기 버튼 동작을 막음
      return false;
    },
    child: MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
    home: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mypage',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
        appBar: null,
        body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final double availableHeight = constraints.maxHeight;
      final double verticalSpacing = availableHeight * 0.02; // 2% of available height

      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: verticalSpacing*1.5),
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalSpacing),
              child: Text(
                '나가자!(Let\'s Go Out!)',
                textAlign: TextAlign.center,
                style: mainPageTitleStyle,
              ),
            ),
            SizedBox(height: verticalSpacing*0.05),
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalSpacing*0.05),
              child: Text(
                '아래 양식에 나들이 정보를 입력해주시길 바랍니다.',
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(flex: 2),
            Text('출발지',
            style: mainPageSubTitleStyle),
            Spacer(flex: 1),
            InkWell(
              onTap: () async {
                final returnData = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapBrowseScreen()),
                );
                if(returnData != null){
                  startPlaceAddress = returnData.address;
                  startPlaceName = returnData.name;
                  startPlaceLatLng = LatLng(returnData.geoLat,returnData.geoLng);
                  setState(() {
                    text = startPlaceAddress;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(fontSize:16.0),
                  ),
                ),
              ),
            ),
            Spacer(flex: 2),
            // 나들이 컨셉
            Text('나들이 컨셉',
              style: mainPageSubTitleStyle),
            Spacer(flex: 1),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              children: [
                conceptButton('음식점'),
                conceptButton('카페'),
                conceptButton('쇼핑'),
                conceptButton('문화'),
                conceptButton('바'),
                conceptButton('어트랙션'),
              ],
            ),
            Spacer(flex: 2),
            // 희망 출발 시간
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text('희망 출발 시간',
                      style: mainPageSubTitleStyle),
                  ),
                  Flexible(
                    flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // button
                          ElevatedButton(
                            onPressed: _showTimePicker,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                  '${_timeOfDay.format(context)}',
                                  style: TextStyle(fontSize: 13)),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                    width: 2,
                                  )
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ]
            ),
            Spacer(flex: 2),
            // 희망 장소 개수 Slide Bar ver.
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('희망 장소 개수',
                    style: mainPageSubTitleStyle),
                  Text('${_value.toStringAsFixed(0)}개',
                    style: mainPageSubTitleStyle),
                ],
              ),
            ),
            Spacer(flex: 1),
            // Slide Bar
            Center(
              // 슬라이더 ver.1
              child: SfSlider(
                activeColor: Colors.black,
                inactiveColor: Colors.grey[200],
                min: 0.0,
                max: 5.0,
                value: _value,
                interval: 1,
                showTicks: true,
                showLabels: true,
                minorTicksPerInterval: 0,
                onChanged: (dynamic value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
              // 슬라이더 ver.2
              /*child: Slider(
                value: _value,
                onChanged: (dynamic value) {
                  setState(() {
                    _value = value;
                  });
                },
                activeColor: Colors.black,
                inactiveColor: Colors.grey,
                min: 0.0,
                max: 5.0,
                divisions: 5,
                label: _value.toString(),
              ),*/
            ),
            // 버튼
            Spacer(flex: 2),
            ElevatedButton(
              onPressed: () {
                saveUserRouteData(); // saveUserRouteData 함수 호출
                // Add code to handle the "Let's Go out" button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLoadingPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Let\'s Go out',
              style: TextStyle(color:Colors.white),),
            ),
            Spacer(flex: 1), // Add a spacer to push the bottom navigation bar to the bottom
          ],
        ),
      );
        },
        ),
    ),
    ),
    );
  }


  Widget conceptButton(String concept) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedConcept = concept;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(
              width: 2,
              // 버튼 선택 유무에 따른 버튼 스타일 변경
              color: selectedConcept == concept ? Colors.black : Colors.white10,
            )
        ),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          //color: Colors.black,
        ),
        padding: EdgeInsets.all(10),
        backgroundColor: Colors.white,
      ),
      child: Text(concept),
    );
  }

}




