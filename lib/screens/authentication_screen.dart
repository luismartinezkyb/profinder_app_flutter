import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:profinder_app_flutter/provider/google_provider.dart';
import 'package:profinder_app_flutter/provider/loading_provider.dart';
import 'package:provider/provider.dart';

import '../firebase/google_authentication.dart';

class AuthenticationButtons extends StatefulWidget {
  const AuthenticationButtons({Key? key}) : super(key: key);

  @override
  State<AuthenticationButtons> createState() => _AuthenticationButtonsState();
}

class _AuthenticationButtonsState extends State<AuthenticationButtons> {
  var loading = false;
  //final GoogleAuthentication _googleAuth = GoogleAuthentication();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoadingProvider watch = Provider.of<LoadingProvider>(context);

    void _logInWithFacebook() async {
      watch.setIfLoading(true);
      try {
        final facebookLoginResult = await FacebookAuth.instance.login();
        print(facebookLoginResult.status);
        if (facebookLoginResult.status == LoginStatus.success) {
          final facebookAuthCredential = FacebookAuthProvider.credential(
              facebookLoginResult.accessToken!.token);
          await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);

          final userData = await FacebookAuth.instance.getUserData();

          final docUser = FirebaseFirestore.instance
              .collection('users')
              .doc(userData['email']);
          final json = {
            'name': userData['name'],
            'username': userData['name'],
            'email': userData['email'],
            'number': '',
            'role': 2,
            'picture': userData['picture']['data']['url']
          };
          await docUser.set(json);
          //asdasdasdasd
          Fluttertoast.showToast(
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blue,
              msg: "Now you're logged in with Facebook");
          mounted
              ? Navigator.pushNamed(context, '/dashboard')
              : print('mounted');
          // if (mounted) {

          // } else {
          //   Navigator.pushNamed(context, '/dashboard');
          //   print('mounted');
          // }
        } else {
          watch.setIfLoading(false);

          Fluttertoast.showToast(
              gravity: ToastGravity.BOTTOM,
              msg: 'the action did not complete successfully');
        }
      } on FirebaseAuthException catch (e) {
        var title = '';
        print('ERROR EN: $e');
        Fluttertoast.showToast(
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            msg: '$e');
      } finally {
        if (mounted) {
          watch.setIfLoading(false);
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 90,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: .4),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white),
          child: IconButton(
            onPressed: () {
              _logInWithFacebook();
            },
            icon: Image.asset('assets/icons/facebook_logo.png'),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Container(
          height: 50,
          width: 90,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: .4),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white),
          child: IconButton(
            onPressed: () {
              //   watch.setIfLoading(true);
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider
                  .googleLogin()
                  .then((value) => print('El valor de esto da$value'));
            },
            // onPressed: () async {
            //   watch.setIfLoading(true);
            //   setState(() {});

            //   var googleLogin = await _googleAuth.googleLogin();
            //   if (googleLogin == true) {
            //     mounted
            //         ? Navigator.pushNamed(context, '/dashboard')
            //         : print('mounted!');
            //   } else {
            //     print('Credenciales invalidas');
            //     watch.setIfLoading(false);
            //     // setState(() {
            //     //   loading = false;
            //     // });
            //   }
            // },
            icon: Image.asset('assets/icons/google_logo.png'),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Container(
          height: 50,
          width: 90,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: .4),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white),
          child: IconButton(
            onPressed: () {
              print('github');
            },
            icon: Image.asset('assets/icons/github_logo.png'),
          ),
        ),
      ],
    );
  }
}
