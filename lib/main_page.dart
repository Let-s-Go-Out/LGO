import 'dart:async';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart' as NaverMap;

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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final double verticalSpacing = screenHeight * 0.016; // Adjust the percentage as needed
    final double horizontalSpacing = screenWidth * 0.02; // 2% of screen width

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: EdgeInsets.all(horizontalSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalSpacing * 2),
              child: Text(
                'AI 추천',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenHeight * 0.04,
                    fontWeight: FontWeight.bold), // 4% of screen height
              ),
            ),
            SizedBox(height: verticalSpacing),
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalSpacing),
              child: Text(
                'Please enter all the information',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: verticalSpacing),
            Text('출발지'),
            SizedBox(height: verticalSpacing),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '출발지를 입력하세요',
              ),
            ),
            SizedBox(height: verticalSpacing),
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
            SizedBox(height: verticalSpacing),
            Text('희망 출발 시간'),
            SizedBox(height: verticalSpacing),
            ElevatedButton(
              onPressed: () {
                // Add code to handle selecting the start time
              },
              child: Text('시간 설정'),
            ),
            SizedBox(height: verticalSpacing),
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
            Flexible(
              child: Container(),
            ),
            // Add a flexible widget to occupy the remaining space
          ],
        ),
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

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  late NaverMapController _mapController;
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pixelRatio = mediaQuery.devicePixelRatio;
    final mapSize =
    Size(mediaQuery.size.width - 32, mediaQuery.size.height - 72);
    final physicalSize =
    Size(mapSize.width * pixelRatio, mapSize.height * pixelRatio);

    print("physicalSize: $physicalSize");

    return Scaffold(
      backgroundColor: const Color(0xFF343945),
      body: Center(
          child: SizedBox(
              width: mapSize.width,
              height: mapSize.height,
              // color: Colors.greenAccent,
              child: _naverMapSection())),
    );
  }

  Widget _naverMapSection() => NaverMap(
    options: const NaverMapViewOptions(
        indoorEnable: true,
        locationButtonEnable: false,
        consumeSymbolTapEvents: false),
    onMapReady: (controller) async {
      _mapController = controller;
      mapControllerCompleter.complete(controller);
      log("onMapReady", name: "onMapReady");
    },
  );
}