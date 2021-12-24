import 'package:book_list_sample/login2/login2_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Login2Model>(
      create: (_) => Login2Model(),
      child: Scaffold(
        appBar: AppBar(title: const Text('ログイン2')),
        body: Center(
          //notifyListenersによって発火する。
          child: Consumer<Login2Model>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await model.signInWithAnonymousUser(context);
                        },
                        child: Text('匿名認証'),
                      ),
                      TextButton(
                        onPressed: model.isLogin()
                            ? () async {
                                //ログアウト
                                await model.logOut();
                                //画面を閉じる
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: const Text('匿名ログアウト'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await model.signInWithGoogle(context);
                        },
                        child: Text('Google認証'),
                      ),
                      TextButton(
                        onPressed: () async {
                          //ログアウト
                          await model.signOutWithGoogle();
                          //画面を閉じる
                          Navigator.of(context).pop();
                        },
                        child: const Text('Googleログアウト'),
                      ),
                    ],
                  ),
                ),
                //Loading表示
                if (model.isLoading)
                  Container(
                      color: Colors.black54,
                      child: const Center(
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
