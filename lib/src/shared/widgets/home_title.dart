import 'package:flutter/material.dart';

import '../common.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({
    required this.title,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).horizontalBlockSize;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: size * 3.5),
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Text(
                'See More >>',
                style: TextStyle(fontSize: size * 3.5),
              ),
            ),
        ],
      ),
    );
  }
}
