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
  bool? isCenterTitle,
  double? fontSize,
  FontWeight? fontWeight,
  required String titleText,
  // bool isBackButton = true,
  bool isNotificationButton = true,
}) {
  return AppBar(
    centerTitle: isCenterTitle ?? true,
    backgroundColor: ColorUtils.white,

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
                child: Icon(Icons.arrow_back_outlined),
              ),
            )
            : SizedBox(),
    leadingWidth: (isLeading ?? false) ? 56.w : 0,
    title: CustomText(
      titleText,
      fontSize: fontSize ?? 17.sp,
      fontWeight: fontWeight ?? FontWeight.w500,
    ),
    /* Row(
      children: [
        // if (isBackButton)
        //   InkWell(
        //     onTap: backPress ?? () => Get.back(),
        //     child: Icon(
        //       Icons.arrow_back_outlined,
        //       size: 24.sp,
        //       // size: Get.width >= 500 ? 4.w : 6.w,
        //     ),
        //   ),
        CustomText(titleText, fontSize: 17.sp, fontWeight: FontWeight.w500),
      ],
    )*/
    actions: [],
  );
}
