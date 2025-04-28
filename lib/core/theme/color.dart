import 'dart:ui';

import 'package:flutter/material.dart';

import '../app.dart';

class ColorsUi {
  static const LinearGradient gradientLogo = LinearGradient(
      colors: [Color(0xff3C69E3), Color(0xff8E79DD)],
      tileMode: TileMode.decal,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);

  static const List<Color> ar=[Color(0xff3C69E3), Color(0xff8E79DD)];
  static const List<Color> en=[Color(0xff8E79DD), Color(0xff3C69E3)];
  static  LinearGradient gradientRow =LinearGradient(
      colors:App.isRTL()? ar:en,
      tileMode: TileMode.repeated,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static LinearGradient gradientCardSpecial = LinearGradient(
      colors: [Colors.black.withOpacity(.7), Colors.transparent],
      tileMode: TileMode.repeated,
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter);

  static const white = Color(0xffFFFFFF);
  static const bac_button = Color(0xffEA7B2A);
  static const fount_button = Color(0xffFFFFFF);
  static const black = Colors.black;
  static const primary = Color(0xffEA7B2A);
  static const secondary = Color(0xffe68036);
  static const inputBorder = Color(0xffECEFFB);
  static const greyF7 = Color(0xffF7F7F7);
  static const greyF9 = Color(0xffF9F9FC);
  static const greybold = Color(0xffcacace);
  static const greyDark = Color(0xffb0adad);
  static const greyIcon = Color(0xffBDBDCC);
  static const red = Color(0xffE33C7B);
  static const gold = Color(0xffFFCD03);
  static const blackLight = Color(0xff737373);
  static const green = Color(0xff39C089);
  static const filter = Color(0xff3C69E3);
  static const blackItem = Color(0xff3B3F47);
  static const grey = Color(0xff898989);
  static const inActiveStep = Color(0xffC8D5F7);
  static const bacCircleIcon = Color(0xffF1F4FD);
  static const upgradePackage = Color(0xff0BBFD0);
  static const grayBlue = Color(0xff959FB9);

}