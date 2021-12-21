import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
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
  Future login() async {
    //textfieldの値を取得
    email = emailController.text;
    password = passwordController.text;
    //nullチェック
    if (email != null && password != null) {
      //firebase authでユーザーログイン
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
    }
  }
}
