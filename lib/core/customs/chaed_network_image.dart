import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constant/imagepath.dart';
import '../theme/color.dart';

Widget CustomNetworkImage({
  required String image,
  double height = 20.0,
  double width = 20.0,
  bool useDefaultColor = true,
  BoxFit? fit,
  Color? color,
}) {
  if (image.startsWith("http://") ||
      image.startsWith("https://") ||
      image.isEmpty) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: fit,
      progressIndicatorBuilder:
          (context, url, progress) => Container(
            alignment: AlignmentDirectional.center,
            height: height / 1.5,
            width: width / 1.5,
            child: SvgPicture.asset(
              ImagePath.logo,
              fit: BoxFit.contain,
              color: color ?? (useDefaultColor ? ColorsUi.primary : null),
              height: height / 1.5,
              width: width / 1.5,
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            alignment: AlignmentDirectional.center,
            height: height / 1.5,
            width: width / 1.5,
            child: SvgPicture.asset(
              ImagePath.logo,
              fit: BoxFit.contain,
              height: height / 1.5,
              width: width / 1.5,
              color: color ?? (useDefaultColor ? ColorsUi.primary : null),
            ),
          ),
      height: height,
      width: width,
      color: color,
    );
  } else {
    return Image.file(
      File(image),
      fit: fit,
      width: width,
      height: height,
      color: color,
    );
  }
}
