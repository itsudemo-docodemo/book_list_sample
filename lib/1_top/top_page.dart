import 'package:book_list_sample/1_top/top_model.dart';
import 'package:book_list_sample/2_chart/chart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TopModel>(
      //画面を開いたときに最初にログイン状態を確認する。
      create: (_) => TopModel(),
      //notifyListenersによって発火する。
      child: Consumer<TopModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('人生逃げ切り計算機'),
          ),
          //Login未ならLogin画面を、Login済なら計算機画面を表示
          body: model.isSignIn() != false
              ? LogoutPage(model)
              : LoginPage(context, model),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Visibility(
            //Login未の場合、ボタンを非表示
            visible: model.isSignIn(),
            child: FloatingActionButton(
              onPressed: () async {
                await model.register();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Chart(model.value_items)),
                );
              },
              child: Text('計算'),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).primaryColor,
            notchMargin: 6.0,
            shape: AutomaticNotchedShape(
              RoundedRectangleBorder(),
              StadiumBorder(
                side: BorderSide(),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Visibility(
                    //Login未の場合、ボタンを非表示
                    visible: model.isSignIn(),
                    child: IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        model.signOutWithAnonymousUser();
                      },
/*
                      onPressed: !model.isSignIn()
                          ? null
                          : () {
                              model.signOutWithAnonymousUser();
                            },
*/
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    //情報ボタンの処理の実装はこれから
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  //人生逃げ切り計算機表示画面
  Container LogoutPage(TopModel model) {
    return Container(
      padding: EdgeInsets.all(5),
      width: double.infinity,
      child: ListView.builder(
        itemCount: model.leading_items.length,
        itemBuilder: (context, index) {
          return ListTile(
            //表の項目名
            leading: Container(
              width: 180,
              child: Text('${model.leading_items[index]}'),
            ),
            //表の項目の値
            title: Container(
              width: 50,
              height: 40,
              child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '${model.init_value_items[index].toInt()}',
                  ),
                  textAlign: TextAlign.right, //右寄せ
                  textAlignVertical: TextAlignVertical.bottom,
                  /*
                    controller: TextEditingController(
                        text: '${value_items[index].toInt()}'), //初期値設定
                        */
                  onChanged: (String value) {
                    if (value.isEmpty == true) {
                      model.value_items[index] = model.init_value_items[index];
                    } else {
                      model.value_items[index] = double.parse(value);
                    }
                  }),
            ),
            //表の項目の単位
            subtitle: Container(
              width: 30,
              child: Text('${model.trailing_items[index]}',
                  textAlign: TextAlign.right),
            ),
            //表の項目の内容説明
            trailing: IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      //仮実装
                      title: Text('${model.leading_items[index]}'),
                      content: Text('${model.leading_items[index]}'),
                      actions: <Widget>[
                        OutlinedButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
/*
    Column(
      children: [
        TextButton(
          onPressed: () async {
            //SignOut
            await model.signOutWithAnonymousUser();
          },
          child: const Text('Sign Out'),
        ),
      ],
    );
*/
  }

  //Login画面
  Stack LoginPage(BuildContext context, TopModel model) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //匿名認証
              ElevatedButton(
                onPressed: () async {
                  await model.signInWithAnonymousUser(context);
                  await model.register();
                },
                child: Text('匿名認証'),
              ),
              //Google認証
              ElevatedButton(
                onPressed: () async {
                  await model.signInWithGoogle(context);
                },
                child: Text('Google認証'),
              ),
              //Apple認証
              SignInWithAppleButton(
                style: SignInWithAppleButtonStyle.black,
                iconAlignment: IconAlignment.center,
                onPressed: () async {
                  await model.signInWithApple();
                },
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
  }
}
