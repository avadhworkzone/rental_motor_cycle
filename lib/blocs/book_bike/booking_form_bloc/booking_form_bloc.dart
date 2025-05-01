// ignore_for_file: unused_import, invalid_use_of_visible_for_testing_member, unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_bloc.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_event.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_form_bloc/bike_form_event.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_form_bloc/bike_form_state.dart';
import 'package:rental_motor_cycle/blocs/book_bike/book_bike_home_bloc/book_bike_bloc.dart';
import 'package:rental_motor_cycle/blocs/book_bike/book_bike_home_bloc/book_bike_event.dart';
import 'package:rental_motor_cycle/blocs/book_bike/booking_form_bloc/booking_form_event.dart';
import 'package:rental_motor_cycle/blocs/book_bike/booking_form_bloc/booking_form_state.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/const_utils.dart';
import 'package:rental_motor_cycle/utils/date_picker_utils.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';

extension DateCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class BooingFormBloc extends Bloc<BookingFormEvent, BookingFormState> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController prePaymentController = TextEditingController();
  final fullNameController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController extraPerKmController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

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

  String formatNum(num? value) {
    if (value == null) return '';
    if (value is int || value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }

  String formatDoubleOrInt(double? value) {
    if (value == null) return '';
    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2); // Or .toString() if you want raw decimal
    }
  }

  BooingFormBloc({BookingModel? booking, required bikeBloc})
    : super(
        (booking != null
            ? BookingFormState(
              emailController: booking.userEmail,
              fullNameController: booking.userFullName,
              isValid: true,
              phoneController: booking.userPhone,
              fromDateController: DateFormat(
                'yyyy-MM-dd',
              ).format(booking.pickupDate),
              toDateController: DateFormat(
                'yyyy-MM-dd',
              ).format(booking.dropoffDate),
              fromDate: booking.pickupDate,
              toDate: booking.dropoffDate,
              balance: booking.balance,
              depositController: booking.securityDeposit,
              discount: booking.discount,
              extraPerKmController: booking.extraPerKm,
              grandTotal: booking.finalAmountPayable,
              mileageController: booking.mileage.toString(),
              prePaymentController: booking.securityDeposit.toString(),
              rentController: booking.rentPerDay,
              subtotal: booking.subtotal,
              taxController: booking.tax.toString(),
              typeOfPayment: booking.typeOfPayment,
            )
            : BookingFormState.initial()),
      ) {
    if (booking != null) {
      fullNameController.text = booking.userFullName;
      phoneController.text = booking.userPhone;
      emailController.text = booking.userEmail;
      mileageController.text = formatNum(booking.mileage);
      rentController.text = formatDoubleOrInt(booking.rentPerDay);
      extraPerKmController.text = formatDoubleOrInt(booking.extraPerKm);
      depositController.text = formatDoubleOrInt(booking.securityDeposit);
      discountController.text = formatDoubleOrInt(booking.discount);
      taxController.text = formatDoubleOrInt(booking.tax);
      prePaymentController.text = formatDoubleOrInt(booking.prepayment);
      logs("---INSIDE IF booking.pickupDate----${booking.pickupDate}");
      fromDate = booking.pickupDate;
      toDate = booking.dropoffDate;
      final pickup = booking.pickupDate;
      fromDateController.text = DateFormat(
        'MMMM d, yyyy hh:mm a',
      ).format(pickup);
      final dropOff = booking.dropoffDate;
      toDateController.text = DateFormat(
        'MMMM d, yyyy hh:mm a',
      ).format(dropOff);
      emit(
        state.copyWith(
          // taxController: booking.tax.toString(),
          balance: booking.balance,
          subtotal: booking.subtotal,
          discount: booking.discount,
          fromDate: booking.pickupDate,
          toDate: booking.dropoffDate,
          // depositController: booking.securityDeposit,
          // emailController: booking.userEmail,
          // extraPerKmController: booking.extraPerKm,
          // fullNameController: booking.userFullName,
          // phoneController: booking.userPhone,
          // mileageController: booking.mileage.toString(),
          // rentController: booking.rentPerDay,
          typeOfPayment: booking.typeOfPayment,
          // prePaymentController: booking.prepayment.toString(),
          grandTotal: booking.finalAmountPayable,
        ),
      );
    }

    on<InitializeBookingsForm>(_onInit);
    on<BookingFormValidateFields>((event, emit) {
      logs("✅ VALIDATE fromDate: $fromDate");
      logs("✅ VALIDATE toDate: $toDate");
      final isValid = _validateForm(); // A method you'll define below
      emit(state.copyWith(isValid: isValid));
    });
    on<CalculateBookingSummary>(_onCalculateSummary);
    // on<PickDateTimeEvent>((event, emit) async {});
    on<FromDateChanged>((event, emit) {
      fromDate = event.fromDate;
      logs("---On FromDateChanged event.fromDate----${event.fromDate}");
      emit(state.copyWith(fromDate: event.fromDate));
    });

    on<ToDateChanged>((event, emit) {
      toDate = event.toDate;
      emit(state.copyWith(toDate: event.toDate));
    });
    on<BookingFormSubmitted>((event, emit) async {
      emit(state.copyWith(isProcessing: true));

      try {
        final bike = event.bike;
        final from = state.fromDate!;
        final to = state.toDate!;
        final duration = to.difference(from);

        final pickupDate = DateTime(from.year, from.month, from.day);
        final dropOffDate = DateTime(to.year, to.month, to.day);
        final pickupTime = DateFormat('hh:mm a').format(from);
        final dropOffTime = DateFormat('hh:mm a').format(to);

        final booking = BookingModel(
          id: event.existingBooking?.id,
          userId: 1,
          bikeId: bike.id ?? 0,
          bikeName: bike.brandName ?? "",
          bikeModel: bike.model ?? "",
          userFullName: state.fullNameController,
          userPhone: state.phoneController ?? "",
          userEmail: state.emailController ?? "",
          pickupDate: pickupDate,
          dropoffDate: dropOffDate,
          pickupTime: pickupTime,
          dropoffTime: dropOffTime,
          typeOfPayment: 'Cash',
          rentPerDay: state.rentController ?? 0,
          mileage: num.tryParse(state.mileageController ?? "") ?? 0,
          extraPerKm: state.extraPerKmController ?? 0,
          securityDeposit: state.depositController ?? 0,
          subtotal: state.subtotal ?? 0,
          balance: state.balance ?? 0,
          durationInHours: duration.inHours.toDouble(),
          totalRent: state.subtotal ?? 0,
          finalAmountPayable: state.grandTotal ?? 0,
          discount: state.discount ?? 0,
          tax: double.tryParse(state.taxController ?? "") ?? 0,
          prepayment: double.tryParse(state.prePaymentController ?? "") ?? 0,
          bikes: [bike],
          createdAt: DateTime.now(),
        );

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final isPastOrToday =
            (DateTime(
                  pickupDate.year,
                  pickupDate.month,
                  pickupDate.day,
                ).isBefore(today) ||
                DateTime(
                  pickupDate.year,
                  pickupDate.month,
                  pickupDate.day,
                ).isAtSameMomentAs(today)) ||
            (DateTime(
                  dropOffDate.year,
                  dropOffDate.month,
                  dropOffDate.day,
                ).isBefore(today) ||
                DateTime(
                  dropOffDate.year,
                  dropOffDate.month,
                  dropOffDate.day,
                ).isAtSameMomentAs(today));
        final bookBikeBloc = event.bookBikeBloc;

        if (event.existingBooking == null) {
          bookBikeBloc.add(AddBookingEvent(booking));
        } else {
          if (isPastOrToday) {
            showCustomSnackBar(
              message: StringUtils.youCannotUpdateCurrentBooking,
              isError: true,
            );
            emit(state.copyWith(isProcessing: false));
            return;
          }
          bookBikeBloc.add(UpdateBookingEvent(booking));
        }

        bookBikeBloc.add(FetchBookingsEvent());

        emit(state.copyWith(isProcessing: false));
        Get.back();
        Get.back();
        showCustomSnackBar(
          message:
              event.existingBooking == null
                  ? StringUtils.bikeBookedSuccessfully
                  : StringUtils.bookingUpdatedSuccessfully,
        );
      } catch (e) {
        logs("Error in booking submission: $e");
        emit(state.copyWith(isProcessing: false));
      }
    });

    // on<BookingFormSubmitted>((event, emit) async {
    //   emit(state.copyWith(isProcessing: true));
    //
    //   try {
    //     final userId = await SharedPreferenceUtils.getString(
    //       SharedPreferenceUtils.userId,
    //     );
    //
    //     final newBike = BikeModel(
    //       id: event.existingBike?.id,
    //       brandName: state.selectedBrand,
    //       model: state.selectedModel,
    //       numberPlate: numberPlateController.text.trim(),
    //       location: locationController.text.trim(),
    //       fuelType: fuelTypeController.text.trim(),
    //       engineCC: num.parse(ccController.text.trim()),
    //       description: descriptionController.text.trim(),
    //       imageUrl: state.imageFile?.path ?? '',
    //       createdAt: DateTime.now(),
    //       userId: int.parse(userId),
    //       kmLimit: double.parse(kmLimitController.text.trim()),
    //       makeYear: int.parse(makeYearController.text.trim()),
    //       transmission: state.selectedTransmission!,
    //       seater: int.parse(state.selectedSeater!),
    //       fuelIncluded: state.selectedFuelIncluded!,
    //     );
    //
    //     // If editing and no changes made
    //     if (event.existingBike != null && event.existingBike == newBike) {
    //       showCustomSnackBar(
    //         message: StringUtils.pleaseChangeTheDataBeforeSaving,
    //       );
    //       emit(state.copyWith(isProcessing: false));
    //       return;
    //     }
    //
    //     if (event.existingBike == null) {
    //       bikeBloc.add(AddBikeEvent(newBike));
    //     } else {
    //       bikeBloc.add(UpdateBikeEvent(newBike));
    //     }
    //
    //     bikeBloc.add(FetchBikesEvent());
    //     emit(state.copyWith(isProcessing: false));
    //
    //     Get.back();
    //     showCustomSnackBar(message: StringUtils.bikeAddedSuccessfully);
    //   } catch (e) {
    //     logs("Error submitting form: ${e.toString()}");
    //     emit(state.copyWith(isProcessing: false));
    //   }
    // });
  }
  bool _validateForm() {
    final fromValid = fromDate != null;
    final toValid = toDate != null;
    final fullNameValid = fullNameController.text.trim().isNotEmpty;
    final phoneValid = phoneController.text.trim().isNotEmpty;
    final extraPerKmValid = extraPerKmController.text.trim().isNotEmpty;
    final depositValid = depositController.text.trim().isNotEmpty;
    final mileageValid = mileageController.text.trim().isNotEmpty;
    final rentValid = rentController.text.trim().isNotEmpty;
    final emailValid = emailController.text.trim().isNotEmpty;

    // logs(
    //   "📅 fromDateController: ${fromDateController.text} => ${fromValid ? '✅' : '❌'}",
    // );
    // logs(
    //   "📅 toDateController: ${toDateController.text} => ${toValid ? '✅' : '❌'}",
    // );
    // logs(
    //   "🧍 Full Name: '${fullNameController.text}' => ${fullNameValid ? '✅' : '❌'}",
    // );
    // logs("📞 Phone: '${phoneController.text}' => ${phoneValid ? '✅' : '❌'}");
    // logs(
    //   "🛵 Extra per Km: '${extraPerKmController.text}' => ${extraPerKmValid ? '✅' : '❌'}",
    // );
    // logs(
    //   "💰 Deposit: '${depositController.text}' => ${depositValid ? '✅' : '❌'}",
    // );
    // logs(
    //   "📏 Mileage: '${mileageController.text}' => ${mileageValid ? '✅' : '❌'}",
    // );
    // logs("💸 Rent: '${rentController.text}' => ${rentValid ? '✅' : '❌'}");
    // logs("✉️ Email: '${emailController.text}' => ${emailValid ? '✅' : '❌'}");
    isValid =
        fromValid &&
        toValid &&
        fullNameValid &&
        phoneValid &&
        extraPerKmValid &&
        depositValid &&
        mileageValid &&
        rentValid &&
        emailValid;
    return isValid;
  }

  void _onCalculateSummary(
    CalculateBookingSummary event,
    Emitter<BookingFormState> emit,
  ) {
    logs("---ON calculate Summury---$fromDate");
    if (fromDate == null || toDate == null) {
      logs("❌ Cannot calculate summary. From or To date is null.");
      return;
    }

    final fromDateOnly = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final toDateOnly = DateTime(toDate.year, toDate.month, toDate.day);
    final numberOfDays = toDateOnly.difference(fromDateOnly).inDays + 1;

    double rentPerDay = double.tryParse(rentController.text) ?? 0;
    double discountVal = double.tryParse(discountController.text) ?? 0;
    double taxPercent = double.tryParse(taxController.text) ?? 0;
    double prepayment = double.tryParse(prePaymentController.text) ?? 0;
    double deposit = double.tryParse(depositController.text) ?? 0;

    final rentWithoutDiscount = rentPerDay * numberOfDays;

    // Discount > total guard
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
    tax = taxPercent;
    this.prepayment = prepayment;
    depositAmount = deposit;

    emit(
      state.copyWith(
        rentController: rentPerDay,
        subtotal: subtotal,
        discount: discountVal,
        taxController: taxPercent.toString(),
        taxAmount: taxAmount,
        grandTotal: grandTotal,
        prePaymentController: prepayment.toString(),
        balance: balance,
        depositController: deposit,
      ),
    );
  }

  void _onInit(InitializeBookingsForm event, Emitter<BookingFormState> emit) {
    final booking = event.booking;
    if (booking != null) {
      emit(
        state.copyWith(
          balance: booking.balance,
          subtotal: booking.subtotal,
          discount: booking.discount,
          fromDate: booking.pickupDate,
          toDate: booking.dropoffDate,
          typeOfPayment: booking.typeOfPayment,
          grandTotal: booking.finalAmountPayable,
        ),
      );
    }
  }

  /*  void _onCalculateSummary(
    CalculateBookingSummary event,
    Emitter<BookingFormState> emit,
  ) {
    DateTime? fromDateParsed, toDateParsed;

    // Get dates directly from the BLoC state, not the controller
    fromDateParsed = fromDate;
    toDateParsed = toDate;
    // fromDateParsed = DateTime.parse(fromDateController.text);
    // toDateParsed = DateTime.parse(toDateController.text);
    logs("---fromDate----${fromDate}");
    logs("---toDate----${toDate}");
    logs("---fromDateController----${fromDateController.text}");
    logs("---toDateController----${toDateController.text}");

    if (fromDateParsed == null || toDateParsed == null) {
      logs("❌ Cannot calculate summary. From or To date is null.");
      return;
    }

    logs("✅ Parsed From: $fromDateParsed");
    logs("✅ Parsed To: $toDateParsed");

    // If toDate is before fromDate, we can't calculate summary
    if (toDateParsed.isBefore(fromDateParsed)) {
      return;
    }

    // Ignore time - use only date
    final fromDateOnly = DateTime(
      fromDateParsed.year,
      fromDateParsed.month,
      fromDateParsed.day,
    );
    final toDateOnly = DateTime(
      toDateParsed.year,
      toDateParsed.month,
      toDateParsed.day,
    );
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
    tax = taxPercent;
    this.prepayment = prepayment;
    depositAmount = deposit;
    logs("--📅 Days Selected (based on date only): $numberOfDays");
    logs("--💰 Rent Per Day: $rentPerDay");
    logs("--🧮 Rent Without Discount: $rentWithoutDiscount");
    logs("--🎁 Discount: $discountVal");
    logs("--💸 Tax Percent: $taxPercent");
    logs("--🪙 Prepayment: $prepayment");
    logs("--🔐 Deposit: $deposit");
    logs("--📊 Subtotal: ${subtotal}");
    logs("--🧾 Tax Amount: ${taxAmount}");
    logs("--💳 Grand Total: ${grandTotal}");
    logs("--🧮 Balance: ${balance}");
    // If you want, emit new state values too:
    emit(
      state.copyWith(
        rentController: rentPerDay,
        subtotal: subtotal,
        discount: discountVal,
        taxController: taxPercent.toString(),
        taxAmount: taxAmount,
        grandTotal: grandTotal,
        prePaymentController: prepayment.toString(),
        balance: balance,
        depositController: deposit,
      ),
    );
  }*/

  // bool _validateForm() {
  //   return fromDate  != null &&
  //       toDate  != null &&
  //       fullNameController.text.trim().isNotEmpty &&
  //       phoneController.text.trim().isNotEmpty &&
  //       extraPerKmController.text.trim().isNotEmpty &&
  //       depositController.text.trim().isNotEmpty &&
  //       mileageController.text.trim().isNotEmpty &&
  //       rentController.text.trim().isNotEmpty &&
  //       emailController.text.trim().isNotEmpty;
  // }
}
