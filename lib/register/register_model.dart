import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? email;
  String? password;

  //Loading表示
  bool isLoading = false;
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  //titleをセット
  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  //authorをセット
  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  //Future型にしてtry catchできるように
  Future signUp() async {
    //textfieldの値を取得
    email = emailController.text;
    password = passwordController.text;

    //nullチェック
    if (email != null && password != null) {
      //firebase authでユーザー作成
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      final user = userCredential.user;

      if (user != null) {
        final uid = user.uid;

        //firestoreに追加
        final doc = FirebaseFirestore.instance.collection('users').doc(uid);
        await doc.set({
          'uid': uid,
          'email': email,
        });
      }
    }
  }
}
