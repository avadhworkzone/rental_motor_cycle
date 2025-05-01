// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_bloc.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_event.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_form_bloc/bike_form_event.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_form_bloc/bike_form_state.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';

class BikeFormBloc extends Bloc<BikeFormEvent, BikeFormState> {
  final BikeBloc bikeBloc;
  final numberPlateController = TextEditingController();
  final locationController = TextEditingController();
  final fuelTypeController = TextEditingController();
  final ccController = TextEditingController();
  final makeYearController = TextEditingController();
  final descriptionController = TextEditingController();
  final kmLimitController = TextEditingController();

  BikeFormBloc({required this.bikeBloc, BikeModel? bike})
    : super(
        bike != null
            ? BikeFormState(
              selectedBrand: bike.brandName ?? StringUtils.bikeBrandHonda,
              selectedModel: bike.model ?? StringUtils.bikeModelHonda,
              selectedTransmission: bike.transmission ?? StringUtils.automatic,
              selectedSeater: (bike.seater ?? '').toString(),
              selectedFuelIncluded: bike.fuelIncluded ?? '',
              isValid: true,
              numberPlate: bike.numberPlate ?? '',
              locationController: bike.location ?? '',
              ccController: bike.engineCC?.toString() ?? '',
              fuelType: bike.fuelType ?? '',
              isProcessing: false,
              kmLimit: bike.kmLimit?.toString() ?? '',
              makeYear: bike.makeYear?.toString() ?? '',
              description: bike.description ?? '',
              imageUrl: bike.imageUrl, // just use the string here
              imageFile: File(bike.imageUrl ?? ""),
            )
            : BikeFormState.initial(),
      ) {
    if (bike != null) {
      logs("---bike.imageUrl-----${bike.imageUrl}");

      // state.selectedBrand = bike.brandName ?? StringUtils.bikeBrandHonda;
      // state.selectedModel = bike.model ?? StringUtils.bikeModelHonda;
      numberPlateController.text = bike.numberPlate ?? '';
      locationController.text = bike.location ?? '';
      fuelTypeController.text = bike.fuelType ?? '';
      ccController.text = bike.engineCC?.toString() ?? '';
      makeYearController.text = bike.makeYear?.toString() ?? '';
      descriptionController.text = bike.description ?? '';
      kmLimitController.text = bike.kmLimit?.toString() ?? '';

      emit(
        state.copyWith(
          selectedBrand: bike.brandName ?? '',
          selectedModel: bike.model ?? '',
          selectedTransmission: bike.transmission ?? '',
          selectedSeater: bike.seater?.toString() ?? '',
          selectedFuelIncluded: bike.fuelIncluded,
        ),
      );
    }
    on<InitializeForm>(_onInit);
    on<UpdateBrand>(_onBrand);
    on<UpdateSeater>(_onSeater);
    on<UpdateFuelIncluded>(_onFuelIncluded);
    on<UpdateImage>(_onImage);
    on<PickedImageUpdatedEvent>((event, emit) {
      emit(state.copyWith(imageFile: event.image));
    });
    on<BikeFormValidateFields>((event, emit) {
      final isValid = _validateForm(); // A method you'll define below
      emit(state.copyWith(isValid: isValid));
    });
    on<BikeFormSubmitted>((event, emit) async {
      emit(state.copyWith(isProcessing: true));
      logs("----Image---${state.imageUrl}");
      logs("----imageFile---${state.imageFile}");
      logs("----imageFile---${File(state.imageUrl ?? "")}");
      try {
        final userId = await SharedPreferenceUtils.getString(
          SharedPreferenceUtils.userId,
        );

        final newBike = BikeModel(
          id: event.existingBike?.id,
          brandName: state.selectedBrand,
          model: state.selectedModel,
          numberPlate: numberPlateController.text.trim(),
          location: locationController.text.trim(),
          fuelType: fuelTypeController.text.trim(),
          engineCC: num.parse(ccController.text.trim()),
          description: descriptionController.text.trim(),
          imageUrl: state.imageFile?.path ?? '',
          createdAt: DateTime.now(),
          userId: int.parse(userId),
          kmLimit: double.parse(kmLimitController.text.trim()),
          makeYear: int.parse(makeYearController.text.trim()),
          transmission: state.selectedTransmission,
          seater: int.parse(state.selectedSeater!),
          fuelIncluded: state.selectedFuelIncluded!,
        );

        // If editing and no changes made
        if (event.existingBike != null && event.existingBike == newBike) {
          showCustomSnackBar(
            message: StringUtils.pleaseChangeTheDataBeforeSaving,
          );
          emit(state.copyWith(isProcessing: false));
          return;
        }

        if (event.existingBike == null) {
          bikeBloc.add(AddBikeEvent(newBike));
        } else {
          bikeBloc.add(UpdateBikeEvent(newBike));
        }

        bikeBloc.add(FetchBikesEvent());
        emit(state.copyWith(isProcessing: false));

        Get.back();
        showCustomSnackBar(message: StringUtils.bikeAddedSuccessfully);
      } catch (e) {
        logs("Error submitting form: ${e.toString()}");
        emit(state.copyWith(isProcessing: false));
      }
    });
  }

  bool _validateForm() {
    return numberPlateController.text.trim().isNotEmpty &&
        locationController.text.trim().isNotEmpty &&
        fuelTypeController.text.trim().isNotEmpty &&
        ccController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        kmLimitController.text.trim().isNotEmpty &&
        makeYearController.text.trim().isNotEmpty &&
        state.selectedSeater != null &&
        state.selectedFuelIncluded != null;
  }

  void _onInit(InitializeForm event, Emitter<BikeFormState> emit) {
    final bike = event.bike;
    if (bike != null) {
      emit(
        state.copyWith(
          selectedBrand: bike.brandName,
          selectedModel: bike.model,
          selectedTransmission: bike.transmission,
          selectedSeater: bike.seater.toString(),
          selectedFuelIncluded: bike.fuelIncluded,
          imageFile:
              bike.imageUrl?.isNotEmpty ?? false ? File(bike.imageUrl!) : null,
          imageUrl: state.imageFile?.path ?? state.imageUrl ?? '',
        ),
      );
    }
  }

  void _onBrand(UpdateBrand event, Emitter<BikeFormState> emit) {
    switch (event.brand) {
      case StringUtils.bikeBrandHonda:
        emit(
          state.copyWith(
            selectedBrand: event.brand,
            selectedModel: StringUtils.bikeModelHonda,
            selectedTransmission: StringUtils.automatic,
          ),
        );
        break;
      case StringUtils.bikeBrandYamaha:
        emit(
          state.copyWith(
            selectedBrand: event.brand,
            selectedModel: StringUtils.bikeModelYamaha,
            selectedTransmission: StringUtils.automatic,
          ),
        );
        break;
      case StringUtils.bikeBrandSuzuki:
        emit(
          state.copyWith(
            selectedBrand: event.brand,
            selectedModel: StringUtils.bikeModelSuzuki,
            selectedTransmission: StringUtils.automatic,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            selectedBrand: event.brand,
            selectedModel: '',
            selectedTransmission: '',
          ),
        );
    }
  }

  void _onSeater(UpdateSeater event, Emitter<BikeFormState> emit) {
    emit(state.copyWith(selectedSeater: event.seater));
  }

  void _onFuelIncluded(UpdateFuelIncluded event, Emitter<BikeFormState> emit) {
    emit(state.copyWith(selectedFuelIncluded: event.fuelIncluded));
  }

  void _onImage(UpdateImage event, Emitter<BikeFormState> emit) {
    emit(state.copyWith(imageFile: event.imageFile));
  }
}
