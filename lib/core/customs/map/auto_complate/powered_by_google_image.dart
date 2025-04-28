import 'package:flutter/material.dart';

class PoweredByGoogleImage extends StatelessWidget {
  final _poweredByGoogleWhite =
      'assets/images/google_white.png';
  final _poweredByGoogleBlack =
      'assets/images/google_black.png';

  PoweredByGoogleImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Padding(
          padding:  EdgeInsets.all(16.0),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? _poweredByGoogleWhite
                : _poweredByGoogleBlack,
            scale: 2.5,
          ))
    ]);
  }
}
