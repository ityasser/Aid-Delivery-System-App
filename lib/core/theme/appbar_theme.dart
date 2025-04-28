import 'package:flutter/material.dart';

import 'color.dart';

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: ColorsUi.white,
    elevation: 3,
    shadowColor: ColorsUi.primary.withOpacity(.3),
    foregroundColor: ColorsUi.black,
    centerTitle: true,
    

  );
}