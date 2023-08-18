import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Model/user_model.dart';

class UserController extends GetxController {

  Rx<UserModel?> userData = UserModel().obs;

  String? uid;

  Future<String?> getUid() async {
    try {
      var auth = await FirebaseAuth.instance;
      uid = auth.currentUser!.uid;
    } catch(e) {
      print('사용자 UID 가져오기 실패: $e');
      return null;
    }
  }


  Future<void> fetchUserData() async {
    getUid();
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



  
  void updateNickname(String newNickname) {
    getUid();
    FirebaseFirestore.instance.collection('Users')
        .doc(uid).update({'nickname': newNickname});

  }


  
  void updatePassword(String newPassword) async {
    getUid();

    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
    } catch (e) {
      print('Error updating password in Firebase Authentication: $e');
      return;
    }

    FirebaseFirestore.instance.collection('Users')
        .doc(uid).update({'password': newPassword});
  }


  void logout() async {
    try {
      //
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error logging out: $e');
    }
  }


  //firebase Auth, firestore 에서 계정 삭제
  void deleteAccount() async {
    getUid();
    try {
      FirebaseFirestore.instance.collection('Users')
          .doc(uid).delete();
      await FirebaseAuth.instance.currentUser!.delete();

    } catch (e) { print('Error deleting Account; $e'); }

  }

}
