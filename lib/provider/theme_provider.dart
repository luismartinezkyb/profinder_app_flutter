import 'package:flutter/material.dart';

import '../settings/style_settings.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData? _themeData;
  String? _image1;
  String? _image2;
  String? _image3;
  // Image? _image1;
  // Image? _image2;

  ThemeProvider({int? selectedTheme}) {
    _themeData = selectedTheme == 1 ? temaDia() : temaNoche();
    _image1 = selectedTheme == 1
        ? 'assets/icons/flutter_icono_sinletras.png'
        : 'assets/icons/flutter_icono_oscuro_letras.png';
    _image2 = selectedTheme == 1
        ? 'assets/icons/flutter_icono_transparente.png'
        : 'assets/icons/flutter_icono_letras_letras.png';
    _image3 = selectedTheme == 1
        ? 'assets/icons/flutter_icono.png'
        : 'assets/icons/flutter_icono_oscuro.png';
    // _image1 = selectedTheme == 1
    //     ? Image.asset('assets/icons/flutter_icono_sinletras.png')
    //     : Image.asset('assets/icons/flutter_icono_oscuro.png');
    // _image2 = selectedTheme == 1
    //     ? Image.asset('assets/icons/flutter_icono_transparente.png')
    //     : Image.asset('assets/icons/flutter_icono_oscuro_letras_letras.png');
  }

  getthemeData() => this._themeData;
  getImage1Theme() => this._image1;
  getImage2Theme() => this._image2;
  getImage3Theme() => this._image3;
  sethemeData(ThemeData theme) {
    this._themeData = theme;

    if (_themeData!.primaryColorDark == Color(0xff1f618d)) {
      print('El tema es de dia');
      this._image1 = 'assets/icons/flutter_icono_sinletras.png';
      this._image2 = 'assets/icons/flutter_icono_transparente.png';
      this._image3 = 'assets/icons/flutter_icono.png';
    } else {
      this._image1 = 'assets/icons/flutter_icono_oscuro_letras.png';
      this._image2 = 'assets/icons/flutter_icono_letras_letras.png';
      this._image3 = 'assets/icons/flutter_icono_oscuro.png';
      print('el tema es de noche');
    }

    notifyListeners();
  }

  getNumber() => _themeData!.primaryColorDark;
}
