import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUserWithEmailAndPassword({
    required String name,
    required String username,
    required String email,
    required String password,
    String? number,
    required int role,
    String? picture,
  }) async {
    try {
      //print('Nombre: $name, Email: $email y pass: $password');

      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //print('CREDENCIALES USER ${userCredential.user!}');
      User? user = userCredential.user!;

      user.sendEmailVerification();
      user.updateDisplayName(name);
      await user.reload();
      user = await _auth.currentUser;
      //Creating a new user
      final docUser = FirebaseFirestore.instance.collection('users').doc(email);
      final json = {
        'name': name,
        'username': username,
        'email': email,
        'number': number != null ? number : '',
        'role': role,
        'picture': picture != null ? picture : '',
        'description': '',
        'level': '7.4',
      };
      await docUser.set(json);
      //fin creating the user
      //print('usuario final es: $user');
      return true;
    } catch (e) {
      print('$e');
      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, msg: '$e');
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }
}
