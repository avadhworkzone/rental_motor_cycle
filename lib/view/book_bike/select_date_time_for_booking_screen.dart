import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/controller/bike_booking_controller.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';

// ✅ Helper Function for Date Comparison
extension DateCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

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
  TextEditingController discountController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController prePaymentController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final fullNameController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController extraPerKmController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final bike = Get.arguments;
  final Rxn<DateTime> fromDate = Rxn<DateTime>();
  final Rxn<DateTime> toDate = Rxn<DateTime>();
  final isValid = false.obs;
  List<BikeModel> selectedBikesList = [];
  final RxDouble subtotal = 0.0.obs;
  final RxDouble taxAmount = 0.0.obs;
  final RxDouble grandTotal = 0.0.obs;
  final RxDouble balance = 0.0.obs;
  final RxDouble discount = 0.0.obs;

  @override
  void initState() {
    super.initState();
    locationController.text = bike.location;
  }

  Future<void> pickDateTime(bool isFrom) async {
    DateTime now = DateTime.now();

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
              onPrimary: ColorUtils.white,
              onSurface: ColorUtils.black,
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
      List<TimeOfDay> allTimes = List.generate(
        24,
        (index) => TimeOfDay(hour: index, minute: 0),
      );
      int minHour;

      if (isFrom) {
        minHour = (DateCompare(pickedDate).isSameDate(now)) ? now.hour + 1 : 0;
      } else {
        final from = fromDate.value;
        minHour =
            (DateCompare(pickedDate).isSameDate(from ?? now))
                ? ((from ?? now).hour + 1)
                : 0;
      }

      final currentDate = isFrom ? fromDate.value : toDate.value;
      final selectedHour =
          (currentDate != null &&
                  DateCompare(pickedDate).isSameDate(currentDate))
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
        print(
          '---Final Picked DateTime (${isFrom ? 'From' : 'To'})--- $finalDateTime',
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

  void checkFormValidity() {
    isValid.value =
        fromDate.value != null &&
        toDate.value != null &&
        fullNameController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        extraPerKmController.text.trim().isNotEmpty &&
        depositController.text.trim().isNotEmpty &&
        mileageController.text.trim().isNotEmpty &&
        rentController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty;
  }

  int getDaysDifference(DateTime from, DateTime to) {
    return to.difference(from).inDays +
        1; // Add 1 to include both start and end date
  }

  void calculateSummary() {
    final fromDate = DateTime.tryParse(fromDateController.text);
    final toDate = DateTime.tryParse(toDateController.text);
    logs("---fromDate---$fromDate");
    logs("---toDate---$toDate");

    if (fromDate == null || toDate == null) return;

    int numberOfDays = toDate.difference(fromDate).inDays + 1;
    double rent = double.tryParse(rentController.text) ?? 0;
    double discountVal = double.tryParse(discountController.text) ?? 0;
    double taxPercent = double.tryParse(taxController.text) ?? 0;
    double prepayment = double.tryParse(prePaymentController.text) ?? 0;

    subtotal.value = rent * numberOfDays;
    discount.value = discountVal;
    taxAmount.value = subtotal.value * (taxPercent / 100);
    grandTotal.value = subtotal.value + taxAmount.value - discount.value;
    balance.value = grandTotal.value - prepayment;
    logs("--rent-----$rent");
    logs("--discountVal-----$discountVal");
    logs("--taxPercent-----$taxPercent");
    logs("--prepayment-----$prepayment");
    logs("--subtotal-----$subtotal");
    logs("--discount-----$discount");
    logs("--taxAmount-----$taxAmount");
    logs("--grandTotal-----$grandTotal");
    logs("--balance-----$balance");
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Obx(() {
            return Column(
              children: [
                ///location
                // CommonTextField(
                //   textEditController: locationController,
                //   labelText: StringUtils.location,
                //   readOnly: true,
                //   suffix: Icon(Icons.location_on, color: ColorUtils.primary),
                // ),
                // SizedBox(height: 5.h),

                /// From Date
                GestureDetector(
                  onTap: () => pickDateTime(true),
                  child: AbsorbPointer(
                    child: CommonTextField(
                      textEditController: fromDateController,
                      labelText: StringUtils.fromDate,
                    ),
                  ),
                ),
                // SizedBox(height: 16.h),

                /// To Date
                GestureDetector(
                  onTap: () => pickDateTime(false),
                  child: AbsorbPointer(
                    child: CommonTextField(
                      textEditController: toDateController,
                      labelText: StringUtils.toDate,
                    ),
                  ),
                ),

                /// FullName
                _buildTextField(
                  fullNameController,
                  StringUtils.fullName,
                  onChange: (_) => checkFormValidity(),
                ),

                /// Phone
                _buildTextField(
                  phoneController,
                  StringUtils.phone,
                  onChange: (_) => checkFormValidity(),
                ),

                /// Email
                _buildTextField(
                  emailController,
                  StringUtils.email,
                  onChange: (_) => checkFormValidity(),
                ),

                /// Mileage
                CommonTextField(
                  textEditController: mileageController,
                  labelText: StringUtils.mileage,
                  keyBoardType: TextInputType.number,
                  validator:
                      (value) =>
                          value!.isEmpty ? StringUtils.enterMileage : null,
                  onChange: (_) => checkFormValidity(),
                ),

                ///rentPerDay
                CommonTextField(
                  textEditController: rentController,
                  labelText: StringUtils.rentPerDay,
                  keyBoardType: TextInputType.number,
                  validator:
                      (value) =>
                          value!.isEmpty ? StringUtils.enterRentPrice : null,
                  onChange: (_) => checkFormValidity(),
                ),

                ///extraPerKm
                CommonTextField(
                  textEditController: extraPerKmController,
                  labelText: StringUtils.extraPerKm,
                  keyBoardType: TextInputType.number,
                  onChange: (_) => checkFormValidity(),
                  validator:
                      (value) =>
                          value!.isEmpty ? StringUtils.enterExtraKmRate : null,
                ),

                ///deposit
                CommonTextField(
                  textEditController: depositController,
                  labelText: "${StringUtils.securityDeposit}: (\$)",
                  keyBoardType: TextInputType.number,
                  onChange: (_) => checkFormValidity(),
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? StringUtils.enterDepositAmount
                              : null,
                ),

                /// Discount
                CommonTextField(
                  labelText: "${StringUtils.discount} (\$)",
                  textEditController: discountController,
                  keyBoardType: TextInputType.number,
                  onChange: (_) => checkFormValidity(),
                ),

                /// Tax
                CommonTextField(
                  labelText: "${StringUtils.tax} (%)",
                  textEditController: taxController,
                  keyBoardType: TextInputType.number,
                  onChange: (_) => checkFormValidity(),
                ),

                /// Pre payment
                CommonTextField(
                  labelText: StringUtils.prepayment,
                  textEditController: prePaymentController,
                  keyBoardType: TextInputType.number,
                  onChange: (_) => checkFormValidity(),
                ),

                /// Duration + Payment Info UI Section
                // final from = fromDate.value;
                // final to = toDate.value;
                //
                // if (from == null || to == null) return SizedBox.shrink();
                // if (!isValid.value) return SizedBox.shrink();
                //
                // final duration = to.difference(from);
                // final durationInDays = duration.inHours / 24;
                // // final rentPerDay = bike.rentPerDay ?? 0.0;
                // // final deposit = bike.deposit ?? 0.0;
                // final totalRent = durationInDays /* * rentPerDay*/;
                //
                // double discount =
                //     double.tryParse(discountController.text) ?? 0.0;

                // // 🚫 Prevent discount greater than total rent
                // if (discount > totalRent) {
                //   discount = totalRent;
                //   discountController.text = totalRent.toStringAsFixed(0);
                //
                //   // Show warning
                //   WidgetsBinding.instance.addPostFrameCallback((_) {
                //     showCustomSnackBar(
                //       message: StringUtils.discountCantMoreThanTotal,
                //     );
                //   });
                // }

                // final payable = (totalRent - discount).clamp(
                //   0,
                //   double.infinity,
                // );

                // final durationText =
                //     duration.inHours == 24
                //         ? StringUtils.oneDay
                //         : "${duration.inHours} ${StringUtils.hours}${durationInDays >= 1 ? " (${durationInDays.toStringAsFixed(1)} ${StringUtils.days})" : ""}";
                Container(
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.only(top: 24.h),
                  decoration: BoxDecoration(
                    color: ColorUtils.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        _buildInfoRow("${StringUtils.typeOfPayment}:", "CASH"),
                        _buildInfoRow(
                          "${StringUtils.subtotal}:",
                          "\$${subtotal.value.toStringAsFixed(2)}",
                        ),
                        _buildInfoRow(
                          "${StringUtils.tax}:",
                          "\$${taxAmount.value.toStringAsFixed(2)}",
                        ),
                        _buildInfoRow(
                          StringUtils.grandTotal,
                          "\$${grandTotal.value.toStringAsFixed(2)}",
                        ),
                        _buildInfoRow(
                          StringUtils.balance,
                          "\$${balance.value.toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                /// Confirm Booking btn
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: CustomBtn(
                    onTap:
                        isValid.value
                            ? () {
                              logs("---calculateSummary----");
                              calculateSummary();
                            } /*showBookingConfirmationDialog*/
                            : null,
                    title: StringUtils.confirmBooking,
                    bgColor:
                        isValid.value
                            ? ColorUtils.primary
                            : ColorUtils.primary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void showBookingConfirmationDialog() {
    if (fromDate.value == null || toDate.value == null) {
      showCustomSnackBar(message: StringUtils.pleaseSelectBothTheDates);
      return;
    }

    final bikeName = bike.brandName ?? "N/A";
    final bikeModel = bike.model ?? "N/A";
    final location = locationController.text;
    // final depositAmount = bike.deposit ?? 0.0;

    final from = fromDate.value!;
    final to = toDate.value!;
    final duration = to.difference(from);
    final durationInDays = duration.inHours / 24;
    // final rentPerDay = bike.rentPerDay ?? 0.0;
    final totalRent = durationInDays /* * rentPerDay*/;
    double discount = double.tryParse(discountController.text) ?? 0.0;
    final payableAmount =
        (totalRent - discount /* + depositAmount*/ ).clamp(0, double.infinity)
            as double;

    String formatAmount(double amount) {
      return amount % 1 == 0
          ? amount.toInt().toString()
          : amount.toStringAsFixed(2);
    }

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
              _buildInfoRow("${StringUtils.bike}:", "$bikeName ($bikeModel)"),
              _buildInfoRow("${StringUtils.location}:", location),
              _buildInfoRow(
                "${StringUtils.from}:",
                DateFormat('MMMM d, yyyy hh:mm a').format(from),
              ),
              _buildInfoRow(
                "${StringUtils.to}:",
                DateFormat('MMMM d, yyyy hh:mm a').format(to),
              ),
              _buildInfoRow(
                "${StringUtils.duration}:",
                "${duration.inHours} ${StringUtils.hours} (${durationInDays.toStringAsFixed(1)} ${StringUtils.days})",
              ),

              _buildInfoRow(
                "${StringUtils.totalRent}:",
                "\$ ${formatAmount(totalRent)}",
              ),
              // _buildInfoRow(
              //   "${StringUtils.depositAmount}:",
              //   "\$ ${formatAmount(depositAmount)}",
              // ),
              _buildInfoRow(
                "${StringUtils.totalAmount}: ",
                "\$ ${formatAmount(payableAmount)}",
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomBtn(
                    bgColor: ColorUtils.white,
                    onTap: () => Navigator.pop(context),
                    title: StringUtils.cancel,
                    textColor: ColorUtils.black,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: CustomBtn(
                    onTap: () async {
                      final from = fromDate.value!;
                      final to = toDate.value!;
                      final pickupDate = DateTime(
                        from.year,
                        from.month,
                        from.day,
                      );
                      final dropOffDate = DateTime(to.year, to.month, to.day);
                      final pickupTime = DateFormat('hh:mm a').format(from);
                      final dropOffTime = DateFormat('hh:mm a').format(to);

                      final newBooking = BookingModel(
                        userId: 1,
                        bikeId: bike.id!,
                        bikeName: bike.brandName,
                        bikeModel: bike.model,
                        discount: discount,
                        prepayment: 0,
                        // prepayment: depositAmount,
                        userFullName: fullNameController.text,
                        userPhone: phoneController.text,
                        userEmail: emailController.text,
                        pickupDate: pickupDate,
                        dropoffDate: dropOffDate,
                        pickupTime: pickupTime,
                        dropoffTime: dropOffTime,

                        createdAt: DateTime.now(),
                        durationInHours: duration.inHours.toDouble(),
                        totalRent: totalRent,
                        finalAmountPayable: payableAmount,
                        bikes: [bike],
                        tax: double.parse(taxController.text.trim()),
                        extraPerKm: double.parse(
                          extraPerKmController.text.trim(),
                        ),
                        balance: 0,
                        securityDeposit: double.parse(
                          depositController.text.trim(),
                        ),
                        subtotal: 0,
                        mileage: num.parse(mileageController.text.trim()),
                        rentPerDay: double.parse(rentController.text.trim()),
                        typeOfPayment: 'CASH',
                      );

                      await Get.find<BikeBookingController>().addBooking(
                        newBooking,
                      );

                      await Get.find<BikeBookingController>().fetchBookings();
                      Get.back();
                      Get.back();
                      showCustomSnackBar(
                        message: StringUtils.bikeBookedSuccessfully,
                      );
                    },
                    title: StringUtils.confirm,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(
    String title,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: CustomText(title, fontWeight: FontWeight.w600)),
          Expanded(
            child: CustomText(
              value,
              color: valueColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    void Function(String)? onChange,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: CommonTextField(
        textEditController: controller,
        labelText: label,
        keyBoardType: keyboardType,
        onChange: onChange,
        validator:
            (value) => value!.isEmpty ? '${StringUtils.enter} $label' : null,
      ),
    );
  }
}
