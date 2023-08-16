import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Model/user_model.dart';
import 'auth_controller.dart';

class UserController extends GetxController {

  Rx<UserModel?> userData = UserModel().obs;

  String? uid;

  Future<String?> usingAuth() async {
    AuthController authForMyPage = AuthController();
    return uid = await authForMyPage.getUserUid();
  }

  //Firestore 안에 사용자 정보 가져오기
  Future<void> fetchUserData() async{
    try {
      var snapshot = await FirebaseFirestore.instance.collection('Users')
          .doc(uid).get();
      if (snapshot.exists) {
        userData.value = UserModel.fromSnapshot(snapshot);
      }
    } catch (e) { print('Error fetching userData: $e'); }
  }


  //
  void updateNickname(String newNickname) {

    FirebaseFirestore.instance.collection('Users')
        .doc(uid).update({'nickname': newNickname});

  }


  //
  void updatePassword(String newPassword) {

    FirebaseFirestore.instance.collection('Users')
        .doc(uid).update({'password': newPassword});

  }


  void logout() async {
    try {
      //실행시 기능 구현 되는 지 확인
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error logging out: $e');
    }
  }



  //firebase Auth, firestore 에서 계정, 정보 삭제
  void deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) { await user.delete(); }

      FirebaseFirestore.instance.collection('Users').doc('uid').delete();

    } catch (e) { print('Error deleting Account; $e'); }
  }

}
