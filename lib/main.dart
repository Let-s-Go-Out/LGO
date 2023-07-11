// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:nagaja_app/main_page.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// void main() async {
//   await _initialize();
//   _permission();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Outing Routes App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MainPage(), // Set the main page as the home screen
//     );
//   }
// }
//
// Future<void> _initialize() async {
//   WidgetsFlutterBinding.ensureInitialized();
// }
//
// void _permission() async {
//   var requestStatus = await Permission.location.request();
//   var status = await Permission.location.status;
//   if (requestStatus.isGranted && status.isLimited) {
//     // isLimited - 제한적 동의 (ios 14 < )
//     // 요청 동의됨
//     print("isGranted");
//     if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
//       // 요청 동의 + gps 켜짐
//       var position = await Geolocator.getCurrentPosition();
//       print("serviceStatusIsEnabled position = ${position.toString()}");
//     } else {
//       // 요청 동의 + gps 꺼짐
//       print("serviceStatusIsDisabled");
//     }
//   } else if (requestStatus.isPermanentlyDenied || status.isPermanentlyDenied) {
//     // 권한 요청 거부, 해당 권한에 대한 요청에 대해 다시 묻지 않음 선택하여 설정화면에서 변경해야함. android
//     print("isPermanentlyDenied");
//     openAppSettings();
//   } else if (status.isRestricted) {
//     // 권한 요청 거부, 해당 권한에 대한 요청을 표시하지 않도록 선택하여 설정화면에서 변경해야함. ios
//     print("isRestricted");
//     openAppSettings();
//   } else if (status.isDenied) {
//     // 권한 요청 거절
//     print("isDenied");
//   }
//   print("requestStatus ${requestStatus.name}");
//   print("status ${status.name}");
// }
//
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: MapSample()
  ));
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}