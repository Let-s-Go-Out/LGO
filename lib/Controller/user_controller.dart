import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Model/user_model.dart';

class UserController extends GetxController {

  Rx<UserModel?> userData = UserModel().obs;


  Future<void> fetchUserData(String uid) async{
    try {
      var snapshot = await FirebaseFirestore.instance.collection('Users')
          .doc('hRH8bW3OHSGlYZ0wPAAv').get(); //.doc(uid).get();
      if (snapshot.exists) {
        userData.value = UserModel.fromSnapshot(snapshot);
      }
    } catch (e) { print('Error fetching userData: $e'); }
  }


  //updateNickname(String uid, String newNickname)
  void updateNickname(String newNickname) {

    FirebaseFirestore.instance.collection('Users')
        .doc('hRH8bW3OHSGlYZ0wPAAv').update({'nickname': newNickname});


  }


  //updatePassword(String uid, String newPassword)
  void updatePassword(String? newPassword) {

    FirebaseFirestore.instance.collection('Users')
        .doc('hRH8bW3OHSGlYZ0wPAAv').update({'passwd': newPassword});

  }

  //deleteAccount()
  void deleteAccount() {
    FirebaseFirestore.instance.collection('Users').doc('uid').delete();
    //firebase Auth 에서 삭제
  }

}
