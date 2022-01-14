import 'package:book_list_sample/1_top/top_page.dart';
import 'package:book_list_sample/book_list/book_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //cloud_firestore初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookListSample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: TopPage(),
//      home: BookListPage(),
      home: GestureDetector(
        //その他領域タップでキーボード隠す
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: TopPage(),
      ),
    );
  }
}
