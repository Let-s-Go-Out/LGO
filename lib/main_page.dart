import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nagaja_app/map_browse_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedConcept = '';
  String selectedStartTime = '';
  String selectedDuration = '';

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
            Text('희망 출발 시간'),
            SizedBox(height: verticalSpacing),
            ElevatedButton(
              onPressed: () {
                // Add code to handle selecting the start time
              },
              child: Text('시간 설정'),
            ),
            SizedBox(height: verticalSpacing * 2),
            Text('희망 소요 시간'),
            SizedBox(height: verticalSpacing),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '최소 시간',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '최대 시간',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: verticalSpacing),
            ElevatedButton(
              onPressed: () {
                // Add code to handle the "Let's Go out" button
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
