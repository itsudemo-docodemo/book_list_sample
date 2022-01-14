import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class TopModel extends ChangeNotifier {
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

  //SignIn有無を確認する
  bool isSignIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      //SignInしている
      return true;
    } else {
      //ログインしていない
      return false;
    }
  }

  //匿名でサインイン
  Future<void> signInWithAnonymousUser(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    //SignIn処理開始
    startLoading();
    try {
      await firebaseAuth.signInAnonymously();

//      Navigator.of(context).pop();
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
      //SignIn処理終了
      endLoading();
    }
  }

  //匿名でサインアウト
  Future signOutWithAnonymousUser() async {
    //SignIn処理開始
    startLoading();

    //Sign Out
    await FirebaseAuth.instance.signOut();

    //SignIn処理終了
    endLoading();
  }

  //Google認証
  Future<void> signInWithGoogle(BuildContext context) async {
    //SignIn処理開始
    startLoading();

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
    } finally {
      //SignIn処理終了
      endLoading();
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    //SignIn処理開始
    startLoading();

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      print(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final _firebaseAuth = FirebaseAuth.instance;
      final authResult =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      final userEmail = '${appleCredential.email}';

      final firebaseUser = authResult.user;
      print(displayName);
/*
      await firebaseUser.updateProfile(displayName: displayName);
      await firebaseUser.updateEmail(userEmail);

      return firebaseUser;
*/
    } catch (exception) {
      print(exception);
    } finally {
      //SignIn処理終了
      endLoading();
    }
  }
}
