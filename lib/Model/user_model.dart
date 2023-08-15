
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  //String? id;
  String? email;
  String? password;
  String? nickname;
  String? uid;


  UserModel({ //required
    //this.id,
    this.email,
    this.password,
    this.nickname,
    this.uid,
  });

  //
  //String? get userId => id;
  String? get userEmail => email;
  String? get userNickname => nickname;
  String? get userPassword => password;
  String? get userUid => uid;


  //data 를 외부로 보내기 위한 양식 ? (삭제)
  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'email': email,
      'passwd': password,
      'nickname': nickname,
    };
  }


  //data 를 내부로 받아 오기 위한 양식
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      //id: data['id'],
      email: data['email'],
      password: data['passwd'],
      nickname: data['nickname'],
      uid: data['uid'],
    );
  }

}