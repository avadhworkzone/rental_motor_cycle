import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';

class CustomBtn extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final double? radius;
  final double? height;
  final double? width;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;

  // ignore: use_key_in_widget_constructors
  const CustomBtn({
    required this.onTap,
    required this.title,
    this.radius,
    this.borderColor,
    this.height,
    this.width,
    this.fontSize,
    this.bgColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: width ?? Get.width,
      decoration: BoxDecoration(
        color: bgColor ?? theme.primaryColor,
        // border: Border.all(color: borderColor ?? theme.primaryColor),
        borderRadius: BorderRadius.circular(radius ?? 5.r),
        boxShadow: [
          BoxShadow(
            color: ColorUtils.buttonShadowColor,
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius ?? 5.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.w),
            child: Center(
              child: CustomText(
                title!,
                fontWeight: FontWeight.w600,
                color: textColor ?? ColorUtils.white,
                fontSize: fontSize ?? 17.sp,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
