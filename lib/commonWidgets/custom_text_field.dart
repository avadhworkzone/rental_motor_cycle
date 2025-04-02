import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/iamge_utils.dart';

typedef OnChangeString = void Function(String value);
typedef Validator = String? Function(String? value);
typedef OnTap = void Function();

class CommonTextField extends StatelessWidget {
  final TextEditingController? textEditController;
  final String? initialValue;
  final bool? isValidate;
  final bool? readOnly;
  final TextInputType? keyBoardType;
  final Validator? validator;
  final String? regularExpression;
  final int? inputLength;
  final String? hintText;
  final String? labelText;
  final String? validationMessage;
  final String? preFixIconPath;
  final int? maxLine;
  final Widget? sIcon;
  final Widget? pIcon;
  final Widget? suffix;
  final bool? obscureValue;
  final bool? underLineBorder;
  final bool? showLabel;
  final bool? isDropdown;
  final bool hasError;
  final int? maxLength;
  final String? errorMessage;
  final OnChangeString? onChange;
  final OnTap? onTap;
  final Color? borderColor;
  final Widget? counter;
  final FocusNode? focusNode;
  final bool? contentPadding;
  final bool textCapitalization;
  final bool autoFocus;

  const CommonTextField({
    super.key,
    this.regularExpression = '',
    this.textEditController,
    this.isValidate = true,
    this.keyBoardType,
    this.inputLength,
    this.readOnly = false,
    this.underLineBorder = false,
    this.showLabel = false,
    this.isDropdown = false,
    this.hintText,
    this.validationMessage,
    this.maxLine,
    this.sIcon,
    this.pIcon,
    this.preFixIconPath,
    this.onChange,
    this.initialValue = '',
    this.obscureValue,
    this.labelText,
    this.hasError = false,
    this.errorMessage,
    this.onTap,
    this.borderColor,
    this.contentPadding = false,
    this.textCapitalization = false,
    this.validator,
    this.suffix,
    this.maxLength,
    this.autoFocus = false,
    this.focusNode,
    this.counter,
  });

  /// PLEASE IMPORT GET X PACKAGE
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        focusNode: focusNode ?? null,
        textCapitalization:
            textCapitalization
                ? TextCapitalization.characters
                : TextCapitalization.none,
        controller: textEditController,
        autofocus: autoFocus,
        obscureText: obscureValue ?? false,
        style: TextStyle(
          color: ColorUtils.black21,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: FontUtils.cerebriSans,
        ),
        keyboardType: keyBoardType ?? TextInputType.text,
        maxLines: maxLine ?? 1,
        maxLength: maxLength,
        inputFormatters:
            regularExpression!.isEmpty || regularExpression == ""
                ? [
                  LengthLimitingTextInputFormatter(inputLength),
                  NoLeadingSpaceFormatter(),
                ]
                : [
                  LengthLimitingTextInputFormatter(inputLength),
                  FilteringTextInputFormatter.allow(RegExp(regularExpression!)),
                  NoLeadingSpaceFormatter(),
                ],
        onTap: onTap,
        onChanged: onChange,
        // enabled: !readOnly!,
        readOnly: readOnly!,
        validator: validator,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: ColorUtils.black21,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 14.h,
          ), // Enhanced padding
          fillColor: Colors.white, // Light background
          filled: true, // Enables background fill
          labelText:
              (labelText?.isNotEmpty ?? false) ? labelText.toString().tr : "",
          labelStyle: TextStyle(
            color: ColorUtils.grey99,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: FontUtils.cerebriSans,
          ),

          // 🌟 Default Border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r), // Soft rounded corners
            borderSide: BorderSide(color: ColorUtils.grey99, width: 1.5),
          ),

          // 🎨 When the text field is enabled (default state)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorUtils.grey99, width: 1.5),
          ),

          // 🔥 When the text field is focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorUtils.primary, width: 2.0),
          ),

          // ❌ When there is an error
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorUtils.red, width: 1.8),
          ),

          // ❗ When focused but also has an error
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorUtils.red, width: 2.0),
          ),

          // // 🏆 Adds a subtle shadow for a modern look
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12.r),
          //   borderSide: BorderSide(color: ColorUtils.grey99, width: 1.5),
          // ),

          // 🚀 Shadow effect
          errorStyle: TextStyle(
            color: ColorUtils.red,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: FontUtils.cerebriSans,
          ),

          errorText: hasError ? errorMessage : null,
          suffixIcon: sIcon,
          prefixIcon: pIcon,
          suffix: suffix,
        ),

        /*     decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          fillColor: Colors.transparent,
          counter: counter,
          filled: true,
          labelText:
              (labelText?.isNotEmpty ?? false) ? labelText.toString().tr : "",
          labelStyle: TextStyle(
            color: ColorUtils.grey99,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: FontUtils.cerebriSans,
          ),
          errorStyle: TextStyle(
            color: ColorUtils.red,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: FontUtils.cerebriSans,
          ),
          errorText: hasError ? errorMessage : null,
          suffixIcon: sIcon,
          prefixIcon: pIcon,
          suffix: suffix,
          // hintText: showLabel! ? '' : hintText.toString().tr,
          // hintStyle: TextStyle(
          //     color: ColorUtils.grey,
          //     fontSize: 17.sp,
          //     fontFamily: FontUtils.cerebriSans),
        ),*/
      ),
    );
  }
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}
