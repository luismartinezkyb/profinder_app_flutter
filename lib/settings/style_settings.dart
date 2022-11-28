import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void sharedMethod(int numTema) async {
  final prefs = await SharedPreferences.getInstance();

  //LEE
  final int? counter = prefs.getInt('numTema');
  if (counter != null) {
    //ELIMINA

    final success = await prefs.remove('numTema');
  }
  //DECLARA
  await prefs.setInt('numTema', numTema);
}

const kPrimaryColor = Color(0xFF1F618D);
const kPrimaryLightColor = Color(0xFFD6EAF8);

ThemeData temaDia() {
  print('Se acaba de cambiar al Color Dia');
  sharedMethod(1);
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColorDark: kPrimaryColor,
    primaryColor: kPrimaryColor,
    primaryColorLight: kPrimaryLightColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
    inputDecorationTheme: InputDecorationTheme(iconColor: kPrimaryColor),
    primaryIconTheme: IconThemeData(color: kPrimaryColor),
    iconTheme: IconThemeData(color: kPrimaryColor),
  );
}

ThemeData temaNoche() {
  sharedMethod(2);
  print('Se acaba de cambiar al Color Noche');
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      primaryColorDark: Colors.white,
      scaffoldBackgroundColor: Colors.grey.shade900,
      backgroundColor: Colors.grey.shade900,
      dialogBackgroundColor: Colors.white,
      colorScheme: ColorScheme.dark(),
      inputDecorationTheme: InputDecorationTheme(iconColor: Colors.black),
      primaryIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black));
}
