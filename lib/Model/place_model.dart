// 사용자 경로 정보 입력 시 입력한 출발지 기준 주변 장소 지도 + 목록 화면에 나타낼 때, 장소 관련 model

class Place {
  final String placeId;
  final String name;
  final double placeLat;
  final double placeLng;

  Place({
    required this.placeId,
    required this.name,
    required this.placeLat,
    required this.placeLng,
  });
}
