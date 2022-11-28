import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<bool> googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      var newUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      //Creating a new user

      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.user!.email);
      final json = {
        'name': newUser.user!.displayName,
        'username': newUser.user!.displayName,
        'email': newUser.user!.email,
        'number': '',
        'role': 2,
        'picture': newUser.user!.photoURL,
      };
      await docUser.set(json);
      //fin creating the user

      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.yellow[200],
          msg: "Now you're logged in with Google");

      return true;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, msg: '$e');
      return false;
    }
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
