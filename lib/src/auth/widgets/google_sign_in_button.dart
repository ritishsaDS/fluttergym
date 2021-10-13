import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../shared/common.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final _googleSignIn = GoogleSignIn(
    clientId:
        '217680581108-fd9uksjddo4rhdvpl362rleac3fu033u.apps.googleusercontent.com',
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return GestureDetector(
      onTap: () async {
        // await _googleSignIn.signIn();
      },
      child: Image.asset(
        Assets.googleSignInButton,
        width: media.size.width * 0.4,
      ),
    );
  }
}
