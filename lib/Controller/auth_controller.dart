import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import '../Model/user.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isEmailDuplicate(String email) async {
    try {
      final result = await _firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      print('이메일 중복 체크 실패: $e');
      return false;
    }
  }

  Future<bool> isNicknameDuplicate(String nickname) async {
    try {
      final result = await _firestore
          .collection('Users')
          .where('nickname', isEqualTo: nickname)
          .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      print('닉네임 중복 체크 실패: $e');
      return false;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('로그인 실패: $e');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password, String nickname) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Firebase Firestore에 회원가입 정보 저장
        await _firestore.collection('Users').doc(user.uid).set({
          'email': email,
          'password': password,
          'nickname': nickname,
        });
      }

      return user;
    } catch (e) {
      print('회원가입 실패: $e');
      return null;
    }
  }

  //*
  Future<String?> getUserUid() async {
    try {
      final user = _auth.currentUser;
      return user?.uid;
    } catch(e) {
      print('사용자 UID 가져오기 실패: $e');
      return null;
    }
  }

}





