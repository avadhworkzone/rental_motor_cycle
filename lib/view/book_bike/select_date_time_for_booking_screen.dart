import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/book_bike/book_bike_screen.dart';

class SelectDateTimeForBookingScreen extends StatefulWidget {
  const SelectDateTimeForBookingScreen({super.key});

  @override
  State<SelectDateTimeForBookingScreen> createState() =>
      _SelectDateTimeForBookingScreenState();
}

class _SelectDateTimeForBookingScreenState
    extends State<SelectDateTimeForBookingScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final bike = Get.arguments;
  final fromDate = Rxn<DateTime>();
  final toDate = Rxn<DateTime>();

  @override
  void initState() {
    super.initState();
    locationController.text = bike.location;
  }

  Future<void> pickDateTime(bool isFrom) async {
    DateTime now = DateTime.now();

    // 🗓 Date Picker
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
          isFrom
              ? fromDate.value ?? now
              : toDate.value ?? (fromDate.value ?? now).add(Duration(days: 1)),
      firstDate: isFrom ? now : (fromDate.value ?? now),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorUtils.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: ColorUtils.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // 🕒 Generate Hourly Time Slots
      List<TimeOfDay> allTimes = List.generate(
        24,
        (index) => TimeOfDay(hour: index, minute: 0),
      );
      int minHour;

      if (isFrom) {
        minHour = (pickedDate.isSameDate(now)) ? now.hour + 1 : 0;
      } else {
        final from = fromDate.value;
        minHour =
            (pickedDate.isSameDate(from ?? now)) ? ((from ?? now).hour + 1) : 0;
      }

      final currentDate = isFrom ? fromDate.value : toDate.value;
      final selectedHour =
          (currentDate != null && pickedDate.isSameDate(currentDate))
              ? currentDate.hour
              : null;

      // 🕒 Time Picker Dialog with Styled Slots
      final pickedTime = await showDialog<TimeOfDay>(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: CustomText(StringUtils.selectTime),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: allTimes.length,
                itemBuilder: (context, index) {
                  TimeOfDay time = allTimes[index];
                  bool isDisabled = time.hour < minHour;
                  bool isSelected = selectedHour == time.hour;

                  return IgnorePointer(
                    ignoring: isDisabled,
                    child: ListTile(
                      title: CustomText(
                        time.format(context),

                        color:
                            isSelected
                                ? ColorUtils.primary
                                : isDisabled
                                ? Colors.grey
                                : Colors.black,
                        fontWeight:
                            isSelected
                                ? FontWeight.w700
                                : isDisabled
                                ? FontWeight.normal
                                : FontWeight.w500,
                        fontSize: isSelected ? 18 : 16,
                      ),
                      onTap:
                          isDisabled
                              ? null
                              : () => Navigator.pop(context, time),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );

      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (isFrom) {
          fromDate.value = finalDateTime;
          fromDateController.text = DateFormat(
            'MMMM d, yyyy hh:mm a',
          ).format(finalDateTime);

          if (toDate.value != null &&
              toDate.value!.isBefore(fromDate.value!.add(Duration(hours: 1)))) {
            toDate.value = fromDate.value!.add(Duration(hours: 1));
            toDateController.text = DateFormat(
              'MMMM d, yyyy hh:mm a',
            ).format(toDate.value!);
          }
        } else {
          if (fromDate.value != null &&
              finalDateTime.isBefore(fromDate.value!.add(Duration(hours: 1)))) {
            showCustomSnackBar(message: StringUtils.dropOffMustBeOneHour);

            return;
          }

          toDate.value = finalDateTime;
          toDateController.text = DateFormat(
            'MMMM d, yyyy hh:mm a',
          ).format(finalDateTime);
        }

        // calculateTotal();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.selectDates,
        context: context,
        isLeading: true,
        isCenterTitle: true,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            CommonTextField(
              textEditController: locationController,
              labelText: StringUtils.location,
              readOnly: true,
              suffix: Icon(Icons.location_on, color: Colors.green),
            ),
            SizedBox(height: 16),

            // From Date
            GestureDetector(
              onTap: () => pickDateTime(true),
              child: AbsorbPointer(
                child: CommonTextField(
                  textEditController: fromDateController,
                  labelText: StringUtils.fromDate,
                ),
              ),
            ),
            SizedBox(height: 16),

            // To Date
            GestureDetector(
              onTap: () => pickDateTime(false),
              child: AbsorbPointer(
                child: CommonTextField(
                  textEditController: toDateController,
                  labelText: StringUtils.toDate,
                ),
              ),
            ),
            SizedBox(height: 80.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: CustomBtn(
                onTap: showBookingConfirmationDialog,
                title: StringUtils.confirmBooking,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showBookingConfirmationDialog() {
    if (fromDate.value == null || toDate.value == null) {
      showCustomSnackBar(message: StringUtils.pleaseSelectBothTheDates);
      return;
    }

    final bikeName = bike.name ?? "N/A";
    final bikeModel = bike.model ?? "N/A";
    final location = locationController.text;
    final rentPerDay = bike.rentPerDay?.toString() ?? "N/A";

    final from = fromDate.value!;
    final to = toDate.value!;
    final duration = to.difference(from);
    final durationInDays = duration.inHours / 24;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CustomText(
            StringUtils.confirmBooking,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow("Bike:", "$bikeName ($bikeModel)"),
              _buildInfoRow("Location:", location),
              _buildInfoRow(
                "From:",
                DateFormat('MMMM d, yyyy hh:mm a').format(from),
              ),
              _buildInfoRow(
                "To:",
                DateFormat('MMMM d, yyyy hh:mm a').format(to),
              ),
              _buildInfoRow(
                "Duration:",
                "${duration.inHours} hours (${durationInDays.toStringAsFixed(1)} days)",
              ),
              _buildInfoRow("Rent per day:", "₹ $rentPerDay"),
              SizedBox(height: 16.h),
              CustomText(
                "Are you sure you want to book this bike?",
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: CustomText(StringUtils.cancel, color: Colors.red),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtils.primary,
              ),
              onPressed: () {
                Navigator.pop(context);
                showCustomSnackBar(
                  message: "Booking confirmed!",
                  isError: false,
                );
              },
              child: CustomText(StringUtils.confirm, color: Colors.white),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: CustomText(title, fontWeight: FontWeight.w600)),
          Expanded(child: CustomText(value)),
        ],
      ),
    );
  }
}
