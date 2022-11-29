import 'package:flutter/material.dart';

import '../../provider/theme_provider.dart';
import '../../settings/style_settings.dart';

ColorWidgetRow(ThemeProvider? tema) {
  bool checkIcon = tema!.getNumber() == Color(0xff1f618d);
  //print('el tema color es:${tema.getNumber()}');
  return GestureDetector(
    onTap: () {
      checkIcon = !checkIcon;
      checkIcon ? tema.sethemeData(temaDia()) : tema.sethemeData(temaNoche());
    },
    child: checkIcon
        ? Icon(Icons.dark_mode_rounded, size: 35)
        : Icon(Icons.light_mode_rounded, size: 35, color: Colors.white),
  );
}


// String StringImage1(ThemeProvider? tema) {
//   bool checkIcon = tema!.getNumber() == Color(0xff1f618d);
  
  
//   return checkIcon
//         ? 'assets/icons/flutter_icono_sinletras.png'
//         : 'assets/icons/flutter_icono_oscuro.png';
//   // image2 = selectedTheme == 1
//   //     ? 'assets/icons/flutter_icono_transparente.png'
//   //       : 'assets/icons/flutter_icono_oscuro_letras_letras.png';
  
//   return GestureDetector(
//     onTap: () {
//       checkIcon = !checkIcon;
//        ? tema.sethemeData(temaDia()) : tema.sethemeData(temaNoche());
//     },
//     child: checkIcon
//         ? Icon(Icons.dark_mode_rounded, size: 40)
//         : Icon(Icons.light_mode_rounded, size: 40, color: Colors.white),
//   );
// }
