import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:profinder_app_flutter/constants.dart';

class AuthenticationButtons extends StatefulWidget {
  const AuthenticationButtons({Key? key}) : super(key: key);

  @override
  State<AuthenticationButtons> createState() => _AuthenticationButtonsState();
}

class _AuthenticationButtonsState extends State<AuthenticationButtons> {
  @override
  Widget build(BuildContext context) {
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
              print('facebook');
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
          ),
          child: IconButton(
            onPressed: () {
              print('google');
            },
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
          ),
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
