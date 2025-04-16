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
              emailController: booking.userEmail ?? "",
              fullNameController: booking.userFullName ?? "",
              isValid: true,
              phoneController: booking.userPhone ?? "",
              fromDateController: DateFormat(
                'yyyy-MM-dd',
              ).format(booking.pickupDate),
              toDateController: DateFormat(
                'yyyy-MM-dd',
              ).format(booking.dropoffDate),
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
      fullNameController.text = booking.userFullName ?? '';
      phoneController.text = booking.userPhone ?? '';
      emailController.text = booking.userEmail ?? '';
      mileageController.text = formatNum(booking.mileage);
      rentController.text = formatDoubleOrInt(booking.rentPerDay);
      extraPerKmController.text = formatDoubleOrInt(booking.extraPerKm);
      depositController.text = formatDoubleOrInt(booking.securityDeposit);
      discountController.text = formatDoubleOrInt(booking.discount);
      taxController.text = formatDoubleOrInt(booking.tax);
      prePaymentController.text = formatDoubleOrInt(booking.prepayment);
      fromDate.value = booking.pickupDate;
      toDate.value = booking.dropoffDate;
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

    on<InitializeBookingForm>(_onInit);
    on<BookingFormValidateFields>((event, emit) {
      final isValid = _validateForm(); // A method you'll define below
      emit(state.copyWith(isValid: isValid));
    });
    on<CalculateBookingSummary>(_onCalculateSummary);
    on<PickDateTimeEvent>((event, emit) async {});
    on<FromDateChanged>((event, emit) {
      emit(state.copyWith(fromDate: event.fromDate));
    });

    on<ToDateChanged>((event, emit) {
      emit(state.copyWith(toDate: event.toDate));
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
    final fromValid = fromDate.value != null;
    final toValid = toDate.value != null;
    final fullNameValid = fullNameController.text.trim().isNotEmpty;
    final phoneValid = phoneController.text.trim().isNotEmpty;
    final extraPerKmValid = extraPerKmController.text.trim().isNotEmpty;
    final depositValid = depositController.text.trim().isNotEmpty;
    final mileageValid = mileageController.text.trim().isNotEmpty;
    final rentValid = rentController.text.trim().isNotEmpty;
    final emailValid = emailController.text.trim().isNotEmpty;

    logs("📅 fromDate: ${fromDate.value} => ${fromValid ? '✅' : '❌'}");
    logs("📅 toDate: ${toDate.value} => ${toValid ? '✅' : '❌'}");
    logs(
      "🧍 Full Name: '${fullNameController.text}' => ${fullNameValid ? '✅' : '❌'}",
    );
    logs("📞 Phone: '${phoneController.text}' => ${phoneValid ? '✅' : '❌'}");
    logs(
      "🛵 Extra per Km: '${extraPerKmController.text}' => ${extraPerKmValid ? '✅' : '❌'}",
    );
    logs(
      "💰 Deposit: '${depositController.text}' => ${depositValid ? '✅' : '❌'}",
    );
    logs(
      "📏 Mileage: '${mileageController.text}' => ${mileageValid ? '✅' : '❌'}",
    );
    logs("💸 Rent: '${rentController.text}' => ${rentValid ? '✅' : '❌'}");
    logs("✉️ Email: '${emailController.text}' => ${emailValid ? '✅' : '❌'}");

    return fromValid &&
        toValid &&
        fullNameValid &&
        phoneValid &&
        extraPerKmValid &&
        depositValid &&
        mileageValid &&
        rentValid &&
        emailValid;
  }

  // bool _validateForm() {
  //   return fromDate.value != null &&
  //       toDate.value != null &&
  //       fullNameController.text.trim().isNotEmpty &&
  //       phoneController.text.trim().isNotEmpty &&
  //       extraPerKmController.text.trim().isNotEmpty &&
  //       depositController.text.trim().isNotEmpty &&
  //       mileageController.text.trim().isNotEmpty &&
  //       rentController.text.trim().isNotEmpty &&
  //       emailController.text.trim().isNotEmpty;
  // }

  void _onCalculateSummary(
    CalculateBookingSummary event,
    Emitter<BookingFormState> emit,
  ) {
    DateTime? fromDateParsed, toDateParsed;
    final fromText = fromDateController.text.trim();
    final toText = toDateController.text.trim();
    logs("---fromText----${fromText}");
    logs("---toText----${toText}");
    if (fromText.isEmpty || toText.isEmpty) {
      logs("❌ Cannot calculate summary. From or To date is empty.");
      return;
    }
    try {
      final format = DateFormat('MMMM d, yyyy hh:mm a');
      logs("📅 From: ${fromDateController.text}");
      logs("📅 To: ${toDateController.text}");

      fromDateParsed = format.parse(fromText);
      toDateParsed = format.parse(toText);
    } catch (e) {
      logs("❌ Error parsing date: $e");
      return;
    }
    logs("✅ Parsed From: $fromDateParsed");
    logs("✅ Parsed To: $toDateParsed");
    // ✅ STORE these values in the bloc state
    this.fromDate.value = fromDateParsed;
    this.toDate.value = toDateParsed;
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

    subtotal.value = rentWithoutDiscount;
    discount.value = discountVal;
    taxAmount.value = (subtotal.value - discount.value) * (taxPercent / 100);
    grandTotal.value = subtotal.value + taxAmount.value - discount.value;

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
    tax.value = taxPercent;
    this.prepayment.value = prepayment;
    depositAmount.value = deposit;

    // If you want, emit new state values too:
    emit(
      state.copyWith(
        fromDate: fromDateParsed,
        toDate: toDateParsed,
        rentController: rentPerDay,
        subtotal: subtotal.value,
        discount: discountVal,
        taxController: taxPercent.toString(),
        taxAmount: taxAmount.value,
        grandTotal: grandTotal.value,
        prePaymentController: prepayment.toString(),
        balance: balance.value,
        depositController: deposit,
      ),
    );
  }

  void _onInit(InitializeBookingForm event, Emitter<BookingFormState> emit) {
    final booking = event.booking;
    if (booking != null) {
      emit(
        state.copyWith(
          // taxController: booking.tax.toString(),
          balance: booking.balance,
          subtotal: booking.subtotal,
          discount: booking.discount,
          // fromDate: booking.pickupDate,
          // toDate: booking.dropoffDate,
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
  }
}
