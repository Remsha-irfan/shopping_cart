import 'package:flutter/material.dart';
import 'package:shopping_cart/core/constant/colors.dart';

class CustomTextStyles {
  static TextStyle Inter({
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Inter',
      color: color ?? AppColors.whiteColor,
      fontStyle: fontStyle,
      fontWeight: fontWeight ?? FontWeight.bold,
    );
  }
}
