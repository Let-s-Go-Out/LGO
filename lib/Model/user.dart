import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String nickname;
  //final String password;

  UserModel({
    required this.uid,
    required this.email,
    required this.nickname,
    //required this.password,
  });

  // User 객체와 Firestore에서 가져온 nickname을 사용하여 UserModel 객체로 변환하는 팩토리 메서드
  factory UserModel.fromUser(User user, String nickname) {
    return UserModel(uid: user.uid, email: user.email ?? '', nickname: nickname);
  }


  // // 마이페이지
  // factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   return UserModel(
  //     uid: data['uid'] ?? '',
  //     email: data['email'] ?? '',
  //     nickname: data['nickname'] ?? '',
  //   );
  // }
}



