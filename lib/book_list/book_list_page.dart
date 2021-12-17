import 'package:book_list_sample/add_book/add_book_page.dart';
import 'package:book_list_sample/book_list/book_list_model.dart';
import 'package:book_list_sample/domain/book.dart';
import 'package:book_list_sample/edit_book/edit_book_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      //画面を開いたときに最初にfetchBookListを実行する。
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(title: Text('本一覧')),
        body: Center(
          //notifyListenersによって発火する。
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;
            //fetchBookList完了まではbooksがNULLなので待ち表示する。
            if (books == null) {
              return CircularProgressIndicator();
            }
            //booksをList<Widget>型に変換する。
            final List<Widget> widgets = books
                .map(
                  (book) => Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.only(
                        right: 20,
                      ),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      // ここで確認を行う
                      // Future<bool> で確認結果を返す
                      // False の場合削除されない
                      return await showConfirmDialog(context, book);
                    },
                    onDismissed: (direction) async {
                      // 削除アニメーションが完了し、リサイズが終了したときに呼ばれる
                      await model.delete(book);
                      final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('${book.title}を削除しました'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      //画面を更新
                      model.fetchBookList();
                    },
                    child: ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.author),
                      onTap: () async {
                        final String? title = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBookPage(book),
                          ),
                        );
                        //編集成功したらsnackbarを表示
                        if (title != null) {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('$titleを編集しました'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          //画面を更新
                          model.fetchBookList();
                        }
                      },
                    ),
                  ),
                )
                .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              //画面遷移
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  fullscreenDialog: true, //pageが下から出現
                ),
              );
              //追加成功したらsnackbarを表示
              if (added != null && added == true) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('本を追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              //画面を更新
              model.fetchBookList();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        }), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Future showConfirmDialog(BuildContext context, Book book) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text('削除の確認'),
          content: Text('${book.title}を削除しますか？'),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
