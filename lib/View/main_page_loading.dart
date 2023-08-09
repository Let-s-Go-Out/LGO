import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nagaja_app/View/main_route_page.dart';

import '../Controller/map_controller.dart';



class MainLoadingPage extends StatefulWidget {
  const MainLoadingPage({Key? key}) : super(key: key);

  @override
  _MainLoadingPageState createState() => _MainLoadingPageState();
}

class _MainLoadingPageState extends State<MainLoadingPage> {
  MapController controller = MapController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getLocation() async {
    var position = await controller.getPosition();
    setState(() {
      controller.model.nowPosition = position;
      controller.model.nowPLatLng = LatLng(controller.model.nowPosition!.latitude, controller.model.nowPosition!.longitude);
      print(controller.model.nowPLatLng);
      isLoading = false;
    });

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainRoutePage(initialLatLng: controller.model.nowPLatLng)));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      Future.delayed(Duration(seconds: 3));
      getLocation();
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SpinKitPianoWave(
            color: Colors.black,
            size: 80.0,
          ),
        ),
      );
    } else{
      return MainRoutePage(initialLatLng: controller.model.nowPLatLng);
    }
  }
}