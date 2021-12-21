import 'package:book_list_sample/edit_profile/edit_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage(this.name, this.profile);
  final String name;
  final String profile;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditProfileModel>(
      create: (_) => EditProfileModel(
        name,
        profile,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('プロフィール編集')),
        body: Center(
          //notifyListenersによって発火する。
          child: Consumer<EditProfileModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.nameController,
                    decoration: const InputDecoration(
                      hintText: '名前',
                    ),
                    onChanged: (text) {
                      model.setName(text);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: model.descriptionController,
                    decoration: const InputDecoration(
                      hintText: '自己紹介',
                    ),
                    onChanged: (text) {
                      model.setDescription(text);
                    },
                  ),
                  const SizedBox(
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
                              Navigator.of(context).pop();
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
                    child: const Text('更新する'),
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
