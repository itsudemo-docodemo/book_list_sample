import 'package:book_list_sample/register/register_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(title: Text('新規登録')),
        body: Center(
          //notifyListenersによって発火する。
          child: Consumer<RegisterModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: model.emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (text) {
                          model.setEmail(text);
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: model.passwordController,
                        decoration: InputDecoration(
                          hintText: 'パスワード',
                        ),
                        onChanged: (text) {
                          model.setPassword(text);
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        //titleとauthorがNULLでなければボタン有効
                        onPressed: () async {
                          //Loading表示開始
                          model.startLoading();
                          //追加の処理
                          try {
                            await model.signUp();
                            //画面を閉じる
                            Navigator.of(context).pop();
                          } catch (e) {
                            //snackbarを表示
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } finally {
                            //Loading表示終了
                            model.endLoading();
                          }
                        },
                        child: Text('登録する'),
                      ),
                    ],
                  ),
                ),
                //Loading表示
                if (model.isLoading)
                  Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ))
              ],
            );
          }),
        ),
      ),
    );
  }
}
