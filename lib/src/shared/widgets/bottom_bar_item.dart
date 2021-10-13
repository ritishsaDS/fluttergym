import 'package:flutter/material.dart';

import '../common.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem({
    required this.label,
    required this.active,
    required this.onTap,
    this.image,
    this.icon,
    Key? key,
  }) : super(key: key);

  final String label;

  final bool active;

  final IconData? icon;

  final String? image;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (image != null)
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                active ? kAccentAppColor : Colors.white,
                BlendMode.srcATop,
              ),
              child: Image.asset(
                image!,
                height: 25,
              ),
            )
          else if (icon != null)
            Icon(
              icon,
              size: 28,
              color: active ? kAccentAppColor : Colors.white,
            ),
          Text(
            label,
            style: TextStyle(
              fontSize: kTextSizeSmall,
              color: active ? kAccentAppColor : Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
