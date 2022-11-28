import 'package:flutter/material.dart';

import '../settings/style_settings.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData? _themeData;

  ThemeProvider({int? selectedTheme}) {
    _themeData = selectedTheme == 1 ? temaDia() : temaNoche();
  }

  getthemeData() => this._themeData;
  sethemeData(ThemeData theme) {
    this._themeData = theme;
    notifyListeners();
  }

  getNumber() => _themeData!.primaryColorDark;
}
