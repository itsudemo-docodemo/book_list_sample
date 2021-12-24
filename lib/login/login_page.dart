import 'package:book_list_sample/login/login_model.dart';
import 'package:book_list_sample/register/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('ログイン')),
        body: Center(
          //notifyListenersによって発火する。
          child: Consumer<LoginModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: model.emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (text) {
                          model.setEmail(text);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: model.passwordController,
                        decoration: const InputDecoration(
                          hintText: 'パスワード',
                        ),
                        onChanged: (text) {
                          model.setPassword(text);
                        },
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        //titleとauthorがNULLでなければボタン有効
                        onPressed: () async {
                          //Loading表示開始
                          model.startLoading();
                          //追加の処理
                          try {
                            await model.login();
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
                        child: const Text('ログイン'),
                      ),
                      TextButton(
                        //titleとauthorがNULLでなければボタン有効
                        onPressed: () async {
                          //画面遷移
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                              fullscreenDialog: true, //pageが下から出現
                            ),
                          );
                        },
                        child: const Text('新規登録の方はこちら'),
                      ),
                      ElevatedButton(
                        onPressed: () => _onSignInWithAnonymousUser(context),
                        child: Text('登録せず利用'),
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

  //登録せず利用
  Future<void> _onSignInWithAnonymousUser(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInAnonymously();
      //画面を閉じる
      Navigator.of(context).pop();
    } catch (e) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('エラー'),
              content: Text(e.toString()),
            );
          });
    }
  }
}
