import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookListModel extends ChangeNotifier {
  //collectionが変化したら発火するStreamを定義
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('books').snapshots();

  List<Book>? books;

  //変化をlistenする
  void fetchBookList() {
    //listenして変化があったらsnapshotに値が入る
    _usersStream.listen((QuerySnapshot snapshot) {
      //snapshotのdocumentをmap(変換)する（DocumentSnapshot型⇨Book型）
      final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
        //まずはString,dynamicのdataに変換する
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        //dataからtitleとauthorを取り出す
        final String title = data['title'];
        final String author = data['author'];
        //Bookにしてmapの中でリターンする
        return Book(title, author);
      }).toList();
      //this.booksに格納して、完了を通知(notifyListeners)。
      //すると、book_list_pageのConsumerが発火する。
      this.books = books;
      notifyListeners();
    });
  }
}
