import 'package:flutter/material.dart';
const primaryClr = Color.fromRGBO(33, 149, 242, 1.0);

TextStyle get subHeadingStyle{
  return TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'Roboto',
    color: Colors.grey,
  );
}

TextStyle get headingStyle{
  return TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    fontFamily: 'Roboto',
  );
}

TextStyle get titleStyle{
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );
}

TextStyle get subTitleStyle{
  return TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: Colors.grey,
  );
}

TextStyle get mainPageTitleStyle{
  return TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.bold);
}

TextStyle get mainPageSubTitleStyle{
  return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500);
}