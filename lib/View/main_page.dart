import 'dart:async';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:nagaja_app/View/diary_page.dart';
import 'package:nagaja_app/View/map_browse_screen.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:nagaja_app/View/main_page_loading.dart';
import 'package:nagaja_app/Controller/user_route_data.dart'; // 사용자에게 입력받는 경로 정보 (출발지, 희망소요시간, 나들이 컨셉 등)

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedConcept = '';
  String selectedStartTime = '';
  String selectedDuration = '';
  String text = '검색어를 입력하세요.';

  // create TimeOfDay variable
  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);

  // show time picker method
  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }

  double _value = 4.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
    home: Scaffold(
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
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
            Spacer(flex: 1),
            InkWell(
              onTap: () async {
                final returnData = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapBrowseScreen()),
                );
                if(returnData != null){
                  setState(() {
                    text = returnData;
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
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
            Spacer(flex: 1),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              children: [
                conceptButton('산책'),
                conceptButton('액티비티'),
                conceptButton('휴양'),
                conceptButton('맛집탐방'),
                conceptButton('체험'),
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
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                  ),
                  Flexible(
                    flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // button
                          MaterialButton(
                            onPressed: _showTimePicker,
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                  '${_timeOfDay.format(context)}',
                                  style: TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                            color: Colors.black,
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
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                  Text('${_value.toStringAsFixed(0)}개',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Spacer(flex: 1),
            // Slide Bar
            Center(
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
            ),
            // 버튼
            Spacer(flex: 2),
            ElevatedButton(
              onPressed: () {
                // Add code to handle the "Let's Go out" button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLoadingPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
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
        primary: selectedConcept == concept ? Colors.grey : Colors.black,
      ),
      child: Text(concept,style: TextStyle(color: Colors.white),),
    );
  }
}