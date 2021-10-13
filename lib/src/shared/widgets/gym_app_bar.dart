import 'package:flutter/material.dart';

import '../common.dart';

// ignore: prefer_mixin
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    required this.label,
    required this.assetImage,
    Key? key,
  }) : super(key: key);

  final String label;

  final String assetImage;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(label),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Image.asset(
            assetImage,
            height: 35,
            width: 35,
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kAccentAppColor,
              kPrimaryAppColor,
            ],
            begin: Alignment(-0.7, 20),
            end: Alignment(5, -2),
          ),
        ),
      ),
    );
  }
}
