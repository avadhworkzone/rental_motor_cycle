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
  ).then((value) {
    // (bikeController.bikeImage.value = File(''));
  });
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
