import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'book_list_page.dart';

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
      home: BookListPage(),
    );
  }
}
