import 'package:flutter/material.dart';
import 'main_page.dart';

class MainBeginningPage extends StatefulWidget {
  @override
  _MainBeginningPageState createState() => _MainBeginningPageState();
}

class _MainBeginningPageState extends State<MainBeginningPage> {
  bool _animateBackground = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            top: _animateBackground ? -height : 0,
            child: Container(
              height: height,
              child: Image.asset(
                'assets/images/background_1.png',
                height: height,
              ),
            ),
          ),
          Container(
            height: height,
            child: Image.asset(
              'assets/images/shall_we_go_out.png',
              height: height,
            ),
          ),
          Positioned(
            left: 50,
            right: 50,
            bottom: 120,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black87,
                padding: EdgeInsets.symmetric(
                  vertical: 17,
                ),
              ),
              onPressed: () {
                setState(() {
                  _animateBackground = true;
                });
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                  );
                });
              },
              child: Text(
                '나가자!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
