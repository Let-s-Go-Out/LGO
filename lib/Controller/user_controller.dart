import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Model/user_model.dart';
import 'auth_controller.dart';

class UserController extends GetxController {

  Rx<UserModel?> userData = UserModel().obs;

  String? uid;

  Future<String?> getUid() async {

    AuthController authForMyPage = AuthController();
    uid = await authForMyPage.getUserUid();

    try {
      var auth = await FirebaseAuth.instance;
      uid = auth.currentUser!.uid;
    } catch(e) {
      print('사용자 UID 가져오기 실패: $e');
      return null;
    }
  }

  /*//Firestore 안에 사용자 정보 가져오기
  Future<void> fetchUserData() async{
    getUid();
    try {
      await usingAuth(); // uid를 설정한 후 Firestore에서 데이터 가져오기
      var snapshot = await FirebaseFirestore.instance.collection('Users')
          .doc(uid).get();
      if (snapshot.exists) {
        userData.value = UserModel.fromSnapshot(snapshot);
      }
    } catch (e) { print('Error fetching userData: $e'); }
  }*/

  Future<void> fetchUserData() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        var snapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
        if (snapshot.exists) {
          userData.value = UserModel.fromSnapshot(snapshot);
        }
      }
    } catch (e) {
      print('Error fetching userData: $e');
    }
  }



  //
  void updateNickname(String newNickname) {
    getUid();
    FirebaseFirestore.instance.collection('Users')
        .doc(uid).update({'nickname': newNickname});

  }


  //
  void updatePassword(String newPassword) {
    getUid();
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
      FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser!.uid).delete();
      await FirebaseAuth.instance.currentUser!.delete();

    } catch (e) { print('Error deleting Account; $e'); }

  }

}