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
  late final BikeModel bike;
  BookingModel? booking;
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
  // final bike = Get.arguments;
  final Rxn<DateTime> fromDate = Rxn<DateTime>();
  final Rxn<DateTime> toDate = Rxn<DateTime>();
  final isValid = false.obs;
  List<BikeModel> selectedBikesList = [];
  final RxDouble subtotal = 0.0.obs;
  final RxDouble taxAmount = 0.0.obs;
  final RxDouble grandTotal = 0.0.obs;
  final RxDouble balance = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble depositAmount = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble prepayment = 0.0.obs;
  // bool isEditing = false;
  // int? existingBookingId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    bike = args['bike'];
    booking = args['booking'];
    printBikeDetails();
    initMethod();

    // If this screen is used to update an existing booking
    if (booking != null) {
      // isEditing = true;
      // existingBookingId = booking?.id ?? 0;
      // final BookingModel booking = booking;
      fullNameController.text = booking?.userFullName ?? '';
      phoneController.text = booking?.userPhone ?? '';
      emailController.text = booking?.userEmail ?? '';
      mileageController.text = formatNum(booking?.mileage);

      rentController.text =
          booking?.rentPerDay != null
              ? formatDoubleOrInt(booking?.rentPerDay)
              : '';
      extraPerKmController.text =
          booking?.extraPerKm != null
              ? formatDoubleOrInt(booking?.extraPerKm)
              : '';
      depositController.text =
          booking?.securityDeposit != null
              ? formatDoubleOrInt(booking?.securityDeposit)
              : '';
      discountController.text =
          booking?.discount != null ? formatDoubleOrInt(booking?.discount) : '';
      taxController.text =
          booking?.tax != null ? formatDoubleOrInt(booking?.tax) : '';
      prePaymentController.text =
          booking?.prepayment != null
              ? formatDoubleOrInt(booking?.prepayment)
              : '';

      fromDate.value = booking?.pickupDate;
      toDate.value = booking?.dropoffDate;

      final pickup = booking?.pickupDate;
      if (pickup != null) {
        fromDateController.text = DateFormat(
          'MMMM d, yyyy hh:mm a',
        ).format(pickup);
      }

      final dropOff = booking?.dropoffDate;
      if (dropOff != null) {
        toDateController.text = DateFormat(
          'MMMM d, yyyy hh:mm a',
        ).format(dropOff);
      }
    }
    calculateSummary();
  }

  String formatDoubleOrInt(double? value) {
    if (value == null) return '';
    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2); // Or .toString() if you want raw decimal
    }
  }

  String formatNum(num? value) {
    if (value == null) return '';
    if (value is int || value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }

  void printBikeDetails() {
    print("🚲 Bike Details from Get.arguments:");
    print("Bike id: ${bike.id}");
    print("Brand Name: ${bike.brandName}");
    print("Model: ${bike.model}");
    print("Location: ${bike.location}");
    print("Transmission: ${bike.transmission}");
  }

  initMethod() async {
    await Get.find<BikeBookingController>().fetchBookings();
  }

  Future<void> pickDateTime(bool isFrom) async {
    DateTime now = DateTime.now();
    final initial =
        isFrom
            ? fromDate.value ?? now
            : toDate.value ?? (fromDate.value ?? now).add(Duration(days: 1));
    final first = isFrom ? now : (fromDate.value ?? now);

    // 👇 Ensure initialDate is not before firstDate
    final validInitial = initial.isBefore(first) ? first : initial;
    final pickedDate = await showDatePicker(
      context: context,
      // initialDate:
      //     isFrom
      //         ? fromDate.value ?? now
      //         : toDate.value ?? (fromDate.value ?? now).add(Duration(days: 1)),
      // firstDate: isFrom ? now : (fromDate.value ?? now),
      initialDate: validInitial,
      firstDate: first,
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

        checkFormValidity();
        calculateSummary();
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
    DateTime? fromDate, toDate;

    try {
      final format = DateFormat('MMMM d, yyyy hh:mm a');
      fromDate = format.parse(fromDateController.text);
      toDate = format.parse(toDateController.text);
    } catch (e) {
      logs("❌ Error parsing date: $e");
      return;
    }

    if (fromDate == null || toDate == null || toDate.isBefore(fromDate)) return;

    // Ignore time - use only date
    final fromDateOnly = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final toDateOnly = DateTime(toDate.year, toDate.month, toDate.day);

    final numberOfDays = toDateOnly.difference(fromDateOnly).inDays + 1;

    double rentPerDay = double.tryParse(rentController.text) ?? 0;
    double discountVal = double.tryParse(discountController.text) ?? 0;
    double taxPercent = double.tryParse(taxController.text) ?? 0;
    double prepayment = double.tryParse(prePaymentController.text) ?? 0;
    double deposit = double.tryParse(depositController.text) ?? 0;

    final rentWithoutDiscount = rentPerDay * numberOfDays;

    // 🛑 Prevent discount > subtotal
    if (discountVal > rentWithoutDiscount) {
      discountVal = rentWithoutDiscount;
      discountController.text = discountVal.toStringAsFixed(0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomSnackBar(message: StringUtils.discountCantMoreThanTotal);
      });
    }

    subtotal.value = rentWithoutDiscount;
    discount.value = discountVal;

    taxAmount.value = (subtotal.value - discount.value) * (taxPercent / 100);
    grandTotal.value = subtotal.value + taxAmount.value - discount.value;

    // 🛑 Prevent prepayment > grandTotal
    if (prepayment > grandTotal.value) {
      prepayment = grandTotal.value;
      prePaymentController.text = prepayment.toStringAsFixed(0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomSnackBar(
          message: "Prepayment can't be more than total amount",
        );
      });
    }

    balance.value = grandTotal.value - prepayment;
    depositAmount.value = deposit;
    tax.value = taxPercent;
    this.prepayment.value = prepayment;
    // logs("--📅 Days Selected (based on date only): $numberOfDays");
    // logs("--💰 Rent Per Day: $rentPerDay");
    // logs("--🧮 Rent Without Discount: $rentWithoutDiscount");
    // logs("--🎁 Discount: $discountVal");
    // logs("--💸 Tax Percent: $taxPercent");
    // logs("--🪙 Prepayment: $prepayment");
    // logs("--🔐 Deposit: $deposit");
    // logs("--📊 Subtotal: ${subtotal.value}");
    // logs("--🧾 Tax Amount: ${taxAmount.value}");
    // logs("--💳 Grand Total: ${grandTotal.value}");
    // logs("--🧮 Balance: ${balance.value}");
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
            bool isEditing = booking != null;

            bool hasDateChanged =
                !isEditing ||
                booking!.pickupDate != fromDate.value ||
                booking!.dropoffDate != toDate.value;

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
                  onChange: (value) {
                    checkFormValidity();
                    calculateSummary();
                  },
                ),

                /// Phone
                _buildTextField(
                  phoneController,
                  StringUtils.phone,
                  onChange: (value) {
                    checkFormValidity();
                    calculateSummary();
                  },
                ),

                /// Email
                _buildTextField(
                  emailController,
                  StringUtils.email,
                  onChange: (value) {
                    checkFormValidity();
                    calculateSummary();
                  },
                ),

                /// Mileage
                CommonTextField(
                  textEditController: mileageController,
                  labelText: StringUtils.mileage,
                  keyBoardType: TextInputType.number,
                  validator:
                      (value) =>
                          value!.isEmpty ? StringUtils.enterMileage : null,
                  onChange: (value) {
                    checkFormValidity();
                    calculateSummary();
                  },
                ),

                ///rentPerDay
                CommonTextField(
                  textEditController: rentController,
                  labelText: StringUtils.rentPerDay,
                  keyBoardType: TextInputType.number,
                  validator:
                      (value) =>
                          value!.isEmpty ? StringUtils.enterRentPrice : null,
                  onChange: (value) {
                    checkFormValidity();
                    calculateSummary();
                  },
                ),

                ///extraPerKm
                CommonTextField(
                  textEditController: extraPerKmController,
                  labelText: StringUtils.extraPerKm,
                  keyBoardType: TextInputType.number,
                  onChange: (value) {
                    checkFormValidity();
                    calculateSummary();
                  },
                  validator:
                      (value) =>
                          value!.isEmpty ? StringUtils.enterExtraKmRate : null,
                ),

                ///deposit
                CommonTextField(
                  textEditController: depositController,
                  labelText: "${StringUtils.securityDeposit}: (\$)",
                  keyBoardType: TextInputType.number,
                  onChange: (value) {
                    checkFormValidity();
                    calculateSummary();
                  },
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
                  onChange: (value) {
                    checkFormValidity();
                    calculateSummary();
                  },
                ),

                /// Tax
                CommonTextField(
                  labelText: "${StringUtils.tax} (%)",
                  textEditController: taxController,
                  keyBoardType: TextInputType.number,
                  onChange: (value) {
                    checkFormValidity();
                    calculateSummary();
                  },
                ),

                /// Pre payment
                CommonTextField(
                  labelText: StringUtils.prepayment,
                  textEditController: prePaymentController,
                  keyBoardType: TextInputType.number,
                  onChange: (value) {
                    checkFormValidity();
                    calculateSummary();
                  },
                ),

                /// Payment Summary
                Container(
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.only(top: 24.h),
                  decoration: BoxDecoration(
                    color: ColorUtils.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    final parsedPrepayment =
                        double.tryParse(prePaymentController.text) ?? 0.0;
                    final hasPrepayment =
                        prePaymentController.text.isNotEmpty &&
                        parsedPrepayment > 0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.payment, color: ColorUtils.primary),
                            SizedBox(width: 8.w),
                            CustomText(
                              StringUtils.paymentDetails,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.primary,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _buildInfoRow("${StringUtils.typeOfPayment}:", "Cash"),

                        SizedBox(height: 12.h),
                        _sectionHeader(StringUtils.costBreakdown),
                        _buildInfoRow(
                          "${StringUtils.subtotal}:",
                          "\$${subtotal.value.toStringAsFixed(2)}",
                        ),

                        if (discount.value > 0)
                          _buildInfoRow(
                            "${StringUtils.discount}:",
                            "-\$${discount.value.toStringAsFixed(2)}",
                          ),
                        _buildInfoRow(
                          "${StringUtils.tax} (${double.tryParse(taxController.text)?.toStringAsFixed(0) ?? 0}%):",
                          "\$${taxAmount.value.toStringAsFixed(2)}",
                        ),
                        _buildInfoRow(
                          "${StringUtils.grandTotal}:",
                          "\$${grandTotal.value.toStringAsFixed(2)}",
                        ),

                        if (hasPrepayment) ...[
                          SizedBox(height: 12.h),
                          _sectionHeader(StringUtils.advancePayment),
                          _buildInfoRow(
                            "${StringUtils.prepaid}:",
                            "-\$${parsedPrepayment.toStringAsFixed(2)}",
                          ),
                        ],

                        SizedBox(height: 12.h),
                        _sectionHeader(StringUtils.finalAmount),
                        _buildInfoRow(
                          "${StringUtils.balance}:",
                          "\$${balance.value.toStringAsFixed(2)}",
                        ),
                        _buildInfoRow(
                          "${StringUtils.securityDepositRefundable}:",
                          "\$${depositAmount.value.toStringAsFixed(2)}",
                        ),

                        SizedBox(height: 10.h),
                        Divider(
                          height: 30.h,
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        Center(
                          child: CustomText(
                            "${StringUtils.totalToCollectNow}: \$${(balance.value + depositAmount.value).toStringAsFixed(2)}",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                SizedBox(height: 40.h),

                /// Confirm Booking btn
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: CustomBtn(
                    onTap:
                        isValid.value
                            ? () {
                              bool isEditing = booking != null;

                              bool hasDateChanged =
                                  !isEditing ||
                                  booking!.pickupDate != fromDate.value ||
                                  booking!.dropoffDate != toDate.value ||
                                  booking!.pickupTime !=
                                      DateFormat(
                                        'hh:mm a',
                                      ).format(fromDate.value!) ||
                                  booking!.dropoffTime !=
                                      DateFormat(
                                        'hh:mm a',
                                      ).format(toDate.value!);

                              if (hasDateChanged) {
                                final existingBookings =
                                    Get.find<BikeBookingController>()
                                        .bookingList
                                        .where(
                                          (b) =>
                                              b.bikeId == bike.id &&
                                              (!isEditing ||
                                                  b.id != booking!.id),
                                        )
                                        .toList();

                                bool isOverlapping(
                                  DateTime newStart,
                                  DateTime newEnd,
                                  DateTime existingStart,
                                  DateTime existingEnd,
                                ) {
                                  return newStart.isBefore(existingEnd) &&
                                      newEnd.isAfter(existingStart);
                                }

                                final newStart = fromDate.value!;
                                final newEnd = toDate.value!;
                                bool isConflict = false;

                                for (var b in existingBookings) {
                                  final existingStart = DateTime(
                                    b.pickupDate.year,
                                    b.pickupDate.month,
                                    b.pickupDate.day,
                                    DateFormat(
                                      'hh:mm a',
                                    ).parse(b.pickupTime).hour,
                                    DateFormat(
                                      'hh:mm a',
                                    ).parse(b.pickupTime).minute,
                                  );

                                  final existingEnd = DateTime(
                                    b.dropoffDate.year,
                                    b.dropoffDate.month,
                                    b.dropoffDate.day,
                                    DateFormat(
                                      'hh:mm a',
                                    ).parse(b.dropoffTime).hour,
                                    DateFormat(
                                      'hh:mm a',
                                    ).parse(b.dropoffTime).minute,
                                  );

                                  if (isOverlapping(
                                    newStart,
                                    newEnd,
                                    existingStart,
                                    existingEnd,
                                  )) {
                                    isConflict = true;
                                    break;
                                  }
                                }

                                if (isConflict) {
                                  showCustomSnackBar(
                                    message:
                                        "This bike is already booked during the selected time.",
                                  );
                                  return;
                                }
                              }

                              // If not conflict or not date-changed, show confirm dialog
                              showBookingConfirmationDialog();
                            }
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: CustomText(
        title,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
      ),
    );
  }

  bool isBookingOverlapping(
    DateTime newStart,
    DateTime newEnd,
    List<BookingModel> existingBookings,
  ) {
    for (final booking in existingBookings) {
      final DateTime start = DateTime(
        booking.pickupDate.year,
        booking.pickupDate.month,
        booking.pickupDate.day,
        DateFormat('hh:mm a').parse(booking.pickupTime).hour,
      );

      final DateTime end = DateTime(
        booking.dropoffDate.year,
        booking.dropoffDate.month,
        booking.dropoffDate.day,
        DateFormat('hh:mm a').parse(booking.dropoffTime).hour,
      );

      if (newStart.isBefore(end) && newEnd.isAfter(start)) {
        // Overlap exists
        showCustomSnackBar(
          message:
              "Dates occupied from ${DateFormat('d MMM, hh:mm a').format(start)} "
              "to ${DateFormat('d MMM, hh:mm a').format(end)}",
        );
        return true;
      }
    }
    return false;
  }

  void showBookingConfirmationDialog() {
    if (fromDate.value == null || toDate.value == null) {
      showCustomSnackBar(message: StringUtils.pleaseSelectBothTheDates);
      return;
    }

    final bikeName = bike.brandName ?? "N/A";
    final bikeModel = bike.model ?? "N/A";

    final from = fromDate.value!;
    final to = toDate.value!;
    final duration = to.difference(from);
    final durationInDays = duration.inHours / 24;

    // Format helper
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
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("${StringUtils.bike}:", "$bikeName ($bikeModel)"),
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
                  "\$ ${formatAmount(subtotal.value)}",
                ),
                _buildInfoRow(
                  "${StringUtils.discount}:",
                  "\$ ${formatAmount(discount.value)}",
                ),
                _buildInfoRow(
                  "${StringUtils.tax}:",
                  "${formatAmount(tax.value)}%",
                ),
                _buildInfoRow(
                  "${StringUtils.totalAmount}: ",
                  "\$ ${formatAmount(grandTotal.value)}",
                ),
                _buildInfoRow(
                  "${StringUtils.prepayment}: ",
                  "\$ ${formatAmount(prepayment.value)}",
                ),
                _buildInfoRow(
                  "${StringUtils.balance}: ",
                  "\$ ${formatAmount(balance.value)}",
                ),
              ],
            ),
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
                      final pickupDate = DateTime(
                        from.year,
                        from.month,
                        from.day,
                      );
                      final dropOffDate = DateTime(to.year, to.month, to.day);
                      final pickupTime = DateFormat('hh:mm a').format(from);
                      final dropOffTime = DateFormat('hh:mm a').format(to);

                      final newBooking = BookingModel(
                        // id: isEditing ? existingBookingId : null,
                        userId: 1,
                        bikeId: bike.id ?? 0,
                        bikeName: bike.brandName ?? "",
                        bikeModel: bike.model ?? "",
                        userFullName: fullNameController.text,
                        userPhone: phoneController.text,
                        userEmail: emailController.text,
                        pickupDate: pickupDate,
                        dropoffDate: dropOffDate,
                        pickupTime: pickupTime,
                        dropoffTime: dropOffTime,
                        typeOfPayment: 'Cash',
                        rentPerDay: double.parse(rentController.text.trim()),
                        mileage: num.parse(mileageController.text.trim()),
                        extraPerKm: double.parse(
                          extraPerKmController.text.trim(),
                        ),
                        securityDeposit: double.parse(
                          depositController.text.trim(),
                        ),
                        subtotal: subtotal.value,
                        balance: balance.value,
                        durationInHours: duration.inHours.toDouble(),
                        totalRent: subtotal.value,
                        finalAmountPayable: grandTotal.value,
                        discount: discount.value,
                        tax: tax.value,
                        prepayment: prepayment.value,
                        bikes: [bike],
                        createdAt: DateTime.now(),
                      );
                      if (booking == null) {
                        logs("----Adding");
                        await Get.find<BikeBookingController>().addBooking(
                          newBooking,
                        );
                      } else {
                        logs("----Updating");
                        final today = DateTime.now();
                        final nowDateOnly = DateTime(
                          today.year,
                          today.month,
                          today.day,
                        );

                        final isPickupPastOrToday =
                            DateTime(
                              from.year,
                              from.month,
                              from.day,
                            ).isBefore(nowDateOnly) ||
                            DateTime(
                              from.year,
                              from.month,
                              from.day,
                            ).isAtSameMomentAs(nowDateOnly);

                        final isDropoffPastOrToday =
                            DateTime(
                              to.year,
                              to.month,
                              to.day,
                            ).isBefore(nowDateOnly) ||
                            DateTime(
                              to.year,
                              to.month,
                              to.day,
                            ).isAtSameMomentAs(nowDateOnly);

                        if (booking != null &&
                            (isPickupPastOrToday || isDropoffPastOrToday)) {
                          showCustomSnackBar(
                            message: StringUtils.youCannotUpdateCurrentBooking,
                            isError: true,
                          );
                          return;
                        }

                        newBooking.id = booking?.id ?? 0;
                        await Get.find<BikeBookingController>().updateBooking(
                          newBooking,
                        );
                      }

                      await Get.find<BikeBookingController>().fetchBookings();
                      Get.back(); // Close dialog
                      Get.back(); // Go back to previous screen
                      showCustomSnackBar(
                        message:
                            booking != null
                                ? StringUtils.bookingUpdatedSuccessfully
                                : StringUtils.bikeBookedSuccessfully,
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
