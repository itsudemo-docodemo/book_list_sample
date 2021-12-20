import 'package:book_list_sample/domain/book.dart';
import 'package:book_list_sample/edit_book/edit_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBookPage extends StatelessWidget {
  final Book book;
  EditBookPage(this.book);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBookModel>(
      create: (_) => EditBookModel(book),
      child: Scaffold(
        appBar: AppBar(title: Text('本を編集')),
        body: Center(
          //notifyListenersによって発火する。
          child: Consumer<EditBookModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.titleController,
                    decoration: InputDecoration(
                      hintText: '本のタイトル',
                    ),
                    onChanged: (text) {
                      model.setTitle(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: model.authorController,
                    decoration: InputDecoration(
                      hintText: '本の著者',
                    ),
                    onChanged: (text) {
                      model.setAuthor(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    //titleとauthorがNULLでなければボタン有効
                    onPressed: model.isUpdated()
                        ? () async {
                            //追加の処理
                            try {
                              await model.update();
                              //画面を閉じる
                              Navigator.of(context).pop(model.title);
                            } catch (e) {
                              //snackbarを表示
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : null, //titleとauthorがNULLならボタン無効
                    child: Text('更新する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
