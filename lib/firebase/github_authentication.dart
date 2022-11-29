import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GithubAuthentication {
  // OAuth2Client ghClient = GitHubOAuth2Client(
  //     redirectUri: 'my.test.app://oauth2redirect',
  //     customUriScheme: 'my.test.app');

  // Future<void> fetchFiles() async {
  //   var hlp = OAuth2Helper(
  //     GoogleOAuth2Client(
  //         redirectUri: 'com.teranet.app:/oauth2redirect',
  //         customUriScheme: 'com.teranet.app'),
  //     grantType: OAuth2Helper.authorizationCode,
  //     clientId: 'XXX-XXX-XXX',
  //     clientSecret: 'XXX-XXX-XXX',
  //     scopes: ['https://www.googleapis.com/auth/drive.readonly'],
  //   );

  //   var resp = await hlp.get('https://www.googleapis.com/drive/v3/files');

  //   print(resp.body);
  // }

  Future<bool> getSomething() async {
    try {
      var githubProvider = GithubAuthProvider();
      githubProvider
          .addScope('https://profinder-app.firebaseapp.com/__/auth/handler');
      githubProvider.setCustomParameters({
        'allow_signup': 'false',
      });

      var newAuth = await FirebaseAuth.instance
          .signInWithProvider(githubProvider)
          .then((value) async {
        print('Credenciales1: ${value.additionalUserInfo}');
        print('Credenciales2: ${value.user}');
        print('Credenciales3: ${value.toString()}');
        print('Credenciales4: ${value.credential}');
        print('Credenciales: ${value.hashCode}');

        final docUser = FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.email);
        final json = {
          'name': value.user!.displayName,
          'username': value.user!.displayName,
          'email': value.user!.email,
          'number': '',
          'role': 2,
          'picture': value.user!.photoURL,
        };
        await docUser.set(json);
      });

      //fin creating the user

      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          msg: "Now you're logged in with Github");
      //print(newAuth.whenComplete(() => print('Hey')));
      return true;
    } catch (e) {
      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, msg: '$e');
      return false;
    }
  }
}
