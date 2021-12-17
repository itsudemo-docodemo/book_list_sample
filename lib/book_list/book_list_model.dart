import 'package:book_list_sample/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookListModel extends ChangeNotifier {
  List<Book>? books;

  //変化をlistenする
  void fetchBookList() async {
    //getしてsnapshotoに値が入る。
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('books').get();
    //snapshotのdocumentをmap(変換)する（DocumentSnapshot型⇨Book型）
    final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
      //まずはString,dynamicのdataに変換する
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      //dataからidとtitleとauthorを取り出す
      final String id = document.id;
      final String title = data['title'];
      final String author = data['author'];
      //Bookをinitializeしてリターンする
      return Book(id, title, author);
    }).toList();
    //this.booksに格納して、完了を通知(notifyListeners)。
    //すると、book_list_pageのConsumerが発火する。
    this.books = books;
    notifyListeners();
  }

  Future delete(Book book) {
    return FirebaseFirestore.instance.collection('books').doc(book.id).delete();
  }
}
