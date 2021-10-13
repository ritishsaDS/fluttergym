import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'shared/common.dart';

mixin AppThemeData {
  static ThemeData theme(BuildContext context, {Brightness? brightness}) {
    return ThemeData(
      brightness: brightness,
      fontFamily: GoogleFonts.montserrat().fontFamily,
      // ignore: deprecated_member_use
      accentColor: kAccentAppColor,
      primaryColor: kPrimaryAppColor,
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return theme(context, brightness: Brightness.dark);
  }
}
