import 'package:flutter/material.dart';

import '../../shared/common.dart';

class SplashScreenButton extends StatelessWidget {
  const SplashScreenButton({
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: kPrimaryAppColor,
          fontSize: media.horizontalBlockSize * 4,
        ),
      ),
    );
  }
}
