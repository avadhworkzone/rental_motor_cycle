// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_bloc.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_form_bloc/bike_form_bloc.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_form_bloc/bike_form_event.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_form_bloc/bike_form_state.dart';
import 'package:rental_motor_cycle/commonWidgets/common_dropdown.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';

void showAddBikeBottomSheet(BuildContext context, {BikeModel? bike}) {
  // final formKey = GlobalKey<FormState>();
  /* var isProcessing = false;
  final BikeController bikeController = Get.find<BikeController>();
  final TextEditingController numberPlateController = TextEditingController(
    text: bike?.numberPlate ?? "",
  );
  final TextEditingController locationController = TextEditingController(
    text: bike?.location ?? "",
  );
  final TextEditingController fuelTypeController = TextEditingController(
    text: bike?.fuelType ?? "",
  );
  final TextEditingController ccController = TextEditingController(
    text: bike?.engineCC?.toStringAsFixed(0) ?? "",
  );
  final TextEditingController descriptionController = TextEditingController(
    text: bike?.description ?? "",
  );
  final TextEditingController kmLimitController = TextEditingController(
    text: bike?.kmLimit?.toStringAsFixed(0) ?? "",
  );
  final TextEditingController makeYearController = TextEditingController(
    text: bike?.makeYear.toString() ?? "",
  );
  final RxString selectedBrand =
      (bike?.brandName ?? StringUtils.bikeBrandHonda).obs;
  final RxString selectedModel =
      (bike?.model ?? StringUtils.bikeModelHonda).obs;
  final RxString selectedTransmission =
      (bike?.transmission ?? StringUtils.automatic).obs;
  String? selectedSeater = bike?.seater.toString();
  String? selectedFuelIncluded = bike?.fuelIncluded;

  if (bike != null && (bike.imageUrl?.isNotEmpty ?? false)) {
    bikeController.bikeImage.value = File(bike.imageUrl ?? "");
    bikeController.selectedImagePath.value = bike.imageUrl ?? "";
  }

  var isValid = false.obs;

  void validateFields() {
    isValid.value =
        numberPlateController.text.trim().isNotEmpty &&
        locationController.text.trim().isNotEmpty &&
        fuelTypeController.text.trim().isNotEmpty &&
        ccController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        kmLimitController.text.trim().isNotEmpty &&
        makeYearController.text.trim().isNotEmpty &&
        selectedSeater != null &&
        selectedFuelIncluded != null &&
        (bikeController.bikeImage.value != null &&
            bikeController.bikeImage.value!.path.isNotEmpty);
  }

  void onBrandChanged(String? brand) {
    selectedBrand.value = brand ?? "";
    switch (brand) {
      case StringUtils.bikeBrandHonda:
        selectedModel.value = StringUtils.bikeModelHonda;
        selectedTransmission.value = StringUtils.automatic;
        break;
      case StringUtils.bikeBrandYamaha:
        selectedModel.value = StringUtils.bikeModelYamaha;
        selectedTransmission.value = StringUtils.automatic;
        break;
      case StringUtils.bikeBrandSuzuki:
        selectedModel.value = StringUtils.bikeModelSuzuki;
        selectedTransmission.value = StringUtils.automatic;
        break;
      default:
        selectedModel.value = "";
        selectedTransmission.value = "";
    }
    validateFields();
  }*/
  final formKey = GlobalKey<FormState>();
  // final bikeFormBloc = BikeFormBloc(bikeBloc: null)..add(InitializeBikeFormEvent(bike: bike));
  Future<File?> pickImageFromCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> pickImageFromGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? ColorUtils.darkThemeBg
                : ColorUtils.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<BikeBloc>()),
          BlocProvider(
            create:
                (_) => BikeFormBloc(
                  bikeBloc: context.read<BikeBloc>(),
                  bike: bike,
                ),
          ),
        ],

        child: FractionallySizedBox(
          heightFactor: 0.75.w,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  bike == null
                      ? StringUtils.addNewBike
                      : StringUtils.updateBike,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 10.h),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ///Pick bike image
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.imageFile != current.imageFile,
                          builder: (context, state) {
                            return Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorUtils.primary,
                                    width: 2.w,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  height: 111.h,
                                  width: 111.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorUtils.primary,
                                      width: 2.w,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      BlocBuilder<BikeFormBloc, BikeFormState>(
                                        builder: (context, state) {
                                          return Center(
                                            child:
                                                (state.imageFile == null ||
                                                        state
                                                            .imageFile!
                                                            .path
                                                            .isEmpty)
                                                    ? Icon(
                                                      Icons
                                                          .supervised_user_circle,
                                                      size: 50.sp,
                                                    )
                                                    : Container(
                                                      height: 111.h,
                                                      width: 111.w,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: FileImage(
                                                            state.imageFile!,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                          );
                                        },
                                      ),
                                      Positioned(
                                        right: -4.w,
                                        bottom: -10.h,
                                        child: IconButton(
                                          onPressed: () {
                                            profileScreenDialogBox(
                                              context: context,
                                              text: StringUtils.addBikeImage,
                                              onTap: () async {
                                                final image =
                                                    await pickImageFromCamera(
                                                      context,
                                                    );
                                                if (image != null) {
                                                  context
                                                      .read<BikeFormBloc>()
                                                      .add(
                                                        PickedImageUpdatedEvent(
                                                          image,
                                                        ),
                                                      );
                                                }
                                              },
                                              onTap2: () async {
                                                final image =
                                                    await pickImageFromGallery(
                                                      context,
                                                    );
                                                if (image != null) {
                                                  context
                                                      .read<BikeFormBloc>()
                                                      .add(
                                                        PickedImageUpdatedEvent(
                                                          image,
                                                        ),
                                                      );
                                                }
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.camera_alt_outlined),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10.h),

                        /// Brand Dropdown
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.selectedBrand !=
                                  current.selectedBrand,
                          builder: (context, state) {
                            return CommonDropdown(
                              items: [
                                StringUtils.bikeBrandHonda,
                                StringUtils.bikeBrandYamaha,
                                StringUtils.bikeBrandSuzuki,
                              ],
                              labelText: StringUtils.bikeBrand,
                              selectedValue: state.selectedBrand,
                              onChanged: (value) {
                                context.read<BikeFormBloc>().add(
                                  UpdateBrand(value ?? ''),
                                );
                                context.read<BikeFormBloc>().add(
                                  BikeFormValidateFields(),
                                );
                              },
                              validationMessage: StringUtils.selectBikeBrand,
                            );
                          },
                        ),

                        /// Model Dropdown (non-editable, based on brand)
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.selectedModel !=
                                  current.selectedModel,
                          builder: (context, state) {
                            return CommonDropdown(
                              items:
                                  state.selectedModel.isNotEmpty
                                      ? [state.selectedModel]
                                      : [],
                              labelText: StringUtils.bikeModel,
                              selectedValue: state.selectedModel,
                              onChanged: null,
                              validationMessage: StringUtils.selectBikeModel,
                            );
                          },
                        ),

                        /// Vehicle Number
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.numberPlate != current.numberPlate,
                          builder: (context, state) {
                            return CommonTextField(
                              textEditController:
                                  context
                                      .read<BikeFormBloc>()
                                      .numberPlateController,
                              labelText: StringUtils.vehicleNumber,
                              keyBoardType: TextInputType.name,
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? StringUtils.enterVehicleNumber
                                          : null,
                              onChange:
                                  (_) => context.read<BikeFormBloc>().add(
                                    BikeFormValidateFields(),
                                  ),
                            );
                          },
                        ),

                        /// Bike Location
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.locationController !=
                                  current.locationController,
                          builder: (context, state) {
                            return CommonTextField(
                              textEditController:
                                  context
                                      .read<BikeFormBloc>()
                                      .locationController,
                              labelText: StringUtils.bikeLocation,
                              keyBoardType: TextInputType.name,
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? StringUtils.enterLocation
                                          : null,
                              onChange:
                                  (_) => context.read<BikeFormBloc>().add(
                                    BikeFormValidateFields(),
                                  ),
                            );
                          },
                        ),

                        /// Fuel Type
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.fuelType != current.fuelType,
                          builder: (context, state) {
                            return CommonDropdown(
                              items: [
                                StringUtils.petrol,
                                StringUtils.diesel,
                                StringUtils.electric,
                              ],
                              labelText: StringUtils.fuelType,
                              selectedValue:
                                  context
                                          .read<BikeFormBloc>()
                                          .fuelTypeController
                                          .text
                                          .isNotEmpty
                                      ? context
                                          .read<BikeFormBloc>()
                                          .fuelTypeController
                                          .text
                                      : null,
                              onChanged: (value) {
                                context
                                    .read<BikeFormBloc>()
                                    .fuelTypeController
                                    .text = value ?? "";
                                context.read<BikeFormBloc>().add(
                                  BikeFormValidateFields(),
                                );
                              },
                              validationMessage: StringUtils.selectFuelType,
                            );
                          },
                        ),

                        /// Engine CC
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.ccController != current.ccController,
                          builder: (context, state) {
                            return CommonTextField(
                              textEditController:
                                  context.read<BikeFormBloc>().ccController,
                              labelText: StringUtils.engineCC,
                              keyBoardType: TextInputType.number,
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? StringUtils.enterEngineCC
                                          : null,
                              onChange:
                                  (_) => context.read<BikeFormBloc>().add(
                                    BikeFormValidateFields(),
                                  ),
                            );
                          },
                        ),

                        /// Transmission Dropdown (non-editable, based on brand)
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.selectedTransmission !=
                                  current.selectedTransmission,
                          builder: (context, state) {
                            return CommonDropdown(
                              items:
                                  state.selectedTransmission.isNotEmpty
                                      ? [state.selectedTransmission]
                                      : [],
                              labelText: StringUtils.transmission,
                              selectedValue: state.selectedTransmission,
                              onChanged: null,
                              validationMessage: StringUtils.selectTransmission,
                            );
                          },
                        ),

                        /// Seater
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.selectedSeater !=
                                  current.selectedSeater,
                          builder: (context, state) {
                            return CommonDropdown(
                              items: ["1", "2", "3", "4", "5", "6"],
                              labelText: StringUtils.seater,
                              selectedValue: state.selectedSeater,
                              onChanged: (value) {
                                context.read<BikeFormBloc>().add(
                                  UpdateSeater(value),
                                );
                                context.read<BikeFormBloc>().add(
                                  BikeFormValidateFields(),
                                );
                              },
                              validationMessage: StringUtils.selectSeater,
                            );
                          },
                        ),

                        /// Fuel Included / Excluded
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.selectedFuelIncluded !=
                                  current.selectedFuelIncluded,
                          builder: (context, state) {
                            return CommonDropdown(
                              items: [
                                StringUtils.included,
                                StringUtils.excluded,
                              ],
                              labelText: StringUtils.fuel,
                              selectedValue: state.selectedFuelIncluded,
                              onChanged: (value) {
                                context.read<BikeFormBloc>().add(
                                  UpdateFuelIncluded(value),
                                );
                                context.read<BikeFormBloc>().add(
                                  BikeFormValidateFields(),
                                );
                              },
                              validationMessage: StringUtils.selectFuelOption,
                            );
                          },
                        ),

                        /// KM Limit
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.kmLimit != current.kmLimit,
                          builder: (context, state) {
                            return CommonTextField(
                              textEditController:
                                  context
                                      .read<BikeFormBloc>()
                                      .kmLimitController,
                              labelText: StringUtils.kmLimit,
                              keyBoardType: TextInputType.number,
                              onChange:
                                  (_) => context.read<BikeFormBloc>().add(
                                    BikeFormValidateFields(),
                                  ),
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? StringUtils.enterKmLimit
                                          : null,
                            );
                          },
                        ),

                        ///makeYear
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.makeYear != current.makeYear,
                          builder: (context, state) {
                            return CommonTextField(
                              textEditController:
                                  context
                                      .read<BikeFormBloc>()
                                      .makeYearController,
                              labelText: StringUtils.makeYear,
                              readOnly: false,
                              onTap: () async {
                                final currentYear = DateTime.now().year;
                                int? selectedYear = await showDialog<int>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: CustomText(StringUtils.selectYear),
                                      content: SizedBox(
                                        height: 300,
                                        width: 300,
                                        child: YearPicker(
                                          firstDate: DateTime(1980),
                                          lastDate: DateTime(currentYear),
                                          initialDate: DateTime(currentYear),
                                          selectedDate:
                                              DateTime.tryParse(
                                                context
                                                    .read<BikeFormBloc>()
                                                    .makeYearController
                                                    .text,
                                              ) ??
                                              DateTime(currentYear),
                                          onChanged: (DateTime dateTime) {
                                            Navigator.of(
                                              context,
                                            ).pop(dateTime.year);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );

                                if (selectedYear != null) {
                                  context
                                      .read<BikeFormBloc>()
                                      .makeYearController
                                      .text = selectedYear.toString();
                                  context.read<BikeFormBloc>().add(
                                    BikeFormValidateFields(),
                                  );
                                }
                              },
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? StringUtils.enterMakeYear
                                          : null,
                            );
                          },
                        ),

                        ///bikeDescription
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          buildWhen:
                              (previous, current) =>
                                  previous.description != current.description,
                          builder: (context, state) {
                            return CommonTextField(
                              textEditController:
                                  context
                                      .read<BikeFormBloc>()
                                      .descriptionController,
                              labelText: StringUtils.bikeDescription,
                              keyBoardType: TextInputType.name,
                              onChange:
                                  (_) => context.read<BikeFormBloc>().add(
                                    BikeFormValidateFields(),
                                  ),
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? StringUtils.enterDescription
                                          : null,
                              maxLine: 3,
                            );
                          },
                        ),
                        SizedBox(height: 20.h),

                        ///Add Update btn
                        BlocBuilder<BikeFormBloc, BikeFormState>(
                          builder: (context, state) {
                            return CustomBtn(
                              title:
                                  bike == null
                                      ? StringUtils.addBike
                                      : StringUtils.updateBike,
                              onTap:
                                  (state.isProcessing || !state.isValid)
                                      ? null
                                      : () {
                                        if (formKey.currentState?.validate() ??
                                            false) {
                                          logs("---bike----${bike?.imageUrl}");
                                          context.read<BikeFormBloc>().add(
                                            BikeFormSubmitted(
                                              existingBike: bike,
                                            ),
                                          );
                                        } else {
                                          logs("---NOT VALIDATED");
                                        }
                                      },
                              bgColor:
                                  (state.isProcessing || !state.isValid)
                                      ? ColorUtils.primary.withOpacity(0.4)
                                      : ColorUtils.primary,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

Future<void> profileScreenDialogBox({
  required BuildContext context,

  VoidCallback? onTap,
  VoidCallback? onTap2,
  String? text,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5.h),
            Padding(
              padding: const EdgeInsets.all(12),
              child: CustomText(
                text ?? '',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const Divider(color: ColorUtils.grey99, thickness: 0.5),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                if (onTap != null) onTap();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      StringUtils.takePhoto,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                    Icon(Icons.camera_alt_outlined),
                  ],
                ),
              ),
            ),
            const Divider(color: ColorUtils.grey99, thickness: 0.5),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                if (onTap2 != null) onTap2();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      StringUtils.chooseFromGalary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    Icon(Icons.photo),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      );
    },
  );
}

// void confirmDelete(BuildContext context,int id) {
//   // final BikeController bikeController = Get.find<BikeController>();
//   var isProcessing = false;
//   Get.defaultDialog(
//     title: StringUtils.deleteBike,
//     middleText: StringUtils.deleteConfirmation,
//     textConfirm: StringUtils.delete,
//     textCancel: StringUtils.cancel,
//     cancelTextColor: ColorUtils.black,
//     confirmTextColor: ColorUtils.black,
//     onConfirm: () async {
//       isProcessing = true;
//       // isProcessing.value = true;
//       await Future.delayed(Duration(milliseconds: 300));
//       context.read<BikeBloc>().add(DeleteBikeEvent(id));
//       context.read<BikeBloc>().add(FetchBikesEvent());
//       isProcessing = false;
//       // isProcessing.value = false;
//       Get.back();
//     },
//   );
// }

///bloc
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_bloc.dart';
// import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_event.dart';
// import 'package:rental_motor_cycle/commonWidgets/common_dropdown.dart';
// import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
// import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
// import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
// import 'package:rental_motor_cycle/model/bike_model.dart';
// import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
// import 'package:rental_motor_cycle/utils/color_utils.dart';
// import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
// import 'package:rental_motor_cycle/utils/string_utils.dart';
//
// void showAddBikeBottomSheet(BuildContext context, {BikeModel? bike}) {
//   final formKey = GlobalKey<FormState>();
//   // var isProcessing = false;
//   // // final BikeController bikeController = Get.find<BikeController>();
//   // final TextEditingController numberPlateController = TextEditingController(
//   //   text: bike?.numberPlate ?? "",
//   // );
//   // final TextEditingController locationController = TextEditingController(
//   //   text: bike?.location ?? "",
//   // );
//   // final TextEditingController fuelTypeController = TextEditingController(
//   //   text: bike?.fuelType ?? "",
//   // );
//   // final TextEditingController ccController = TextEditingController(
//   //   text: bike?.engineCC?.toStringAsFixed(0) ?? "",
//   // );
//   // final TextEditingController descriptionController = TextEditingController(
//   //   text: bike?.description ?? "",
//   // );
//   // final TextEditingController kmLimitController = TextEditingController(
//   //   text: bike?.kmLimit?.toStringAsFixed(0) ?? "",
//   // );
//   // final TextEditingController makeYearController = TextEditingController(
//   //   text: bike?.makeYear.toString() ?? "",
//   // );
//   // final RxString selectedBrand =
//   //     (bike?.brandName ?? StringUtils.bikeBrandHonda).obs;
//   // final RxString selectedModel =
//   //     (bike?.model ?? StringUtils.bikeModelHonda).obs;
//   // final RxString selectedTransmission =
//   //     (bike?.transmission ?? StringUtils.automatic).obs;
//   // String? selectedSeater = bike?.seater.toString();
//   // String? selectedFuelIncluded = bike?.fuelIncluded;
//   // File? bikeImage = File('');
//   // var selectedImagePath = '';
//   // if (bike != null && (bike.imageUrl?.isNotEmpty ?? false)) {
//   //   bikeImage = File(bike.imageUrl ?? "");
//   //   selectedImagePath = bike.imageUrl ?? "";
//   // }
//   //
//   // var isValid = false.obs;
//   //
//   // void showPermissionDialog(BuildContext context) {
//   //   Get.dialog(
//   //     AlertDialog(
//   //       title: Text("Permission Required"),
//   //       content: Text("Please enable permission from settings."),
//   //       actions: [
//   //         TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
//   //         TextButton(
//   //           onPressed: () => openAppSettings(),
//   //           child: Text("Go to Settings"),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   // Future<File?> _pickImage(ImageSource source) async {
//   //   try {
//   //     final pickedImage = await ImagePicker().pickImage(
//   //       source: source,
//   //       imageQuality: 25,
//   //     );
//   //     return pickedImage != null ? File(pickedImage.path) : null;
//   //   } catch (e) {
//   //     showCustomSnackBar(message: 'ERROR-----${e.toString()}', isError: true);
//   //     return null;
//   //   }
//   // }
//   //
//   // Future<bool> requestPermissions() async {
//   //   Map<Permission, PermissionStatus> statuses =
//   //       await [
//   //         Permission.camera,
//   //         Permission.storage, // For Android 12 and below
//   //         Permission.photos, // For Android 13+
//   //       ].request();
//   //
//   //   if (statuses[Permission.camera]!.isGranted &&
//   //       (statuses[Permission.storage]!.isGranted ||
//   //           statuses[Permission.photos]!.isGranted)) {
//   //     return true;
//   //   } else {
//   //     return false;
//   //   }
//   // }
//   //
//   // Future<File?> pickImageFromCamera(BuildContext context) async {
//   //   if (await requestPermissions()) {
//   //     return _pickImage(ImageSource.camera);
//   //   } else {
//   //     showPermissionDialog(context);
//   //     return null;
//   //   }
//   // }
//   //
//   // Future<File?> pickImageFromGallery(BuildContext context) async {
//   //   if (await requestPermissions()) {
//   //     return _pickImage(ImageSource.gallery);
//   //   } else {
//   //     showPermissionDialog(context);
//   //     return null;
//   //   }
//   // }
//   //
//   // Future<void> selectImage(BuildContext context) async {
//   //   File? image = await pickImageFromGallery(context);
//   //   if (image != null) {
//   //     bikeImage = image;
//   //     selectedImagePath = image.path; // ✅ Save path
//   //   }
//   // }
//   //
//   // Future<void> selectImageCamera(BuildContext context) async {
//   //   File? image = await pickImageFromCamera(context);
//   //   if (image != null) {
//   //     bikeImage = image;
//   //     selectedImagePath = image.path; // ✅ Save path
//   //   }
//   // }
//   //
//   // void validateFields() {
//   //   isValid.value =
//   //       numberPlateController.text.trim().isNotEmpty &&
//   //       locationController.text.trim().isNotEmpty &&
//   //       fuelTypeController.text.trim().isNotEmpty &&
//   //       ccController.text.trim().isNotEmpty &&
//   //       descriptionController.text.trim().isNotEmpty &&
//   //       kmLimitController.text.trim().isNotEmpty &&
//   //       makeYearController.text.trim().isNotEmpty &&
//   //       selectedSeater != null &&
//   //       selectedFuelIncluded != null &&
//   //       (bikeImage != null && bikeImage!.path.isNotEmpty);
//   // }
//   //
//   // void onBrandChanged(String? brand) {
//   //   selectedBrand.value = brand ?? "";
//   //   switch (brand) {
//   //     case StringUtils.bikeBrandHonda:
//   //       selectedModel.value = StringUtils.bikeModelHonda;
//   //       selectedTransmission.value = StringUtils.automatic;
//   //       break;
//   //     case StringUtils.bikeBrandYamaha:
//   //       selectedModel.value = StringUtils.bikeModelYamaha;
//   //       selectedTransmission.value = StringUtils.automatic;
//   //       break;
//   //     case StringUtils.bikeBrandSuzuki:
//   //       selectedModel.value = StringUtils.bikeModelSuzuki;
//   //       selectedTransmission.value = StringUtils.automatic;
//   //       break;
//   //     default:
//   //       selectedModel.value = "";
//   //       selectedTransmission.value = "";
//   //   }
//   //   validateFields();
//   // }
//
//   Get.bottomSheet(
//     Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color:
//             Theme.of(context).brightness == Brightness.dark
//                 ? ColorUtils.darkThemeBg
//                 : ColorUtils.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: FractionallySizedBox(
//         heightFactor: 0.75.w,
//         child: Form(
//           key: formKey,
//           child: SizedBox(),
//           // child: Column(
//           //   crossAxisAlignment: CrossAxisAlignment.start,
//           //   children: [
//           //     CustomText(
//           //       bike == null ? StringUtils.addNewBike : StringUtils.updateBike,
//           //       fontSize: 20.sp,
//           //       fontWeight: FontWeight.bold,
//           //     ),
//           //     SizedBox(height: 10.h),
//           //
//           //     ///Pick bike image
//           //     Expanded(
//           //       child: SingleChildScrollView(
//           //         child: Column(
//           //           children: [
//           //             Align(
//           //               alignment: Alignment.center,
//           //               child: Container(
//           //                 padding: EdgeInsets.all(2.w),
//           //                 decoration: BoxDecoration(
//           //                   border: Border.all(
//           //                     color: ColorUtils.primary,
//           //                     width: 2.w,
//           //                   ),
//           //                   shape: BoxShape.circle,
//           //                 ),
//           //                 child: Container(
//           //                   height: 111.h,
//           //                   width: 111.w,
//           //                   decoration: BoxDecoration(
//           //                     border: Border.all(
//           //                       color: ColorUtils.primary,
//           //                       width: 2.w,
//           //                     ),
//           //                     shape: BoxShape.circle,
//           //                   ),
//           //                   child: Stack(
//           //                     clipBehavior: Clip.none,
//           //                     children: [
//           //                       Obx(() {
//           //                         return Center(
//           //                           child:
//           //                               (bikeImage?.path.isEmpty ?? true)
//           //                                   ? Icon(
//           //                                     Icons.supervised_user_circle,
//           //                                     size: 50.sp,
//           //                                   )
//           //                                   : Container(
//           //                                     height: 111.h,
//           //                                     width: 111.w,
//           //                                     decoration: BoxDecoration(
//           //                                       shape: BoxShape.circle,
//           //                                       image: DecorationImage(
//           //                                         image: FileImage(
//           //                                           bikeImage ?? File(''),
//           //                                         ),
//           //                                         fit: BoxFit.cover,
//           //                                       ),
//           //                                     ),
//           //                                   ),
//           //                         );
//           //                       }),
//           //                       Positioned(
//           //                         right: -4.w,
//           //                         bottom: -10.h,
//           //                         child: IconButton(
//           //                           onPressed: () {
//           //                             profileScreenDialogBox(
//           //                               context: context,
//           //                               text: StringUtils.addBikeImage,
//           //                               onTap: () async {
//           //                                 await selectImageCamera(context);
//           //                                 validateFields();
//           //                               },
//           //                               onTap2: () async {
//           //                                 await selectImage(context);
//           //                                 validateFields();
//           //                               },
//           //                             );
//           //                           },
//           //                           icon: Icon(Icons.camera_alt_outlined),
//           //                         ),
//           //                       ),
//           //                     ],
//           //                   ),
//           //                 ),
//           //               ),
//           //             ),
//           //             SizedBox(height: 10.h),
//           //
//           //             ///bikeBrand
//           //             Obx(
//           //               () => CommonDropdown(
//           //                 items: [
//           //                   StringUtils.bikeBrandHonda,
//           //                   StringUtils.bikeBrandYamaha,
//           //                   StringUtils.bikeBrandSuzuki,
//           //                 ],
//           //                 labelText: StringUtils.bikeBrand,
//           //                 selectedValue: selectedBrand.value,
//           //                 onChanged: onBrandChanged,
//           //                 validationMessage: StringUtils.selectBikeBrand,
//           //               ),
//           //             ),
//           //
//           //             ///bikeModel
//           //             Obx(
//           //               () => CommonDropdown(
//           //                 items:
//           //                     selectedModel.value.isNotEmpty
//           //                         ? [selectedModel.value]
//           //                         : [],
//           //                 labelText: StringUtils.bikeModel,
//           //                 selectedValue: selectedModel.value,
//           //                 onChanged: null,
//           //                 validationMessage: StringUtils.selectBikeModel,
//           //               ),
//           //             ),
//           //
//           //             ///vehicleNumber
//           //             CommonTextField(
//           //               textEditController: numberPlateController,
//           //               labelText: StringUtils.vehicleNumber,
//           //               keyBoardType: TextInputType.name,
//           //               validator:
//           //                   (value) =>
//           //                       value!.isEmpty
//           //                           ? StringUtils.enterVehicleNumber
//           //                           : null,
//           //               onChange: (_) => validateFields(),
//           //             ),
//           //
//           //             ///bikeLocation
//           //             CommonTextField(
//           //               textEditController: locationController,
//           //               labelText: StringUtils.bikeLocation,
//           //               keyBoardType: TextInputType.name,
//           //               validator:
//           //                   (value) =>
//           //                       value!.isEmpty
//           //                           ? StringUtils.enterLocation
//           //                           : null,
//           //               onChange: (_) => validateFields(),
//           //             ),
//           //
//           //             ///fuelType
//           //             CommonDropdown(
//           //               items: [
//           //                 StringUtils.petrol,
//           //                 StringUtils.diesel,
//           //                 StringUtils.electric,
//           //               ],
//           //               labelText: StringUtils.fuelType,
//           //               selectedValue:
//           //                   fuelTypeController.text.isNotEmpty
//           //                       ? fuelTypeController.text
//           //                       : null,
//           //               onChanged: (value) {
//           //                 fuelTypeController.text = value ?? "";
//           //                 validateFields();
//           //               },
//           //               validationMessage: StringUtils.selectFuelType,
//           //             ),
//           //
//           //             ///engineCC
//           //             CommonTextField(
//           //               textEditController: ccController,
//           //               labelText: StringUtils.engineCC,
//           //               keyBoardType: TextInputType.number,
//           //               validator:
//           //                   (value) =>
//           //                       value!.isEmpty
//           //                           ? StringUtils.enterEngineCC
//           //                           : null,
//           //               onChange: (_) => validateFields(),
//           //             ),
//           //
//           //             ///transmission
//           //             Obx(
//           //               () => CommonDropdown(
//           //                 items:
//           //                     selectedTransmission.value.isNotEmpty
//           //                         ? [selectedTransmission.value]
//           //                         : [],
//           //                 labelText: StringUtils.transmission,
//           //                 selectedValue: selectedTransmission.value,
//           //                 onChanged: null,
//           //                 validationMessage: StringUtils.selectTransmission,
//           //               ),
//           //             ),
//           //
//           //             ///seater
//           //             CommonDropdown(
//           //               items: ["1", "2", "3", "4", "5", "6"],
//           //               labelText: StringUtils.seater,
//           //               selectedValue: selectedSeater,
//           //               onChanged: (value) {
//           //                 selectedSeater = value;
//           //                 validateFields();
//           //               },
//           //               validationMessage: StringUtils.selectSeater,
//           //             ),
//           //
//           //             ///fuel
//           //             CommonDropdown(
//           //               items: [StringUtils.included, StringUtils.excluded],
//           //               labelText: StringUtils.fuel,
//           //               selectedValue: selectedFuelIncluded,
//           //               onChanged: (value) {
//           //                 selectedFuelIncluded = value;
//           //                 validateFields();
//           //               },
//           //               validationMessage: StringUtils.selectFuelOption,
//           //             ),
//           //
//           //             ///kmLimit
//           //             CommonTextField(
//           //               textEditController: kmLimitController,
//           //               labelText: StringUtils.kmLimit,
//           //               keyBoardType: TextInputType.number,
//           //               onChange: (_) => validateFields(),
//           //               validator:
//           //                   (value) =>
//           //                       value!.isEmpty
//           //                           ? StringUtils.enterKmLimit
//           //                           : null,
//           //             ),
//           //
//           //             ///makeYear
//           //             CommonTextField(
//           //               textEditController: makeYearController,
//           //               labelText: StringUtils.makeYear,
//           //               readOnly: false,
//           //               onTap: () async {
//           //                 final currentYear = DateTime.now().year;
//           //                 int? selectedYear = await showDialog<int>(
//           //                   context: context,
//           //                   builder: (context) {
//           //                     return AlertDialog(
//           //                       title: CustomText(StringUtils.selectYear),
//           //                       content: SizedBox(
//           //                         height: 300,
//           //                         width: 300,
//           //                         child: YearPicker(
//           //                           firstDate: DateTime(1980),
//           //                           lastDate: DateTime(currentYear),
//           //                           initialDate: DateTime(currentYear),
//           //                           selectedDate:
//           //                               DateTime.tryParse(
//           //                                 makeYearController.text,
//           //                               ) ??
//           //                               DateTime(currentYear),
//           //                           onChanged: (DateTime dateTime) {
//           //                             Navigator.of(context).pop(dateTime.year);
//           //                           },
//           //                         ),
//           //                       ),
//           //                     );
//           //                   },
//           //                 );
//           //
//           //                 if (selectedYear != null) {
//           //                   makeYearController.text = selectedYear.toString();
//           //                   validateFields();
//           //                 }
//           //               },
//           //
//           //               validator:
//           //                   (value) =>
//           //                       value!.isEmpty
//           //                           ? StringUtils.enterMakeYear
//           //                           : null,
//           //             ),
//           //
//           //             ///bikeDescription
//           //             CommonTextField(
//           //               textEditController: descriptionController,
//           //               labelText: StringUtils.bikeDescription,
//           //               keyBoardType: TextInputType.name,
//           //               onChange: (_) => validateFields(),
//           //               validator:
//           //                   (value) =>
//           //                       value!.isEmpty
//           //                           ? StringUtils.enterDescription
//           //                           : null,
//           //               maxLine: 3,
//           //             ),
//           //             SizedBox(height: 20),
//           //
//           //             ///Add Update btn
//           //             Obx(
//           //               () => CustomBtn(
//           //                 title:
//           //                     bike == null
//           //                         ? StringUtils.addBike
//           //                         : StringUtils.updateBike,
//           //                 onTap:
//           //                     (isProcessing || !isValid.value)
//           //                         ? null
//           //                         : () async {
//           //                           if (formKey.currentState?.validate() ??
//           //                               false) {
//           //                             try {
//           //                               isProcessing = true;
//           //                               var userId =
//           //                                   await SharedPreferenceUtils.getString(
//           //                                     SharedPreferenceUtils.userId,
//           //                                   );
//           //                               logs('User ID ---> $userId');
//           //                               if (!isValid.value) return;
//           //
//           //                               BikeModel newBike = BikeModel(
//           //                                 id: bike?.id,
//           //                                 brandName: selectedBrand.value,
//           //                                 model: selectedModel.value,
//           //                                 numberPlate:
//           //                                     numberPlateController.text.trim(),
//           //                                 location:
//           //                                     locationController.text.trim(),
//           //                                 fuelType:
//           //                                     fuelTypeController.text.trim(),
//           //                                 engineCC: num.parse(
//           //                                   ccController.text.trim(),
//           //                                 ),
//           //                                 description:
//           //                                     descriptionController.text.trim(),
//           //                                 imageUrl: selectedImagePath,
//           //                                 createdAt: DateTime.now(),
//           //                                 userId: int.parse(userId),
//           //                                 kmLimit: double.parse(
//           //                                   kmLimitController.text.trim(),
//           //                                 ),
//           //                                 makeYear: int.parse(
//           //                                   makeYearController.text.trim(),
//           //                                 ),
//           //                                 transmission:
//           //                                     selectedTransmission.value,
//           //                                 seater: int.parse(selectedSeater!),
//           //                                 fuelIncluded: selectedFuelIncluded!,
//           //                               );
//           //
//           //                               if (bike != null &&
//           //                                   bike.brandName ==
//           //                                       newBike.brandName &&
//           //                                   bike.model == newBike.model &&
//           //                                   bike.numberPlate ==
//           //                                       newBike.numberPlate &&
//           //                                   bike.fuelIncluded ==
//           //                                       newBike.fuelIncluded &&
//           //                                   bike.location == newBike.location &&
//           //                                   bike.fuelType == newBike.fuelType &&
//           //                                   bike.kmLimit == newBike.kmLimit &&
//           //                                   bike.engineCC == newBike.engineCC &&
//           //                                   bike.description ==
//           //                                       newBike.description &&
//           //                                   bike.seater == newBike.seater &&
//           //                                   bike.transmission ==
//           //                                       newBike.transmission &&
//           //                                   bike.makeYear == newBike.makeYear &&
//           //                                   bike.imageUrl == newBike.imageUrl) {
//           //                                 showCustomSnackBar(
//           //                                   message:
//           //                                       StringUtils
//           //                                           .pleaseChangeTheDataBeforeSaving,
//           //                                 );
//           //                                 isProcessing = false;
//           //                                 return;
//           //                               }
//           //
//           //                               if (bike == null) {
//           //                                 context.read<BikeBloc>().add(
//           //                                   AddBikeEvent(newBike),
//           //                                 );
//           //                               } else {
//           //                                 context.read<BikeBloc>().add(
//           //                                   UpdateBikeEvent(newBike),
//           //                                 );
//           //                               }
//           //                               context.read<BikeBloc>().add(
//           //                                 FetchBikesEvent(),
//           //                               );
//           //                               isProcessing = false;
//           //                               Get.back();
//           //                               showCustomSnackBar(
//           //                                 message:
//           //                                     StringUtils.bikeAddedSuccessfully,
//           //                               );
//           //                             } catch (e) {
//           //                               logs("----e---${e.toString()}");
//           //                             }
//           //                           } else {
//           //                             logs("---NOT VALIDATE");
//           //                           }
//           //                         },
//           //                 bgColor:
//           //                     (isProcessing || !isValid.value)
//           //                         ? ColorUtils.primary.withValues(alpha: 0.4)
//           //                         : ColorUtils.primary,
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//         ),
//       ),
//     ),
//     isScrollControlled: true,
//   ).then((value) {
//     // (bikeImage = File(''));
//   });
// }
//
// Future<void> profileScreenDialogBox({
//   required BuildContext context,
//
//   VoidCallback? onTap,
//   VoidCallback? onTap2,
//   String? text,
// }) {
//   return showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//         contentPadding: EdgeInsets.zero,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(height: 5.h),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: CustomText(
//                 text ?? '',
//                 fontWeight: FontWeight.w600,
//                 fontSize: 18,
//               ),
//             ),
//             const Divider(color: ColorUtils.grey99, thickness: 0.5),
//             InkWell(
//               onTap: () {
//                 Navigator.of(context).pop();
//                 if (onTap != null) onTap();
//               },
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CustomText(
//                       StringUtils.takePhoto,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 15.sp,
//                     ),
//                     Icon(Icons.camera_alt_outlined),
//                   ],
//                 ),
//               ),
//             ),
//             const Divider(color: ColorUtils.grey99, thickness: 0.5),
//             InkWell(
//               onTap: () {
//                 Navigator.of(context).pop();
//                 if (onTap2 != null) onTap2();
//               },
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CustomText(
//                       StringUtils.chooseFromGalary,
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     Icon(Icons.photo),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 5.h),
//           ],
//         ),
//       );
//     },
//   );
// }
//
// // void confirmDelete(int id) {
// //   final BikeController bikeController = Get.find<BikeController>();
// //   var isProcessing = false;
// //   Get.defaultDialog(
// //     title: StringUtils.deleteBike,
// //     middleText: StringUtils.deleteConfirmation,
// //     textConfirm: StringUtils.delete,
// //     textCancel: StringUtils.cancel,
// //     cancelTextColor: ColorUtils.black,
// //     confirmTextColor: ColorUtils.black,
// //     onConfirm: () async {
// //       isProcessing = true;
// //       // isProcessing.value = true;
// //       await Future.delayed(Duration(milliseconds: 300));
// //       await bikeController.deleteBike(id);
// //       await bikeController.fetchBikes();
// //       isProcessing = false;
// //       // isProcessing.value = false;
// //       Get.back();
// //     },
// //   );
// // }
