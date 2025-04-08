import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';

typedef OnChanged = void Function(String? value);

class CommonDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final String labelText;
  final OnChanged? onChanged;
  final String? validationMessage;

  const CommonDropdown({
    super.key,
    required this.items,
    required this.labelText,
    this.selectedValue,
    this.onChanged,
    this.validationMessage,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 14.h,
          ),
          fillColor: isDarkTheme?ColorUtils.darkThemeBg:Colors.white,
          filled: true,
          labelText: labelText.tr,
          labelStyle: TextStyle(
            color: ColorUtils.grey99,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),

          // Default border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorUtils.grey99, width: 1.5),
          ),

          // Enabled border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorUtils.grey99, width: 1.5),
          ),

          // Focused border
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorUtils.primary, width: 2.0),
          ),

          // Error border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorUtils.red, width: 1.8),
          ),

          // Focused error border
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorUtils.red, width: 2.0),
          ),
        ),
        validator:
            (value) =>
                (value == null || value.isEmpty) ? validationMessage : null,
        onChanged: onChanged,
        items:
            items
                .map(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: CustomText(item, fontSize: 16.sp),
                  ),
                )
                .toList(),
      ),
    );
  }
}
