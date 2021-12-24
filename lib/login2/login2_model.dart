import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login2Model extends ChangeNotifier {
  //Loading表示
  bool isLoading = false;
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  //匿名で認証
  Future<void> signInWithAnonymousUser(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    startLoading();
    try {
      await firebaseAuth.signInAnonymously();

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
    } finally {
      endLoading();
    }
  }

  //ログアウト
  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //ログアウトボタンの有効無効化用
  bool isLogin() {
    return FirebaseAuth.instance.currentUser != null;
  }

  //Google認証
  Future<void> signInWithGoogle(BuildContext context) async {
    // Google 認証
    final _google_signin = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]);
    GoogleSignInAccount? googleUser;
    GoogleSignInAuthentication googleAuth;
    AuthCredential credential;

    // Firebase 認証
    final _auth = FirebaseAuth.instance;
    UserCredential result;
    User? user;

    // Google認証の部分
    googleUser = await _google_signin.signIn();
    googleAuth = await googleUser!.authentication;

    credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Google認証を通過した後、Firebase側にログイン　※emailが存在しなければ登録
    try {
      result = await _auth.signInWithCredential(credential);
      user = result.user;
      print('ログイン成功:${user!.uid}');
/*
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(user_id: user.uid),
          ));
*/
    } catch (e) {
      print(e);
    }
  }

  //Googleログアウト
  Future<void> signOutWithGoogle() async {
    // Google 認証
    final _google_signin = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]);

    // Firebase 認証
    final _auth = FirebaseAuth.instance;

    _auth.signOut();
    _google_signin.signOut();
    print('サインアウトしました。');
  }
}
