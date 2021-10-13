import 'package:flutter/material.dart';

extension MediaQueryExtensions on MediaQueryData {
  double get horizontalBlockSize {
    return size.width / 100;
  }

  double get verticalBlockSize {
    return size.height / 100;
  }
}

void importExtensionFile() {}
