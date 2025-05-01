// ignore_for_file: unused_import

import 'dart:io';

import 'package:rental_motor_cycle/utils/string_utils.dart';

class BookingFormState {
  final String fromDateController;
  final String toDateController;
  final String fullNameController;
  final String? phoneController;
  final String? emailController;
  final String? mileageController;
  final double? rentController;
  final bool isValid;
  final double? extraPerKmController;
  final double? depositController;
  final String? taxController;
  final double? taxAmount;
  final String? prePaymentController;
  final DateTime? fromDate;
  final DateTime? toDate;

  /// Summary Fields
  final String? typeOfPayment;
  final double? subtotal;
  final double? discount;
  final double? grandTotal;
  final double? balance;

  BookingFormState({
    required this.fromDateController,
    required this.toDateController,
    required this.fullNameController,
    required this.phoneController,
    required this.emailController,
    this.mileageController,
    this.rentController,
    this.extraPerKmController,
    required this.isValid,
    this.depositController,
    this.taxController,
    this.taxAmount,
    this.prePaymentController,
    this.typeOfPayment,
    this.subtotal,
    this.discount,
    this.grandTotal,
    this.balance,
    this.fromDate,
    this.toDate,
  });

  BookingFormState copyWith({
    String? fromDateController,
    String? toDateController,
    String? fullNameController,
    String? phoneController,
    String? emailController,
    String? mileageController,
    double? rentController,
    double? extraPerKmController,
    double? depositController,
    String? taxController,
    double? taxAmount,
    String? prePaymentController,
    bool? isValid,
    bool? isProcessing,
    String? typeOfPayment,
    double? subtotal,
    double? discount,
    double? grandTotal,
    double? balance,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return BookingFormState(
      fromDateController: fromDateController ?? this.fromDateController,
      toDateController: toDateController ?? this.toDateController,
      fullNameController: fullNameController ?? this.fullNameController,
      phoneController: phoneController ?? this.phoneController,
      emailController: emailController ?? this.emailController,
      mileageController: mileageController ?? this.mileageController,
      rentController: rentController ?? this.rentController,
      extraPerKmController: extraPerKmController ?? this.extraPerKmController,
      depositController: depositController ?? this.depositController,
      taxController: taxController ?? this.taxController,
      taxAmount: taxAmount ?? this.taxAmount,
      prePaymentController: prePaymentController ?? this.prePaymentController,
      isValid: isValid ?? this.isValid,
      typeOfPayment: typeOfPayment ?? this.typeOfPayment,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      grandTotal: grandTotal ?? this.grandTotal,
      balance: balance ?? this.balance,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  factory BookingFormState.initial() => BookingFormState(
    fromDateController: "",
    toDateController: "",
    fullNameController: "",
    phoneController: "",
    emailController: "",
    mileageController: "0",
    rentController: 0,
    extraPerKmController: 0,
    depositController: 0,
    taxAmount: 0,
    taxController: "0",
    prePaymentController: "",
    isValid: false,
    typeOfPayment: StringUtils.cash,
    subtotal: 0,
    discount: 0,
    grandTotal: 0,
    balance: 0,
    fromDate: null,
    toDate: null,
  );
}
