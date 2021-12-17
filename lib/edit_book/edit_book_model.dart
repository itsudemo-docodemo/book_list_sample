import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditBookModel extends ChangeNotifier {
  //初期化処理でbookのtitleとauthorをControllerに格納する
  final Book book;
  EditBookModel(this.book) {
    titleController.text = book.title;
    authorController.text = book.author;
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();

  String? title;
  String? author;

  //titleをセット
  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  //authorをセット
  void setAuthor(String author) {
    this.author = author;
    notifyListeners();
  }

  //更新ボタンの有効無効化用
  bool isUpdated() {
    return title != null || author != null;
  }

  //Future型にしてtry catchできるように
  Future update() async {
    //textfieldの値を取得
    title = titleController.text;
    author = authorController.text;
    //nullチェック
    if (title == null || title!.isEmpty) {
      throw 'タイトルが入力されていません';
    }
    if (author == null || author!.isEmpty) {
      throw '著者が入力されていません';
    }
    //firestoreに追加
    await FirebaseFirestore.instance.collection('books').doc(book.id).update({
      'title': title,
      'author': author,
    });
  }
}
