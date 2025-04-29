import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';

typedef ClickOnTap = Function();

AppBar commonAppBar({
  required BuildContext context,
  VoidCallback? backPress,
  bool? isLeading,
  Color? backgroundColor,
  bool? isCenterTitle,
  double? fontSize,
  Color? fontColor,
  Color? iconColor,
  FontWeight? fontWeight,
  required String titleText,
  // bool isBackButton = true,
  bool isNotificationButton = true,
}) {
  bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

  return AppBar(
    centerTitle: isCenterTitle ?? true,

    backgroundColor: backgroundColor,
    // toolbarHeight: 7.5.h,
    // leading: SizedBox(),
    leading:
        (isLeading ?? false)
            ? Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_outlined,
                  color:
                      iconColor ??
                      (isDarkTheme ? ColorUtils.white : ColorUtils.black),
                ),
              ),
            )
            : SizedBox(),
    leadingWidth: (isLeading ?? false) ? 56.w : 0,
    title: CustomText(
      titleText,
      // color: fontColor ?? ColorUtils.black21,
      fontSize: fontSize ?? 17.sp,
      color: fontColor ?? (isDarkTheme ? ColorUtils.white : ColorUtils.black21),
    ),
  );
}
