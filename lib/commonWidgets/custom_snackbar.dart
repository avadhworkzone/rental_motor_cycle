import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';

void showCustomSnackBar({required String message, bool isError = false}) {
  Get.showSnackbar(
    GetSnackBar(
      messageText: CustomText(
        message,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: isError ? Colors.red : ColorUtils.primary,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
    ),
  );
}
