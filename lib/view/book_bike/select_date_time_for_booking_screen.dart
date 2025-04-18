import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_bloc.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_event.dart';

// ✅ Helper Function for Date Comparison
extension DateCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class SelectDateTimeForBookingScreen extends StatefulWidget {
  final BikeModel bike;
  final BookingModel? booking;

  const SelectDateTimeForBookingScreen({
    super.key,
    required this.bike,
    this.booking,
  });

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
  DateTime? fromDate;
  DateTime? toDate;
  bool isValid = false;
  List<BikeModel> selectedBikesList = [];
  double subtotal = 0.0;
  double taxAmount = 0.0;
  double grandTotal = 0.0;
  double balance = 0.0;
  double discount = 0.0;
  double depositAmount = 0.0;
  double tax = 0.0;
  double prepayment = 0.0;

  @override
  void initState() {
    super.initState();
    // final args = Get.arguments as Map<String, dynamic>;
    bike = widget.bike;
    booking = widget.booking;
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

      fromDate = booking?.pickupDate;
      toDate = booking?.dropoffDate;

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
    logs("🚲 Bike Details from Get.arguments:");
    logs("Bike id: ${bike.id}");
    logs("Brand Name: ${bike.brandName}");
    logs("Model: ${bike.model}");
    logs("Location: ${bike.location}");
    logs("Transmission: ${bike.transmission}");
  }

  initMethod() async {
    context.read<BookBikeBloc>().add(FetchBookingsEvent());
  }

  Future<void> pickDateTime(bool isFrom) async {
    DateTime now = DateTime.now();
    final initial =
        isFrom
            ? fromDate ?? now
            : toDate ?? (fromDate ?? now).add(Duration(days: 1));
    final first = isFrom ? now : (fromDate ?? now);

    // 👇 Ensure initialDate is not before firstDate
    final validInitial = initial.isBefore(first) ? first : initial;
    final pickedDate = await showDatePicker(
      context: context,
      // initialDate:
      //     isFrom
      //         ? fromDate ?? now
      //         : toDate ?? (fromDate ?? now).add(Duration(days: 1)),
      // firstDate: isFrom ? now : (fromDate ?? now),
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
        final from = fromDate;
        minHour =
            (DateCompare(pickedDate).isSameDate(from ?? now))
                ? ((from ?? now).hour + 1)
                : 0;
      }

      final currentDate = isFrom ? fromDate : toDate;
      final selectedHour =
          (currentDate != null &&
                  DateCompare(pickedDate).isSameDate(currentDate))
              ? currentDate.hour
              : null;

      // 🕒 Time Picker Dialog with Styled Slots
      final pickedTime = await showDialog<TimeOfDay>(
        context: context,
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
          fromDate = finalDateTime;
          fromDateController.text = DateFormat(
            'MMMM d, yyyy hh:mm a',
          ).format(finalDateTime);

          if (toDate != null &&
              toDate!.isBefore(fromDate!.add(Duration(hours: 1)))) {
            toDate = fromDate!.add(Duration(hours: 1));
            toDateController.text = DateFormat(
              'MMMM d, yyyy hh:mm a',
            ).format(toDate!);
          }
        } else {
          if (fromDate != null &&
              finalDateTime.isBefore(fromDate!.add(Duration(hours: 1)))) {
            showCustomSnackBar(message: StringUtils.dropOffMustBeOneHour);

            return;
          }

          toDate = finalDateTime;
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
    isValid =
        fromDate != null &&
        toDate != null &&
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

    subtotal = rentWithoutDiscount;
    discount = discountVal;

    taxAmount = (subtotal - discount) * (taxPercent / 100);
    grandTotal = subtotal + taxAmount - discount;

    // 🛑 Prevent prepayment > grandTotal
    if (prepayment > grandTotal) {
      prepayment = grandTotal;
      prePaymentController.text = prepayment.toStringAsFixed(0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomSnackBar(
          message: "Prepayment can't be more than total amount",
        );
      });
    }

    balance = grandTotal - prepayment;
    depositAmount = deposit;
    tax = taxPercent;
    this.prepayment = prepayment;
    // logs("--📅 Days Selected (based on date only): $numberOfDays");
    // logs("--💰 Rent Per Day: $rentPerDay");
    // logs("--🧮 Rent Without Discount: $rentWithoutDiscount");
    // logs("--🎁 Discount: $discountVal");
    // logs("--💸 Tax Percent: $taxPercent");
    // logs("--🪙 Prepayment: $prepayment");
    // logs("--🔐 Deposit: $deposit");
    // logs("--📊 Subtotal: ${subtotal}");
    // logs("--🧾 Tax Amount: ${taxAmount}");
    // logs("--💳 Grand Total: ${grandTotal}");
    // logs("--🧮 Balance: ${balance}");
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = booking != null;
    final parsedPrepayment = double.tryParse(prePaymentController.text) ?? 0.0;
    final hasPrepayment =
        prePaymentController.text.isNotEmpty && parsedPrepayment > 0;
    bool hasDateChanged =
        !isEditing ||
        booking!.pickupDate != fromDate ||
        booking!.dropoffDate != toDate;
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
          child: Column(
            children: [
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
                    (value) => value!.isEmpty ? StringUtils.enterMileage : null,
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
                        value!.isEmpty ? StringUtils.enterDepositAmount : null,
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
                child: Column(
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
                      "\$${subtotal.toStringAsFixed(2)}",
                    ),

                    if (discount > 0)
                      _buildInfoRow(
                        "${StringUtils.discount}:",
                        "-\$${discount.toStringAsFixed(2)}",
                      ),
                    _buildInfoRow(
                      "${StringUtils.tax} (${double.tryParse(taxController.text)?.toStringAsFixed(0) ?? 0}%):",
                      "\$${taxAmount.toStringAsFixed(2)}",
                    ),
                    _buildInfoRow(
                      "${StringUtils.grandTotal}:",
                      "\$${grandTotal.toStringAsFixed(2)}",
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
                      "\$${balance.toStringAsFixed(2)}",
                    ),
                    _buildInfoRow(
                      "${StringUtils.securityDepositRefundable}:",
                      "\$${depositAmount.toStringAsFixed(2)}",
                    ),

                    SizedBox(height: 10.h),
                    Divider(
                      height: 30.h,
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                    Center(
                      child: CustomText(
                        "${StringUtils.totalToCollectNow}: \$${(balance + depositAmount).toStringAsFixed(2)}",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              /// Confirm Booking btn
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: CustomBtn(
                  onTap:
                      isValid
                          ? () {
                            bool isEditing = booking != null;

                            bool hasDateChanged =
                                !isEditing ||
                                booking!.pickupDate != fromDate ||
                                booking!.dropoffDate != toDate ||
                                booking!.pickupTime !=
                                    DateFormat('hh:mm a').format(fromDate!) ||
                                booking!.dropoffTime !=
                                    DateFormat('hh:mm a').format(toDate!);

                            if (hasDateChanged) {
                              final existingBookings =
                                  context
                                      .read<BookBikeBloc>()
                                      .bookingList
                                      .where(
                                        (b) =>
                                            b.bikeId == bike.id &&
                                            (!isEditing || b.id != booking!.id),
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

                              final newStart = fromDate!;
                              final newEnd = toDate!;
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
                      isValid
                          ? ColorUtils.primary
                          : ColorUtils.primary.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
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
    if (fromDate == null || toDate == null) {
      showCustomSnackBar(message: StringUtils.pleaseSelectBothTheDates);
      return;
    }

    final bikeName = bike.brandName ?? "N/A";
    final bikeModel = bike.model ?? "N/A";

    final from = fromDate!;
    final to = toDate!;
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
                  "\$ ${formatAmount(subtotal)}",
                ),
                _buildInfoRow(
                  "${StringUtils.discount}:",
                  "\$ ${formatAmount(discount)}",
                ),
                _buildInfoRow("${StringUtils.tax}:", "${formatAmount(tax)}%"),
                _buildInfoRow(
                  "${StringUtils.totalAmount}: ",
                  "\$ ${formatAmount(grandTotal)}",
                ),
                _buildInfoRow(
                  "${StringUtils.prepayment}: ",
                  "\$ ${formatAmount(prepayment)}",
                ),
                _buildInfoRow(
                  "${StringUtils.balance}: ",
                  "\$ ${formatAmount(balance)}",
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
                        subtotal: subtotal,
                        balance: balance,
                        durationInHours: duration.inHours.toDouble(),
                        totalRent: subtotal,
                        finalAmountPayable: grandTotal,
                        discount: discount,
                        tax: tax,
                        prepayment: prepayment,
                        bikes: [bike],
                        createdAt: DateTime.now(),
                      );
                      if (booking == null) {
                        logs("----Adding");
                        // await Get.find<BikeBookingController>().addBooking(
                        //   newBooking,
                        // );
                        context.read<BookBikeBloc>().add(
                          AddBookingEvent(newBooking),
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
                        // await Get.find<BikeBookingController>().updateBooking(
                        //   newBooking,
                        // );
                        context.read<BookBikeBloc>().add(
                          UpdateBookingEvent(newBooking),
                        );
                      }

                      // await Get.find<BikeBookingController>().fetchBookings();
                      context.read<BookBikeBloc>().add(FetchBookingsEvent());
                      Navigator.pop(context);
                      // Close dialog
                      Navigator.pop(context);
                      // Go back to previous screen
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

///
/// ///Bloc Code
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_bloc.dart';
// import 'package:rental_motor_cycle/blocs/book_bike/book_bike_home_bloc/book_bike_bloc.dart';
// import 'package:rental_motor_cycle/blocs/book_bike/book_bike_home_bloc/book_bike_event.dart';
// import 'package:rental_motor_cycle/blocs/book_bike/booking_form_bloc/booking_form_bloc.dart';
// import 'package:rental_motor_cycle/blocs/book_bike/booking_form_bloc/booking_form_event.dart';
// import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
// import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
// import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
// import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
// import 'package:rental_motor_cycle/controller/bike_booking_controller.dart';
// import 'package:rental_motor_cycle/model/bike_model.dart';
// import 'package:rental_motor_cycle/model/booking_model.dart';
// import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
// import 'package:rental_motor_cycle/utils/color_utils.dart';
// import 'package:rental_motor_cycle/utils/string_utils.dart';
//
// import '../../blocs/book_bike/booking_form_bloc/booking_form_state.dart';
//
// // ✅ Helper Function for Date Comparison
// extension DateCompare on DateTime {
//   bool isSameDate(DateTime other) {
//     return year == other.year && month == other.month && day == other.day;
//   }
// }
//
// class SelectDateTimeForBookingScreen extends StatefulWidget {
//   final BikeModel bike;
//   final BookingModel? booking;
//
//   const SelectDateTimeForBookingScreen({
//     super.key,
//     required this.bike,
//     this.booking,
//   });
//
//   @override
//   State<SelectDateTimeForBookingScreen> createState() =>
//       _SelectDateTimeForBookingScreenState();
// }
//
// class _SelectDateTimeForBookingScreenState
//     extends State<SelectDateTimeForBookingScreen> {
//   late final BikeModel bike;
//   BookingModel? booking;
//
//   // TextEditingController fromDateController = TextEditingController();
//   // TextEditingController discountController = TextEditingController();
//   // TextEditingController taxController = TextEditingController();
//   // TextEditingController prePaymentController = TextEditingController();
//   // TextEditingController toDateController = TextEditingController();
//   // final fullNameController = TextEditingController();
//   // final TextEditingController mileageController = TextEditingController();
//   // final TextEditingController rentController = TextEditingController();
//   // final TextEditingController extraPerKmController = TextEditingController();
//   // final TextEditingController depositController = TextEditingController();
//   // final phoneController = TextEditingController();
//   // final emailController = TextEditingController();
//   // final Rxn<DateTime> fromDate = Rxn<DateTime>();
//   // final Rxn<DateTime> toDate = Rxn<DateTime>();
//   // final isValid = false.obs;
//   // List<BikeModel> selectedBikesList = [];
//   // final RxDouble subtotal = 0.0.obs;
//   // final RxDouble taxAmount = 0.0.obs;
//   // final RxDouble grandTotal = 0.0.obs;
//   // final RxDouble balance = 0.0.obs;
//   // final RxDouble discount = 0.0.obs;
//   // final RxDouble depositAmount = 0.0.obs;
//   // final RxDouble tax = 0.0.obs;
//   // final RxDouble prepayment = 0.0.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     // bike = widget.bike;
//     // booking = widget.booking;
//     initMethod();
//
//     // If this screen is used to update an existing booking
//     // if (booking != null) {
//     //   // isEditing = true;
//     //   // existingBookingId = booking?.id ?? 0;
//     //   // final BookingModel booking = booking;
//     //   fullNameController.text = booking?.userFullName ?? '';
//     //   phoneController.text = booking?.userPhone ?? '';
//     //   emailController.text = booking?.userEmail ?? '';
//     //   mileageController.text = formatNum(booking?.mileage);
//     //
//     //   rentController.text =
//     //       booking?.rentPerDay != null
//     //           ? formatDoubleOrInt(booking?.rentPerDay)
//     //           : '';
//     //   extraPerKmController.text =
//     //       booking?.extraPerKm != null
//     //           ? formatDoubleOrInt(booking?.extraPerKm)
//     //           : '';
//     //   depositController.text =
//     //       booking?.securityDeposit != null
//     //           ? formatDoubleOrInt(booking?.securityDeposit)
//     //           : '';
//     //   discountController.text =
//     //       booking?.discount != null ? formatDoubleOrInt(booking?.discount) : '';
//     //   taxController.text =
//     //       booking?.tax != null ? formatDoubleOrInt(booking?.tax) : '';
//     //   prePaymentController.text =
//     //       booking?.prepayment != null
//     //           ? formatDoubleOrInt(booking?.prepayment)
//     //           : '';
//     //
//     //   fromDate = booking?.pickupDate;
//     //   toDate = booking?.dropoffDate;
//     //
//     //   final pickup = booking?.pickupDate;
//     //   if (pickup != null) {
//     //     fromDateController.text = DateFormat(
//     //       'MMMM d, yyyy hh:mm a',
//     //     ).format(pickup);
//     //   }
//     //
//     //   final dropOff = booking?.dropoffDate;
//     //   if (dropOff != null) {
//     //     toDateController.text = DateFormat(
//     //       'MMMM d, yyyy hh:mm a',
//     //     ).format(dropOff);
//     //   }
//     // }
//     context.read<BooingFormBloc>().add(CalculateBookingSummary());
//   }
//
//   initMethod() async {
//     await Get.find<BikeBookingController>().fetchBookings();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: commonAppBar(
//         titleText: StringUtils.selectDates,
//         context: context,
//         isLeading: true,
//         isCenterTitle: true,
//         fontSize: 20.sp,
//         fontWeight: FontWeight.w600,
//       ),
//       body: MultiBlocProvider(
//         providers: [
//           BlocProvider(value: context.read<BookBikeBloc>()),
//           BlocProvider(
//             create:
//                 (_) => BooingFormBloc(
//                   bikeBloc: context.read<BikeBloc>(),
//                   booking: booking,
//                 ),
//           ),
//         ],
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               children: [
//                 /// From Date
//                 GestureDetector(
//                   onTap: () => pickDateTime(true),
//                   child: AbsorbPointer(
//                     child: CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().fromDateController,
//                       labelText: StringUtils.fromDate,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//
//                 /// To Date
//                 GestureDetector(
//                   onTap: () => pickDateTime(false),
//                   child: AbsorbPointer(
//                     child: CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().toDateController,
//                       labelText: StringUtils.toDate,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//
//                 /// FullName
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   buildWhen:
//                       (previous, current) =>
//                           previous.fullNameController !=
//                           current.fullNameController,
//                   builder: (context, state) {
//                     return CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().fullNameController,
//                       labelText: StringUtils.fullName,
//                       keyBoardType: TextInputType.name,
//                       validator:
//                           (value) =>
//                               value!.isEmpty
//                                   ? StringUtils.enterVehicleNumber
//                                   : null,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 /// Phone
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   buildWhen:
//                       (previous, current) =>
//                           previous.phoneController != current.phoneController,
//                   builder: (context, state) {
//                     return CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().phoneController,
//                       labelText: StringUtils.phone,
//                       keyBoardType: TextInputType.phone,
//                       validator:
//                           (value) =>
//                               value!.isEmpty
//                                   ? '${StringUtils.enter} ${StringUtils.phone}'
//                                   : null,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 /// Email
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   buildWhen:
//                       (previous, current) =>
//                           previous.emailController != current.emailController,
//                   builder: (context, state) {
//                     return CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().emailController,
//                       labelText: StringUtils.email,
//                       keyBoardType: TextInputType.emailAddress,
//                       validator:
//                           (value) =>
//                               value!.isEmpty
//                                   ? '${StringUtils.enter} ${StringUtils.email}'
//                                   : null,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 /// Mileage
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   buildWhen:
//                       (previous, current) =>
//                           previous.mileageController !=
//                           current.mileageController,
//                   builder: (context, state) {
//                     return CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().mileageController,
//                       labelText: StringUtils.mileage,
//                       keyBoardType: TextInputType.number,
//                       validator:
//                           (value) =>
//                               value!.isEmpty ? StringUtils.enterMileage : null,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 ///rentPerDay
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   buildWhen:
//                       (previous, current) =>
//                           previous.rentController != current.rentController,
//                   builder: (context, state) {
//                     return CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().rentController,
//                       labelText: StringUtils.rentPerDay,
//                       keyBoardType: TextInputType.number,
//                       validator:
//                           (value) =>
//                               value!.isEmpty
//                                   ? StringUtils.enterRentPrice
//                                   : null,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 ///extraPerKm
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   buildWhen:
//                       (previous, current) =>
//                           previous.extraPerKmController !=
//                           current.extraPerKmController,
//                   builder: (context, state) {
//                     return CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().extraPerKmController,
//                       labelText: StringUtils.extraPerKm,
//                       keyBoardType: TextInputType.number,
//                       validator:
//                           (value) =>
//                               value!.isEmpty
//                                   ? StringUtils.enterExtraKmRate
//                                   : null,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 ///deposit
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   buildWhen:
//                       (previous, current) =>
//                           previous.depositController !=
//                           current.depositController,
//                   builder: (context, state) {
//                     return CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().depositController,
//                       labelText: "${StringUtils.securityDeposit}: (\$)",
//                       keyBoardType: TextInputType.number,
//                       validator:
//                           (value) =>
//                               value!.isEmpty
//                                   ? StringUtils.enterDepositAmount
//                                   : null,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 /// Discount
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   buildWhen:
//                       (previous, current) =>
//                           previous.discount != current.discount,
//                   builder: (context, state) {
//                     return CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().discountController,
//                       labelText: "${StringUtils.discount} (\$)",
//                       keyBoardType: TextInputType.number,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 /// Tax
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   buildWhen:
//                       (previous, current) =>
//                           previous.taxController != current.taxController,
//                   builder: (context, state) {
//                     return CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().taxController,
//                       labelText: "${StringUtils.tax} (%)",
//                       keyBoardType: TextInputType.number,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 /// Pre payment
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   buildWhen:
//                       (previous, current) =>
//                           previous.prePaymentController !=
//                           current.prePaymentController,
//                   builder: (context, state) {
//                     return CommonTextField(
//                       textEditController:
//                           context.read<BooingFormBloc>().prePaymentController,
//                       labelText: StringUtils.prepayment,
//                       keyBoardType: TextInputType.number,
//                       onChange: (value) {
//                         context.read<BooingFormBloc>().add(
//                           BookingFormValidateFields(),
//                         );
//                         context.read<BooingFormBloc>().add(
//                           CalculateBookingSummary(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//
//                 /// Payment Summary
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   builder: (context, state) {
//                     final parsedPrepayment =
//                         double.tryParse(
//                           state.prePaymentController.toString(),
//                         ) ??
//                         0.0;
//
//                     final hasPrepayment =
//                         state.prePaymentController.toString().isNotEmpty &&
//                         parsedPrepayment > 0;
//                     final deposit =
//                         double.tryParse(state.depositController.toString()) ??
//                         0.0;
//
//                     final balance = context.read<BooingFormBloc>().balance;
//
//                     final totalToCollect = balance + deposit;
//                     final discount = state.discount;
//                     return Container(
//                       padding: EdgeInsets.all(16.w),
//                       margin: EdgeInsets.only(top: 24.h),
//                       decoration: BoxDecoration(
//                         color: ColorUtils.white,
//                         borderRadius: BorderRadius.circular(16.r),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 8,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.payment, color: ColorUtils.primary),
//                               SizedBox(width: 8.w),
//                               CustomText(
//                                 StringUtils.paymentDetails,
//                                 fontSize: 18.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: ColorUtils.primary,
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16.h),
//                           _buildInfoRow(
//                             "${StringUtils.typeOfPayment}:",
//                             "Cash",
//                           ),
//                           SizedBox(height: 12.h),
//                           _sectionHeader(StringUtils.costBreakdown),
//                           _buildInfoRow(
//                             "${StringUtils.subtotal}:",
//                             "\$${state.subtotal?.toStringAsFixed(2)}",
//                           ),
//                           if ((discount ?? 0) > 0)
//                             _buildInfoRow(
//                               "${StringUtils.discount}:",
//                               "-\$${state.discount?.toStringAsFixed(2)}",
//                             ),
//                           _buildInfoRow(
//                             "${StringUtils.tax} (${double.tryParse(state.taxController ?? "")?.toStringAsFixed(0) ?? 0}%):",
//                             "\$${state.taxAmount}",
//                           ),
//                           _buildInfoRow(
//                             "${StringUtils.grandTotal}:",
//                             "\$${state.grandTotal?.toStringAsFixed(2)}",
//                           ),
//                           if (hasPrepayment) ...[
//                             SizedBox(height: 12.h),
//                             _sectionHeader(StringUtils.advancePayment),
//                             _buildInfoRow(
//                               "${StringUtils.prepaid}:",
//                               "-\$${parsedPrepayment.toStringAsFixed(2)}",
//                             ),
//                           ],
//                           SizedBox(height: 12.h),
//                           _sectionHeader(StringUtils.finalAmount),
//                           _buildInfoRow(
//                             "${StringUtils.balance}:",
//                             "\$${state.balance?.toStringAsFixed(2)}",
//                           ),
//                           _buildInfoRow(
//                             "${StringUtils.securityDepositRefundable}:",
//                             "\$${state.depositController}",
//                           ),
//                           SizedBox(height: 10.h),
//                           Divider(
//                             height: 30.h,
//                             color: Colors.grey.shade300,
//                             thickness: 1,
//                           ),
//                           Center(
//                             child: CustomText(
//                               "${StringUtils.totalToCollectNow}: \$${totalToCollect.toStringAsFixed(2)}",
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//
//                 SizedBox(height: 40.h),
//
//                 /// Confirm Booking btn
//                 BlocBuilder<BooingFormBloc, BookingFormState>(
//                   builder: (context, state) {
//                     return Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 25.w),
//                       child: CustomBtn(
//                         onTap:
//                         /* context.read<BooingFormBloc>().isValid
//                                 ? */
//                         () {
//                           bool isEditing = booking != null;
//
//                           bool hasDateChanged =
//                               !isEditing ||
//                               booking!.pickupDate !=
//                                   context.read<BooingFormBloc>().fromDate ||
//                               booking!.dropoffDate !=
//                                   context.read<BooingFormBloc>().toDate ||
//                               booking!.pickupTime !=
//                                   DateFormat('hh:mm a').format(
//                                     context.read<BooingFormBloc>().fromDate,
//                                   ) ||
//                               booking!.dropoffTime !=
//                                   DateFormat('hh:mm a').format(
//                                     context.read<BooingFormBloc>().toDate,
//                                   );
//
//                           if (hasDateChanged) {
//                             final existingBookings =
//                                 Get.find<BikeBookingController>().bookingList
//                                     .where(
//                                       (b) =>
//                                           b.bikeId == bike.id &&
//                                           (!isEditing || b.id != booking!.id),
//                                     )
//                                     .toList();
//
//                             bool isOverlapping(
//                               DateTime newStart,
//                               DateTime newEnd,
//                               DateTime existingStart,
//                               DateTime existingEnd,
//                             ) {
//                               return newStart.isBefore(existingEnd) &&
//                                   newEnd.isAfter(existingStart);
//                             }
//
//                             final newStart =
//                                 context.read<BooingFormBloc>().fromDate;
//                             final newEnd =
//                                 context.read<BooingFormBloc>().toDate;
//                             bool isConflict = false;
//
//                             for (var b in existingBookings) {
//                               final existingStart = DateTime(
//                                 b.pickupDate.year,
//                                 b.pickupDate.month,
//                                 b.pickupDate.day,
//                                 DateFormat('hh:mm a').parse(b.pickupTime).hour,
//                                 DateFormat(
//                                   'hh:mm a',
//                                 ).parse(b.pickupTime).minute,
//                               );
//
//                               final existingEnd = DateTime(
//                                 b.dropoffDate.year,
//                                 b.dropoffDate.month,
//                                 b.dropoffDate.day,
//                                 DateFormat('hh:mm a').parse(b.dropoffTime).hour,
//                                 DateFormat(
//                                   'hh:mm a',
//                                 ).parse(b.dropoffTime).minute,
//                               );
//
//                               if (isOverlapping(
//                                 newStart,
//                                 newEnd,
//                                 existingStart,
//                                 existingEnd,
//                               )) {
//                                 isConflict = true;
//                                 break;
//                               }
//                             }
//
//                             if (isConflict) {
//                               showCustomSnackBar(
//                                 message:
//                                     "This bike is already booked during the selected time.",
//                               );
//                               return;
//                             }
//                           }
//
//                           logs(
//                             "---context.read<BooingFormBloc>().subtotal---${context.read<BooingFormBloc>().state.subtotal}",
//                           );
//                           // If not conflict or not date-changed, show confirm dialog
//                           showBookingConfirmationDialog();
//                         },
//                         /* : null*/
//                         title: StringUtils.confirmBooking,
//                         bgColor:
//                             /*context.read<BooingFormBloc>().isValid
//                                 ? */
//                             ColorUtils.primary,
//                         /* : ColorUtils.primary.withValues(alpha: 0.5)*/
//                       ),
//                     );
//                   },
//                 ),
//                 // CustomBtn(
//                 //   onTap: () {
//                 //     context.read<BooingFormBloc>().add(
//                 //       BookingFormSubmitted(
//                 //         bike: bike,
//                 //         existingBooking: booking,
//                 //         bookBikeBloc: context.read<BookBikeBloc>(),
//                 //       ),
//                 //     );
//                 //   },
//                 //   title: StringUtils.confirm,
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Future<void> pickDateTime(bool isFrom) async {
//   //   DateTime now = DateTime.now();
//   //   final initial =
//   //       isFrom
//   //           ? fromDate ?? now
//   //           : toDate ?? (fromDate ?? now).add(Duration(days: 1));
//   //   final first = isFrom ? now : (fromDate ?? now);
//   //
//   //   // 👇 Ensure initialDate is not before firstDate
//   //   final validInitial = initial.isBefore(first) ? first : initial;
//   //   final pickedDate = await showDatePicker(
//   //     context: context,
//   //     // initialDate:
//   //     //     isFrom
//   //     //         ? fromDate ?? now
//   //     //         : toDate ?? (fromDate ?? now).add(Duration(days: 1)),
//   //     // firstDate: isFrom ? now : (fromDate ?? now),
//   //     initialDate: validInitial,
//   //     firstDate: first,
//   //     lastDate: DateTime(2100),
//   //     initialEntryMode: DatePickerEntryMode.calendarOnly,
//   //     builder: (context, child) {
//   //       return Theme(
//   //         data: Theme.of(context).copyWith(
//   //           colorScheme: ColorScheme.light(
//   //             primary: ColorUtils.primary,
//   //             onPrimary: ColorUtils.white,
//   //             onSurface: ColorUtils.black,
//   //           ),
//   //           textButtonTheme: TextButtonThemeData(
//   //             style: TextButton.styleFrom(foregroundColor: ColorUtils.primary),
//   //           ),
//   //         ),
//   //         child: child!,
//   //       );
//   //     },
//   //   );
//   //
//   //   if (pickedDate != null) {
//   //     List<TimeOfDay> allTimes = List.generate(
//   //       24,
//   //       (index) => TimeOfDay(hour: index, minute: 0),
//   //     );
//   //     int minHour;
//   //
//   //     if (isFrom) {
//   //       minHour = (DateCompare(pickedDate).isSameDate(now)) ? now.hour + 1 : 0;
//   //     } else {
//   //       final from = fromDate;
//   //       minHour =
//   //           (DateCompare(pickedDate).isSameDate(from ?? now))
//   //               ? ((from ?? now).hour + 1)
//   //               : 0;
//   //     }
//   //
//   //     final currentDate = isFrom ? fromDate : toDate;
//   //     final selectedHour =
//   //         (currentDate != null &&
//   //                 DateCompare(pickedDate).isSameDate(currentDate))
//   //             ? currentDate.hour
//   //             : null;
//   //
//   //     // 🕒 Time Picker Dialog with Styled Slots
//   //     final pickedTime = await showDialog<TimeOfDay>(
//   //       context: Get.context!,
//   //       builder: (context) {
//   //         return AlertDialog(
//   //           title: CustomText(StringUtils.selectTime),
//   //           content: SizedBox(
//   //             width: double.maxFinite,
//   //             child: ListView.builder(
//   //               shrinkWrap: true,
//   //               itemCount: allTimes.length,
//   //               itemBuilder: (context, index) {
//   //                 TimeOfDay time = allTimes[index];
//   //                 bool isDisabled = time.hour < minHour;
//   //                 bool isSelected = selectedHour == time.hour;
//   //
//   //                 return IgnorePointer(
//   //                   ignoring: isDisabled,
//   //                   child: ListTile(
//   //                     title: CustomText(
//   //                       time.format(context),
//   //
//   //                       color:
//   //                           isSelected
//   //                               ? ColorUtils.primary
//   //                               : isDisabled
//   //                               ? Colors.grey
//   //                               : Colors.black,
//   //                       fontWeight:
//   //                           isSelected
//   //                               ? FontWeight.w700
//   //                               : isDisabled
//   //                               ? FontWeight.normal
//   //                               : FontWeight.w500,
//   //                       fontSize: isSelected ? 18 : 16,
//   //                     ),
//   //                     onTap:
//   //                         isDisabled
//   //                             ? null
//   //                             : () => Navigator.pop(context, time),
//   //                   ),
//   //                 );
//   //               },
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     );
//   //
//   //     if (pickedTime != null) {
//   //       DateTime finalDateTime = DateTime(
//   //         pickedDate.year,
//   //         pickedDate.month,
//   //         pickedDate.day,
//   //         pickedTime.hour,
//   //         pickedTime.minute,
//   //       );
//   //       print(
//   //         '---Final Picked DateTime (${isFrom ? 'From' : 'To'})--- $finalDateTime',
//   //       );
//   //       if (isFrom) {
//   //         fromDate = finalDateTime;
//   //         fromDateController.text = DateFormat(
//   //           'MMMM d, yyyy hh:mm a',
//   //         ).format(finalDateTime);
//   //
//   //         if (toDate != null &&
//   //             toDate!.isBefore(fromDate!.add(Duration(hours: 1)))) {
//   //           toDate = fromDate!.add(Duration(hours: 1));
//   //           toDateController.text = DateFormat(
//   //             'MMMM d, yyyy hh:mm a',
//   //           ).format(toDate!);
//   //         }
//   //       } else {
//   //         if (fromDate != null &&
//   //             finalDateTime.isBefore(fromDate!.add(Duration(hours: 1)))) {
//   //           showCustomSnackBar(message: StringUtils.dropOffMustBeOneHour);
//   //
//   //           return;
//   //         }
//   //
//   //         toDate = finalDateTime;
//   //         toDateController.text = DateFormat(
//   //           'MMMM d, yyyy hh:mm a',
//   //         ).format(finalDateTime);
//   //       }
//   //
//   //       context.read<BooingFormBloc>().add(BookingFormValidateFields());
//   //       context.read<BooingFormBloc>().add(CalculateBookingSummary());
//   //     }
//   //   }
//   // }
//
//   ///Working
//   // Future<void> pickDateTime(bool isFrom) async {
//   //   DateTime now = DateTime.now();
//   //   final bloc = context.read<BooingFormBloc>();
//   //   logs("----On PICK DATE TIME---${bloc.fromDate}");
//   //
//   //   final initial = isFrom ? bloc.fromDate : bloc.toDate;
//   //   /* isFrom
//   //           ? bloc.state.fromDate ?? now
//   //           : bloc.state.toDate ??
//   //               (bloc.state.fromDate ?? now).add(Duration(days: 1));*/
//   //
//   //   final first = isFrom ? now : (bloc.fromDate ?? now);
//   //   // final first = isFrom ? now : (bloc.state.fromDate ?? now);
//   //   final validInitial = initial.isBefore(first) ? first : initial;
//   //
//   //   final pickedDate = await showDatePicker(
//   //     context: context,
//   //     initialDate: validInitial,
//   //     firstDate: first,
//   //     lastDate: DateTime(2100),
//   //     initialEntryMode: DatePickerEntryMode.calendarOnly,
//   //     builder: (context, child) {
//   //       return Theme(
//   //         data: Theme.of(context).copyWith(
//   //           colorScheme: ColorScheme.light(
//   //             primary: ColorUtils.primary,
//   //             onPrimary: ColorUtils.white,
//   //             onSurface: ColorUtils.black,
//   //           ),
//   //           textButtonTheme: TextButtonThemeData(
//   //             style: TextButton.styleFrom(foregroundColor: ColorUtils.primary),
//   //           ),
//   //         ),
//   //         child: child!,
//   //       );
//   //     },
//   //   );
//   //
//   //   if (pickedDate != null) {
//   //     List<TimeOfDay> allTimes = List.generate(
//   //       24,
//   //       (index) => TimeOfDay(hour: index, minute: 0),
//   //     );
//   //
//   //     int minHour;
//   //     if (isFrom) {
//   //       minHour = DateCompare(pickedDate).isSameDate(now) ? now.hour + 1 : 0;
//   //     } else {
//   //       final from = bloc.fromDate;
//   //       minHour =
//   //           DateCompare(pickedDate).isSameDate(from ?? now)
//   //               ? (from ?? now).hour + 1
//   //               : 0;
//   //     }
//   //
//   //     final currentDate = isFrom ? bloc.fromDate : bloc.toDate;
//   //     final selectedHour =
//   //         (currentDate != null &&
//   //                 DateCompare(pickedDate).isSameDate(currentDate))
//   //             ? currentDate.hour
//   //             : null;
//   //
//   //     final pickedTime = await showDialog<TimeOfDay>(
//   //       context: context,
//   //       builder: (context) {
//   //         return AlertDialog(
//   //           title: CustomText(StringUtils.selectTime),
//   //           content: SizedBox(
//   //             width: double.maxFinite,
//   //             child: ListView.builder(
//   //               shrinkWrap: true,
//   //               itemCount: allTimes.length,
//   //               itemBuilder: (context, index) {
//   //                 TimeOfDay time = allTimes[index];
//   //                 bool isDisabled = time.hour < minHour;
//   //                 bool isSelected = selectedHour == time.hour;
//   //
//   //                 return IgnorePointer(
//   //                   ignoring: isDisabled,
//   //                   child: ListTile(
//   //                     title: CustomText(
//   //                       time.format(context),
//   //                       color:
//   //                           isSelected
//   //                               ? ColorUtils.primary
//   //                               : isDisabled
//   //                               ? Colors.grey
//   //                               : Colors.black,
//   //                       fontWeight:
//   //                           isSelected
//   //                               ? FontWeight.w700
//   //                               : isDisabled
//   //                               ? FontWeight.normal
//   //                               : FontWeight.w500,
//   //                       fontSize: isSelected ? 18 : 16,
//   //                     ),
//   //                     onTap:
//   //                         isDisabled
//   //                             ? null
//   //                             : () => Navigator.pop(context, time),
//   //                   ),
//   //                 );
//   //               },
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     );
//   //
//   //     if (pickedTime != null) {
//   //       DateTime finalDateTime = DateTime(
//   //         pickedDate.year,
//   //         pickedDate.month,
//   //         pickedDate.day,
//   //         pickedTime.hour,
//   //         pickedTime.minute,
//   //       );
//   //
//   //       print(
//   //         '---Final Picked DateTime (${isFrom ? 'From' : 'To'})--- $finalDateTime',
//   //       );
//   //
//   //       final formatted = DateFormat(
//   //         'MMMM d, yyyy hh:mm a',
//   //       ).format(finalDateTime);
//   //
//   //       if (isFrom) {
//   //         bloc.add(FromDateChanged(finalDateTime));
//   //         bloc.fromDateController.text = formatted;
//   //         bloc.fromDate = finalDateTime;
//   //
//   //         // Auto-adjust To Date if invalid
//   //         if (bloc.toDate != null &&
//   //             bloc.toDate!.isBefore(finalDateTime.add(Duration(hours: 1)))) {
//   //           final correctedTo = finalDateTime.add(Duration(hours: 1));
//   //           bloc.add(ToDateChanged(correctedTo));
//   //           bloc.toDateController.text = DateFormat(
//   //             'MMMM d, yyyy hh:mm a',
//   //           ).format(correctedTo);
//   //           bloc.toDate = correctedTo;
//   //         }
//   //       } else {
//   //         // Drop-off validation
//   //         if (bloc.fromDate != null &&
//   //             finalDateTime.isBefore(bloc.fromDate.add(Duration(hours: 1)))) {
//   //           showCustomSnackBar(message: StringUtils.dropOffMustBeOneHour);
//   //           return;
//   //         }
//   //
//   //         bloc.add(ToDateChanged(finalDateTime));
//   //         bloc.toDateController.text = formatted;
//   //         bloc.toDate = finalDateTime;
//   //       }
//   //
//   //       bloc.add(CalculateBookingSummary());
//   //       bloc.add(BookingFormValidateFields());
//   //     }
//   //   }
//   // }
//
//   Future<void> pickDateTime(bool isFrom) async {
//     final now = DateTime.now();
//     final bloc = context.read<BooingFormBloc>();
//
//     final selectedDate = isFrom ? bloc.fromDate : bloc.toDate;
//     final firstSelectableDate = isFrom ? now : (bloc.fromDate ?? now);
//     final initialDate =
//         (selectedDate.isBefore(firstSelectableDate) ?? true)
//             ? firstSelectableDate
//             : selectedDate;
//
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstSelectableDate,
//       lastDate: DateTime(2100),
//       initialEntryMode: DatePickerEntryMode.calendarOnly,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: _customDatePickerColorScheme,
//             textButtonTheme: _customTextButtonTheme,
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedDate == null) return;
//
//     final minHour = _getMinimumHour(isFrom, pickedDate, bloc, now);
//     final selectedHour = _getSelectedHour(isFrom, pickedDate, bloc);
//
//     final pickedTime = await _showHourPicker(
//       context: context,
//       pickedDate: pickedDate,
//       minHour: minHour,
//       selectedHour: selectedHour,
//     );
//
//     if (pickedTime == null) return;
//
//     final pickedDateTime = DateTime(
//       pickedDate.year,
//       pickedDate.month,
//       pickedDate.day,
//       pickedTime.hour,
//       pickedTime.minute,
//     );
//
//     final formatted = DateFormat('MMMM d, yyyy hh:mm a').format(pickedDateTime);
//
//     if (isFrom) {
//       _handleFromDate(bloc, pickedDateTime, formatted);
//     } else {
//       _handleToDate(bloc, pickedDateTime, formatted);
//     }
//
//     bloc.add(BookingFormValidateFields());
//     bloc.add(CalculateBookingSummary());
//   }
//
//   void _handleFromDate(
//     BooingFormBloc bloc,
//     DateTime pickedDateTime,
//     String formatted,
//   ) {
//     bloc.add(FromDateChanged(pickedDateTime));
//     bloc.fromDate = pickedDateTime;
//     bloc.fromDateController.text = formatted;
//
//     if (bloc.toDate != null &&
//         bloc.toDate!.isBefore(pickedDateTime.add(Duration(hours: 1)))) {
//       final correctedTo = pickedDateTime.add(Duration(hours: 1));
//       bloc.add(ToDateChanged(correctedTo));
//       bloc.toDate = correctedTo;
//       bloc.toDateController.text = DateFormat(
//         'MMMM d, yyyy hh:mm a',
//       ).format(correctedTo);
//     }
//   }
//
//   void _handleToDate(
//     BooingFormBloc bloc,
//     DateTime pickedDateTime,
//     String formatted,
//   ) {
//     if (bloc.fromDate != null &&
//         pickedDateTime.isBefore(bloc.fromDate!.add(Duration(hours: 1)))) {
//       showCustomSnackBar(message: StringUtils.dropOffMustBeOneHour);
//       return;
//     }
//
//     bloc.add(ToDateChanged(pickedDateTime));
//     bloc.toDate = pickedDateTime;
//     bloc.toDateController.text = formatted;
//   }
//
//   final _customDatePickerColorScheme = ColorScheme.light(
//     primary: ColorUtils.primary,
//     onPrimary: ColorUtils.white,
//     onSurface: ColorUtils.black,
//   );
//
//   final _customTextButtonTheme = TextButtonThemeData(
//     style: TextButton.styleFrom(foregroundColor: ColorUtils.primary),
//   );
//
//   int _getMinimumHour(
//     bool isFrom,
//     DateTime pickedDate,
//     BooingFormBloc bloc,
//     DateTime now,
//   ) {
//     if (isFrom) {
//       return DateCompare(pickedDate).isSameDate(now) ? now.hour + 1 : 0;
//     } else {
//       final from = bloc.fromDate ?? now;
//       return DateCompare(pickedDate).isSameDate(from) ? from.hour + 1 : 0;
//     }
//   }
//
//   int? _getSelectedHour(bool isFrom, DateTime pickedDate, BooingFormBloc bloc) {
//     final selectedDate = isFrom ? bloc.fromDate : bloc.toDate;
//     if (selectedDate != null &&
//         DateCompare(pickedDate).isSameDate(selectedDate)) {
//       return selectedDate.hour;
//     }
//     return null;
//   }
//
//   Future<TimeOfDay?> _showHourPicker({
//     required BuildContext context,
//     required DateTime pickedDate,
//     required int minHour,
//     int? selectedHour,
//   }) async {
//     final hours = List<TimeOfDay>.generate(
//       24,
//       (index) => TimeOfDay(hour: index, minute: 0),
//     );
//
//     return showDialog<TimeOfDay>(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return AlertDialog(
//           title: CustomText(StringUtils.selectTime),
//           content: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxHeight:
//                   MediaQuery.of(context).size.height *
//                   0.6, // ✅ Responsive height
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children:
//                     hours.map((time) {
//                       final isDisabled = time.hour < minHour;
//                       final isSelected = selectedHour == time.hour;
//
//                       return IgnorePointer(
//                         ignoring: isDisabled,
//                         child: ListTile(
//                           title: CustomText(
//                             time.format(context),
//                             color:
//                                 isSelected
//                                     ? ColorUtils.primary
//                                     : isDisabled
//                                     ? Colors.grey
//                                     : Colors.black,
//                             fontWeight:
//                                 isSelected
//                                     ? FontWeight.w700
//                                     : isDisabled
//                                     ? FontWeight.normal
//                                     : FontWeight.w500,
//                             fontSize: isSelected ? 18 : 16,
//                           ),
//                           onTap:
//                               isDisabled
//                                   ? null
//                                   : () => Navigator.pop(context, time),
//                         ),
//                       );
//                     }).toList(),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _sectionHeader(String title) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: CustomText(
//         title,
//         fontWeight: FontWeight.w600,
//         color: Colors.grey.shade600,
//       ),
//     );
//   }
//
//   bool isBookingOverlapping(
//     DateTime newStart,
//     DateTime newEnd,
//     List<BookingModel> existingBookings,
//   ) {
//     for (final booking in existingBookings) {
//       final DateTime start = DateTime(
//         booking.pickupDate.year,
//         booking.pickupDate.month,
//         booking.pickupDate.day,
//         DateFormat('hh:mm a').parse(booking.pickupTime).hour,
//       );
//
//       final DateTime end = DateTime(
//         booking.dropoffDate.year,
//         booking.dropoffDate.month,
//         booking.dropoffDate.day,
//         DateFormat('hh:mm a').parse(booking.dropoffTime).hour,
//       );
//
//       if (newStart.isBefore(end) && newEnd.isAfter(start)) {
//         // Overlap exists
//         showCustomSnackBar(
//           message:
//               "Dates occupied from ${DateFormat('d MMM, hh:mm a').format(start)} "
//               "to ${DateFormat('d MMM, hh:mm a').format(end)}",
//         );
//         return true;
//       }
//     }
//     return false;
//   }
//
//   void showBookingConfirmationDialog() {
//     if (context.read<BooingFormBloc>().fromDate == null ||
//         context.read<BooingFormBloc>().toDate == null) {
//       showCustomSnackBar(message: StringUtils.pleaseSelectBothTheDates);
//       return;
//     }
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return BlocBuilder<BooingFormBloc, BookingFormState>(
//           builder: (context, state) {
//             final bikeName = bike.brandName ?? "N/A";
//             final bikeModel = bike.model ?? "N/A";
//
//             final from = context.read<BooingFormBloc>().fromDate;
//             final to = context.read<BooingFormBloc>().toDate;
//             final duration = to.difference(from);
//             final durationInDays = duration.inHours / 24;
//
//             // Format helper
//             String formatAmount(double amount) {
//               return amount % 1 == 0
//                   ? amount.toInt().toString()
//                   : amount.toStringAsFixed(2);
//             }
//
//             logs("---from---$from");
//             logs("---to---$to");
//
//             logs(
//               "---INSIDE context.read<BooingFormBloc>().subtotal---${state.subtotal}",
//             );
//             return AlertDialog(
//               title: CustomText(
//                 StringUtils.confirmBooking,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18.sp,
//               ),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildInfoRow(
//                       "${StringUtils.bike}:",
//                       "$bikeName ($bikeModel)",
//                     ),
//                     _buildInfoRow(
//                       "${StringUtils.from}:",
//                       DateFormat('MMMM d, yyyy hh:mm a').format(from),
//                     ),
//                     _buildInfoRow(
//                       "${StringUtils.to}:",
//                       DateFormat('MMMM d, yyyy hh:mm a').format(to),
//                     ),
//                     _buildInfoRow(
//                       "${StringUtils.duration}:",
//                       "${duration.inHours} ${StringUtils.hours} (${durationInDays.toStringAsFixed(1)} ${StringUtils.days})",
//                     ),
//                     _buildInfoRow(
//                       "${StringUtils.totalRent}:",
//                       "\$ ${formatAmount(context.read<BooingFormBloc>().subtotal)}",
//                     ),
//                     _buildInfoRow(
//                       "${StringUtils.discount}:",
//                       "\$ ${formatAmount(context.read<BooingFormBloc>().discount)}",
//                     ),
//                     _buildInfoRow(
//                       "${StringUtils.tax}:",
//                       "${formatAmount(context.read<BooingFormBloc>().taxAmount)}%",
//                     ),
//                     _buildInfoRow(
//                       "${StringUtils.totalAmount}: ",
//                       "\$ ${formatAmount(context.read<BooingFormBloc>().grandTotal)}",
//                     ),
//                     _buildInfoRow(
//                       "${StringUtils.prepayment}: ",
//                       "\$ ${formatAmount(context.read<BooingFormBloc>().prepayment)}",
//                     ),
//                     _buildInfoRow(
//                       "${StringUtils.balance}: ",
//                       "\$ ${formatAmount(context.read<BooingFormBloc>().balance)}",
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomBtn(
//                         bgColor: ColorUtils.white,
//                         onTap: () => Navigator.pop(context),
//                         title: StringUtils.cancel,
//                         textColor: ColorUtils.black,
//                       ),
//                     ),
//                     SizedBox(width: 15.w),
//                     // Expanded(
//                     //   child: CustomBtn(
//                     //     onTap: () async {
//                     //       final pickupDate = DateTime(
//                     //         from.year,
//                     //         from.month,
//                     //         from.day,
//                     //       );
//                     //       final dropOffDate = DateTime(
//                     //         to.year,
//                     //         to.month,
//                     //         to.day,
//                     //       );
//                     //       final pickupTime = DateFormat('hh:mm a').format(from);
//                     //       final dropOffTime = DateFormat('hh:mm a').format(to);
//                     //       final bookBikeBloc = context.read<BookBikeBloc>();
//                     //
//                     //       final newBooking = BookingModel(
//                     //         // id: isEditing ? existingBookingId : null,
//                     //         userId: 1,
//                     //         bikeId: bike.id ?? 0,
//                     //         bikeName: bike.brandName ?? "",
//                     //         bikeModel: bike.model ?? "",
//                     //         userFullName:
//                     //             context
//                     //                 .read<BooingFormBloc>()
//                     //                 .fullNameController
//                     //                 .text,
//                     //         userPhone:
//                     //             context
//                     //                 .read<BooingFormBloc>()
//                     //                 .phoneController
//                     //                 .text,
//                     //         userEmail:
//                     //             context
//                     //                 .read<BooingFormBloc>()
//                     //                 .emailController
//                     //                 .text,
//                     //         pickupDate: pickupDate,
//                     //         dropoffDate: dropOffDate,
//                     //         pickupTime: pickupTime,
//                     //         dropoffTime: dropOffTime,
//                     //         typeOfPayment: 'Cash',
//                     //         rentPerDay:
//                     //             double.tryParse(
//                     //               context
//                     //                   .read<BooingFormBloc>()
//                     //                   .rentController
//                     //                   .text
//                     //                   .trim(),
//                     //             ) ??
//                     //             0,
//                     //         mileage:
//                     //             num.tryParse(
//                     //               context
//                     //                   .read<BooingFormBloc>()
//                     //                   .mileageController
//                     //                   .text
//                     //                   .trim(),
//                     //             ) ??
//                     //             0,
//                     //         extraPerKm:
//                     //             double.tryParse(
//                     //               context
//                     //                   .read<BooingFormBloc>()
//                     //                   .extraPerKmController
//                     //                   .text
//                     //                   .trim(),
//                     //             ) ??
//                     //             0,
//                     //         securityDeposit:
//                     //             double.tryParse(
//                     //               context
//                     //                   .read<BooingFormBloc>()
//                     //                   .depositController
//                     //                   .text
//                     //                   .trim(),
//                     //             ) ??
//                     //             0,
//                     //         subtotal: context.read<BooingFormBloc>().subtotal,
//                     //         balance: context.read<BooingFormBloc>().balance,
//                     //         durationInHours: duration.inHours.toDouble(),
//                     //         totalRent: context.read<BooingFormBloc>().subtotal,
//                     //         finalAmountPayable:
//                     //             context.read<BooingFormBloc>().grandTotal,
//                     //         discount: context.read<BooingFormBloc>().discount,
//                     //         tax: context.read<BooingFormBloc>().tax,
//                     //         prepayment:
//                     //             context.read<BooingFormBloc>().prepayment,
//                     //         bikes: [bike],
//                     //         createdAt: DateTime.now(),
//                     //       );
//                     //       if (booking == null) {
//                     //         logs("----Adding");
//                     //         bookBikeBloc.add(AddBookingEvent(newBooking));
//                     //       }
//                     //       //
//                     //       else {
//                     //         logs("----Updating");
//                     //         final today = DateTime.now();
//                     //         final nowDateOnly = DateTime(
//                     //           today.year,
//                     //           today.month,
//                     //           today.day,
//                     //         );
//                     //
//                     //         final isPickupPastOrToday =
//                     //             DateTime(
//                     //               from.year,
//                     //               from.month,
//                     //               from.day,
//                     //             ).isBefore(nowDateOnly) ||
//                     //             DateTime(
//                     //               from.year,
//                     //               from.month,
//                     //               from.day,
//                     //             ).isAtSameMomentAs(nowDateOnly);
//                     //
//                     //         final isDropoffPastOrToday =
//                     //             DateTime(
//                     //               to.year,
//                     //               to.month,
//                     //               to.day,
//                     //             ).isBefore(nowDateOnly) ||
//                     //             DateTime(
//                     //               to.year,
//                     //               to.month,
//                     //               to.day,
//                     //             ).isAtSameMomentAs(nowDateOnly);
//                     //
//                     //         if (booking != null &&
//                     //             (isPickupPastOrToday || isDropoffPastOrToday)) {
//                     //           showCustomSnackBar(
//                     //             message:
//                     //                 StringUtils.youCannotUpdateCurrentBooking,
//                     //             isError: true,
//                     //           );
//                     //           return;
//                     //         }
//                     //
//                     //         newBooking.id = booking?.id ?? 0;
//                     //         bookBikeBloc.add(UpdateBookingEvent(newBooking));
//                     //       }
//                     //
//                     //       bookBikeBloc.add(FetchBookingsEvent());
//                     //
//                     //       Get.back(); // Close dialog
//                     //       Get.back(); // Go back to previous screen
//                     //       showCustomSnackBar(
//                     //         message:
//                     //             booking != null
//                     //                 ? StringUtils.bookingUpdatedSuccessfully
//                     //                 : StringUtils.bikeBookedSuccessfully,
//                     //       );
//                     //     },
//                     //     title: StringUtils.confirm,
//                     //   ),
//                     // ),
//                     Expanded(
//                       child: CustomBtn(
//                         onTap: () {
//                           context.read<BooingFormBloc>().add(
//                             BookingFormSubmitted(
//                               bike: bike,
//                               existingBooking: booking,
//                               bookBikeBloc: context.read<BookBikeBloc>(),
//                             ),
//                           );
//                         },
//                         title: StringUtils.confirm,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildInfoRow(
//     String title,
//     String value, {
//     Color? valueColor,
//     bool isBold = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(child: CustomText(title, fontWeight: FontWeight.w600)),
//           Expanded(
//             child: CustomText(
//               value,
//               color: valueColor,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     void Function(String)? onChange,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 2.h),
//       child: CommonTextField(
//         textEditController: controller,
//         labelText: label,
//         keyBoardType: keyboardType,
//         onChange: onChange,
//         validator:
//             (value) => value!.isEmpty ? '${StringUtils.enter} $label' : null,
//       ),
//     );
//   }
// }
