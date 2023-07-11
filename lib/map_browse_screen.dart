// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter/foundation.dart';
//
// class MapBrowseScreen extends StatefulWidget {
//   const MapBrowseScreen({Key? key}) : super(key: key);
//
//   @override
//   _MapBrowseScreenState createState() => _MapBrowseScreenState();
// }
//
// class _MapBrowseScreenState extends State<MapBrowseScreen> {
//   late Position _position;
//
//   get controller => null;
//
//   @override
//   void initState() {
//     super.initState();
//     _getPosition();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void _getPosition() async{
//     try {
//       LocationPermission permission = await Geolocator.requestPermission();
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _position = position; // 위치 정보 업데이트
//       });
//       print(position);
//     }catch(e){
//       print('There was a problem with the internet connection.');
//     }
//   }
//
//   @override
//   Future<void> _performSearch() async {
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('지도 검색'),
//       ),
//       body: Column(children: [
//         Container(
//           padding: EdgeInsets.all(8.0),
//           child: TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               hintText: '장소를 검색하세요.',
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.search),
//                 onPressed: _performSearch,
//               ),
//             ),
//             onSubmitted: (_) => _performSearch(),
//           ),
//         ),
//       ]),
//     );
//   }
// }