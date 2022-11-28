import 'package:flutter/material.dart';

import '../../provider/theme_provider.dart';
import '../../settings/style_settings.dart';

ColorWidgetRow(ThemeProvider? tema) {
  bool checkIcon = tema!.getNumber() == Color(0xff1f618d);
  return GestureDetector(
    onTap: () {
      checkIcon = !checkIcon;
      checkIcon ? tema.sethemeData(temaDia()) : tema.sethemeData(temaNoche());
    },
    child: checkIcon
        ? Icon(Icons.dark_mode_rounded, size: 40)
        : Icon(Icons.light_mode_rounded, size: 40, color: Colors.white),
  );
}
