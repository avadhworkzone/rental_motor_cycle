import 'package:flutter/material.dart';

class DatePickerUtils {
  static Future<DateTime?> pickDate({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    required BuildContext context,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
    );
  }

  static Future<TimeOfDay?> pickTime({required BuildContext context}) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }
}
