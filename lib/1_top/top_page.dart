import 'package:book_list_sample/1_top/top_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TopModel>(
      //画面を開いたときに最初にログイン状態を確認する。
      create: (_) => TopModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('人生逃げ切り計算機'),
        ),
        body: Center(
          //notifyListenersによって発火する。
          child: Consumer<TopModel>(builder: (context, model, child) {
            return model.isSignIn() != false
                ? LogoutPage(model)
                : LoginPage(context, model);
          }),
        ),
      ),
    );
  }

  Container LogoutPage(TopModel model) {
    final leading_items = [
      '現在の年齢',
      '現在の貯金額',
      '投資利回り(税引前)',
      '年間支出額',
      '年金受給が開始される年齢',
      '受給年金(月額)',
      '年間インフレ率',
      '現在のその他所得'
    ];
    final trailing_items = ['歳', '万円', '%', '万円', '歳', '万円', '%', '万円'];
    final init_value_items = [60.0, 3000.0, 3.0, 200.0, 65.0, 10.0, 2.0, 0.0];
    var value_items = [60.0, 3000.0, 3.0, 200.0, 65.0, 10.0, 2.0, 0.0];

    return Container(
      padding: EdgeInsets.all(5),
      width: double.infinity,
      child: ListView.builder(
        itemCount: leading_items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 180,
              child: Text('${leading_items[index]}'),
            ),
            title: Container(
              width: 50,
              height: 40,
              child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '${init_value_items[index].toInt()}',
                  ),
                  textAlign: TextAlign.right, //右寄せ
                  textAlignVertical: TextAlignVertical.bottom,
                  /*
                    controller: TextEditingController(
                        text: '${value_items[index].toInt()}'), //初期値設定
                        */
                  onChanged: (String value) {
                    if (value.isEmpty == true) {
                      value_items[index] = init_value_items[index];
                    } else {
                      value_items[index] = double.parse(value);
                    }
                  }),
            ),
            subtitle: Container(
              width: 30,
              child:
                  Text('${trailing_items[index]}', textAlign: TextAlign.right),
            ),
            trailing: IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('${leading_items[index]}'),
                      content: Text('${leading_items[index]}'),
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

  Stack LoginPage(BuildContext context, TopModel model) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await model.signInWithAnonymousUser(context);
                },
                child: Text('匿名認証'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await model.signInWithGoogle(context);
                },
                child: Text('Google認証'),
              ),
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
