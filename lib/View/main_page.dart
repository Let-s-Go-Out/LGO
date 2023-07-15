import 'dart:async';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:nagaja_app/View/map_browse_screen.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:nagaja_app/View/main_page_loading.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedConcept = '';
  String selectedStartTime = '';
  String selectedDuration = '';

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
    return Scaffold(
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalSpacing),
              child: Text(
                'AI Recommendation',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: verticalSpacing*0.05),
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalSpacing*0.05),
              child: Text(
                'Please enter all the information',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: verticalSpacing * 2),
            Text('출발지'),
            SizedBox(height: verticalSpacing),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapBrowseScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '검색어를 입력하세요.',
                    style: TextStyle(fontSize:16.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: verticalSpacing * 2),
            Text('나들이 컨셉'),
            SizedBox(height: verticalSpacing),
            Wrap(
              spacing: 8.0,
              children: [
                conceptButton('산책'),
                conceptButton('액티비티'),
                conceptButton('휴양'),
                conceptButton('맛집탐방'),
                conceptButton('체험'),
              ],
            ),
            SizedBox(height: verticalSpacing * 2),

            // 희망 출발 시간 수정

            Row(
                children: [
                  Expanded(
                      child: Text('희망 출발 시간')),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // button
                          MaterialButton(
                            onPressed: _showTimePicker,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                  '${_timeOfDay.format(context)}',
                                  style: TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                            color: Colors.blue,
                          ),
                        ],
                      )
                  )
                ]
            ),

            SizedBox(height: verticalSpacing),

            // 희망 소요 시간 Slide Bar ver.

            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('희망 소요 시간'),
                  Text('${_value.toStringAsFixed(0)}시간'),
                ],
              ),
            ),
            SizedBox(height: verticalSpacing),
            Center(
              child: SfSlider(
                min: 0.0,
                max: 12.0,
                value: _value,
                interval: 2,
                showTicks: true,
                showLabels: true,
                minorTicksPerInterval: 1,
                onChanged: (dynamic value) {
                 setState(() {
                   _value = value;
                 });
                },
              ),
            ),

            SizedBox(height: verticalSpacing),

            ElevatedButton(
              onPressed: () {
                // Add code to handle the "Let's Go out" button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLoadingPage()),
                );
              },
              child: Text('Let\'s Go out'),
            ),
            SizedBox(height: verticalSpacing),
            Spacer(), // Add a spacer to push the bottom navigation bar to the bottom
          ],
        ),
      );
        },
        ),
      bottomNavigationBar: BottomNavigationBar(
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
        primary: selectedConcept == concept ? Colors.blue : null,
      ),
      child: Text(concept),
    );
  }
}