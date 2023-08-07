// 사용자에게 입력받는 경로 정보를 데이터베이스에 저장한다. (출발지, 출발시각, 희망 장소 개수, 나들이 컨셉)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserRouteDataController {
  // Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 사용자 경로 정보 Firestore에 저장하는 함수
  Future<void> saveUserRouteData({
    required String departureAddress, // 출발지 - 주소
    required double departureGeopoint, // 출발지 - 위도+경도
    required String concept, // 나들이 컨셉
    required String startTime,// 출발시간
    required int placeCount // 희망 장소 개수
  }) async {
    try {
      // Firestore에 데이터 저장
      await _firestore.collection('Users').doc(userId).set({ // doc userId 혹은 user UID 혹은 documentId??
        // 필드 이름 : 변수
        'departure_address' : departureAddress,
        'departure_geopoint' : departureGeopoint,
        'concept' : concept,
        'start_time' : startTime,
        'place_count' : placeCount
      });

      print('사용자 경로 정보 저장 완료');
    } catch (e) {
      print('사용자 경로 정보 저장 실패: $e');
    }
  }

}