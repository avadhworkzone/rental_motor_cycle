import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'color_utils.dart';

class DecorationUtils {
  static PinTheme pinTheme() {
    return PinTheme(
      width: 15.w,
      height: 15.w,
      textStyle: TextStyle(fontSize: 22.sp, color: ColorUtils.black),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(width: 1.5, color: ColorUtils.black),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            offset: const Offset(0, 8), // hide shadow top
            blurRadius: 5,
          ),
          const BoxShadow(
            color: Colors.white, // replace with color of container
            offset: Offset(-8, 0), // hide shadow right
          ),
          const BoxShadow(
            color: Colors.white, // replace with color of container
            offset: Offset(8, 0), // hide shadow left
          ),
        ],
      ),
    );
  }
}
