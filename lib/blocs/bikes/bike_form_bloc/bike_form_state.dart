import 'dart:io';

import 'package:rental_motor_cycle/utils/string_utils.dart';

class BikeFormState {
  final String selectedBrand;
  final String selectedModel;
  final String selectedTransmission;
  final String? selectedSeater;
  final String? selectedFuelIncluded;
  final String? locationController;
  final String? ccController;
  final bool isValid;
  final bool isProcessing;
  final String? numberPlate;
  final String? fuelType;
  final String? kmLimit;
  final String? makeYear;
  final String? description;
  final String? imageUrl;
  final File? imageFile;

  BikeFormState({
    required this.selectedBrand,
    required this.selectedModel,
    required this.selectedTransmission,
    required this.selectedSeater,
    required this.selectedFuelIncluded,
    required this.isValid,
    this.locationController,
    this.ccController,
    this.numberPlate,
    this.fuelType,
    this.kmLimit,
    this.makeYear,
    this.description,
    this.isProcessing = false,
    required this.imageUrl,
    this.imageFile,
  });

  BikeFormState copyWith({
    String? selectedBrand,
    String? selectedModel,
    String? selectedTransmission,
    String? selectedSeater,
    String? numberPlate,
    String? selectedFuelIncluded,
    String? locationController,
    String? fuelType,
    String? ccController,
    String? kmLimit,
    String? makeYear,
    String? description,
    bool? isValid,
    bool? isProcessing,
    String? imageUrl,
    File? imageFile,
  }) {
    return BikeFormState(
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedModel: selectedModel ?? this.selectedModel,
      selectedTransmission: selectedTransmission ?? this.selectedTransmission,
      selectedSeater: selectedSeater ?? this.selectedSeater,
      numberPlate: numberPlate ?? this.numberPlate,
      locationController: locationController ?? this.locationController,
      ccController: ccController ?? this.ccController,
      fuelType: fuelType ?? this.fuelType,
      kmLimit: kmLimit ?? this.kmLimit,
      makeYear: makeYear ?? this.makeYear,
      description: description ?? this.description,
      selectedFuelIncluded: selectedFuelIncluded ?? this.selectedFuelIncluded,
      isValid: isValid ?? this.isValid,
      isProcessing: isProcessing ?? this.isProcessing,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  factory BikeFormState.initial() => BikeFormState(
    selectedBrand: StringUtils.bikeBrandHonda,
    selectedModel: StringUtils.bikeModelHonda,
    selectedTransmission: StringUtils.automatic,
    selectedSeater: null,
    numberPlate: "",
    ccController: "",
    kmLimit: "",
    makeYear: "",
    description: "",
    selectedFuelIncluded: null,
    imageUrl: null,
    isValid: false,
    isProcessing: false,
    imageFile: null,
  );
}
