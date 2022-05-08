import 'package:flutter/material.dart';

class MyConstant {
//field
  static Color primary = const Color.fromARGB(255, 154, 38, 189);
  static Color dark = const Color.fromARGB(255, 12, 60, 31);
  static Color light = const Color.fromARGB(255, 54, 152, 227);
  static Color active = const Color.fromARGB(255, 255, 78, 228);

//method

BoxDecoration planBox(){
  return BoxDecoration(color: light.withOpacity(0.25));
}



  TextStyle h1Style() {
    return TextStyle(
      color: dark,
      fontSize: 36,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle h2Style() {
    return TextStyle(
      color: dark,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle h3Style() {
    return TextStyle(
      color: dark,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle h3ActiveStyle() {
    return TextStyle(
      color: active,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }
}
