import 'package:firebase_auth/firebase_auth.dart';
class UserModel {
  final String uid;
  final String email;
  final String nickname;

  UserModel({required this.uid, required this.email, required this.nickname});

  // User 객체를 UserModel 객체로 변환하는 팩토리 메서드
  factory UserModel.fromUser(User user) {
    return UserModel(uid: user.uid, email: user.email ?? '', nickname: '');
  }
}



