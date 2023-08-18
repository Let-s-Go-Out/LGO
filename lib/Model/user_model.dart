import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? email;
  String? password;
  String? nickname;


  UserModel({ //required
    this.email,
    this.password,
    this.nickname,
  });


  String? get userEmail => email;
  String? get userNickname => nickname;
  String? get userPassword => password;


  //data 를 외부로 보내기 위한 양식 ? (삭제)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nickname': nickname,
    };
  }


  //data 를 내부로 받아 오기 위한 양식
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      email: data['email'],
      password: data['password'],
      nickname: data['nickname'],
    );
  }

}