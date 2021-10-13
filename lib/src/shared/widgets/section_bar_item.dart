import 'package:flutter/material.dart';

class HomeSectionBarItem extends StatelessWidget {
  const HomeSectionBarItem({
    required this.assetImage,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String assetImage;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        assetImage,
        height: 50,
        width: 150,
      ),
    );
  }
}
