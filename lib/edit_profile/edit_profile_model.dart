import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel(this.name, this.description) {
    nameController.text = name!;
    descriptionController.text = description!;
  }

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String? name;
  String? description;

  //titleをセット
  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  //authorをセット
  void setDescription(String description) {
    this.description = description;
    notifyListeners();
  }

  //更新ボタンの有効無効化用
  bool isUpdated() {
    return name != null || description != null;
  }

  //Future型にしてtry catchできるように
  Future update() async {
    //textfieldの値を取得
    name = nameController.text;
    description = descriptionController.text;
    //nullチェック
    if (name == null || name!.isEmpty) {
      throw '名前が入力されていません';
    }
    if (description == null || description!.isEmpty) {
      throw '自己紹介が入力されていません';
    }
    //firestoreに追加
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'description': description,
    });
  }
}
