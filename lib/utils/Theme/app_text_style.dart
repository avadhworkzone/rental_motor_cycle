import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/utils/iamge_utils.dart';
import '../color_utils.dart';

TextStyle fontStyleRegular = TextStyle(
  fontFamily: FontUtils.cerebriSans,
  decoration: TextDecoration.none,
);
TextStyle fontStyleSemiBold = TextStyle(
  fontFamily: FontUtils.cerebriSans,
  fontWeight: FontWeight.w600,
  decoration: TextDecoration.none,
);
TextStyle fontStyleBold = TextStyle(
  fontFamily: FontUtils.cerebriSans,
  fontWeight: FontWeight.w700,
  decoration: TextDecoration.none,
);
TextStyle fontStyleMedium = TextStyle(
  fontFamily: FontUtils.cerebriSans,
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.none,
);
TextStyle fontStyleHeavy = TextStyle(
  fontFamily: FontUtils.cerebriSans,
  fontWeight: FontWeight.w800,
  decoration: TextDecoration.none,
);

// class FontUtils {
//   static double s34 = 34.sp;
//   static double s22 = 22.sp;
//   static double s24 = 24.sp;
//   static double s17 = 17.sp;
//   static double s15 = 15.sp;
//   static double s13= 13.sp;
//   static double s12= 12.sp;
// }

Widget customBoldText({
  String? title,
  Color? color,
  TextAlign? textAlign,
  double? fontSize,
}) {
  return CustomText(
    title!.tr,
    color: color ?? (Get.isDarkMode ? ColorUtils.white : ColorUtils.black),
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    textAlign: textAlign,
  );
}

Widget customSemiBoldText({
  String? title,
  Color? color,
  TextAlign? textAlign,
  double? fontSize,
}) {
  return CustomText(
    title!.tr,
    color: color ?? (Get.isDarkMode ? ColorUtils.white : ColorUtils.black),
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    textAlign: textAlign,
  );
}

Widget customMediumText({
  String? title,
  Color? color,
  TextAlign? textAlign,
  double? fontSize,
}) {
  return CustomText(
    title!.tr,
    color: color ?? (Get.isDarkMode ? ColorUtils.white : ColorUtils.black),
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
    textAlign: textAlign,
  );
}

Widget customRegularText({
  String? title,
  Color? color,
  TextAlign? textAlign,
  double? fontSize,
}) {
  return CustomText(
    title!.tr,
    color: color ?? (Get.isDarkMode ? ColorUtils.white : ColorUtils.black),
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    textAlign: textAlign,
  );
}

Widget customHeavyText({
  String? title,
  Color? color,
  TextAlign? textAlign,
  double? fontSize,
}) {
  return CustomText(
    title!.tr,
    color: color ?? (Get.isDarkMode ? ColorUtils.white : ColorUtils.black),
    fontSize: fontSize,
    fontWeight: FontWeight.w800,
    textAlign: textAlign,
  );
}

class CustomText extends StatelessWidget {
  final String title;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? textAlign;
  final double? height;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final double? decorationThickness;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final bool isLocalization;
  final TextDirection? textDirection;
  final List<Shadow>? customShadow;

  const CustomText(
    this.title, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontFamily,
    this.fontSize,
    this.textAlign,
    this.height,
    this.fontStyle,
    this.maxLines,
    this.overflow,
    this.textDirection,
    this.decoration = TextDecoration.none,
    this.letterSpacing,
    this.decorationColor,
    this.decorationStyle,
    this.customShadow,
    this.decorationThickness,
    this.isLocalization = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      isLocalization ? title.tr : title,
      textDirection: textDirection,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color:
            color ?? (Get.isDarkMode ? ColorUtils.white : ColorUtils.black21),
        fontFamily: fontFamily ?? FontUtils.cerebriSans,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontSize: fontSize ?? 14.sp,
        height: height,
        fontStyle: fontStyle,
        overflow: overflow,
        decoration: decoration,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        shadows: customShadow,
      ),
    );
  }
}
