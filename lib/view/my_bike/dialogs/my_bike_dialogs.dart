import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/common_dropdown.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/controller/bike_controller.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';

void showAddBikeBottomSheet(
  BuildContext context,
  GlobalKey<FormState> key, {
  BikeModel? bike,
  required RxBool isProcessing,
}) {
  final BikeController bikeController = Get.find<BikeController>();
  final TextEditingController nameController = TextEditingController(
    text: bike?.name ?? "",
  );
  final TextEditingController modelController = TextEditingController(
    text: bike?.model ?? "",
  );
  final TextEditingController numberPlateController = TextEditingController(
    text: bike?.numberPlate ?? "",
  );
  final TextEditingController rentController = TextEditingController(
    text: bike?.rentPerDay.toStringAsFixed(0) ?? "",
  );
  final TextEditingController locationController = TextEditingController(
    text: bike?.location ?? "",
  );
  final TextEditingController fuelTypeController = TextEditingController(
    text: bike?.fuelType ?? "",
  );
  final TextEditingController mileageController = TextEditingController(
    text: bike?.mileage.toStringAsFixed(0) ?? "",
  );
  final TextEditingController ccController = TextEditingController(
    text: bike?.engineCC.toStringAsFixed(0) ?? "",
  );
  final TextEditingController descriptionController = TextEditingController(
    text: bike?.description ?? "",
  );
  final TextEditingController depositController = TextEditingController(
    text: bike?.deposit.toStringAsFixed(0) ?? "",
  );
  final TextEditingController extraPerKmController = TextEditingController(
    text: bike?.extraPerKm.toStringAsFixed(0) ?? "",
  );
  final TextEditingController kmLimitController = TextEditingController(
    text: bike?.kmLimit.toStringAsFixed(0) ?? "",
  );
  final TextEditingController tripsDoneController = TextEditingController(
    text: bike?.tripsDone.toString() ?? "",
  );
  final TextEditingController makeYearController = TextEditingController(
    text: bike?.makeYear.toString() ?? "",
  );

  String? selectedTransmission = bike?.transmission;
  String? selectedSeater = bike?.seater.toString();
  String? selectedFuelIncluded = bike?.fuelIncluded;

  if (bike != null && bike.imageUrl.isNotEmpty) {
    bikeController.bikeImage.value = File(bike.imageUrl);
    bikeController.selectedImagePath.value = bike.imageUrl;
  }

  var isValid = false.obs;

  void validateFields() {
    isValid.value =
        nameController.text.trim().isNotEmpty &&
        modelController.text.trim().isNotEmpty &&
        numberPlateController.text.trim().isNotEmpty &&
        rentController.text.trim().isNotEmpty &&
        locationController.text.trim().isNotEmpty &&
        fuelTypeController.text.trim().isNotEmpty &&
        mileageController.text.trim().isNotEmpty &&
        ccController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        depositController.text.trim().isNotEmpty &&
        extraPerKmController.text.trim().isNotEmpty &&
        kmLimitController.text.trim().isNotEmpty &&
        makeYearController.text.trim().isNotEmpty &&
        tripsDoneController.text.trim().isNotEmpty &&
        selectedTransmission != null &&
        selectedSeater != null &&
        selectedFuelIncluded != null &&
        (bikeController.bikeImage.value != null &&
            bikeController.bikeImage.value!.path.isNotEmpty);
  }

  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorUtils.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                bike == null ? StringUtils.addNewBike : StringUtils.updateBike,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 10.h),

              ///Pick bike image
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorUtils.primary, width: 2.w),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    height: 111.h,
                    width: 111.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorUtils.primary, width: 2.w),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Obx(() {
                          return Center(
                            child:
                                (bikeController.bikeImage.value?.path.isEmpty ??
                                        true)
                                    ? Icon(
                                      Icons.supervised_user_circle,
                                      size: 50.sp,
                                    )
                                    : Container(
                                      height: 111.h,
                                      width: 111.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: FileImage(
                                            bikeController.bikeImage.value ??
                                                File(''),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                          );
                        }),
                        Positioned(
                          right: -4.w,
                          bottom: -10.h,
                          child: IconButton(
                            onPressed: () {
                              profileScreenDialogBox(
                                context: context,
                                text: StringUtils.addBikeImage,
                                onTap: () async {
                                  await bikeController.selectImageCamera(
                                    context,
                                  );
                                  validateFields();
                                },
                                onTap2: () async {
                                  await bikeController.selectImage(context);
                                  validateFields();
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
              ),
              SizedBox(height: 10.h),

              CommonTextField(
                textEditController: nameController,
                labelText: StringUtils.bikeName,
                keyBoardType: TextInputType.name,
                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterBikeName : null,
                onChange: (_) => validateFields(),
              ),
              CommonTextField(
                textEditController: modelController,
                labelText: StringUtils.bikeModel,
                keyBoardType: TextInputType.name,
                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterBikeModel : null,
                onChange: (_) => validateFields(),
              ),
              CommonTextField(
                textEditController: numberPlateController,
                labelText: StringUtils.numberPlate,
                keyBoardType: TextInputType.name,
                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterNumberPlate : null,
                onChange: (_) => validateFields(),
              ),
              CommonTextField(
                textEditController: rentController,
                labelText: StringUtils.rentPerDay,
                keyBoardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterRentPrice : null,
                onChange: (_) => validateFields(),
              ),
              CommonTextField(
                textEditController: locationController,
                labelText: StringUtils.bikeLocation,
                keyBoardType: TextInputType.name,
                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterLocation : null,
                onChange: (_) => validateFields(),
              ),
              CommonDropdown(
                items: [
                  StringUtils.petrol,
                  StringUtils.diesel,
                  StringUtils.electric,
                ],
                labelText: StringUtils.fuelType,
                selectedValue:
                    fuelTypeController.text.isNotEmpty
                        ? fuelTypeController.text
                        : null,
                onChanged: (value) {
                  fuelTypeController.text = value ?? "";
                  validateFields();
                },
                validationMessage: StringUtils.selectFuelType,
              ),
              CommonTextField(
                textEditController: mileageController,
                labelText: StringUtils.mileage,
                keyBoardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? StringUtils.enterMileage : null,
                onChange: (_) => validateFields(),
              ),
              CommonTextField(
                textEditController: ccController,
                labelText: StringUtils.engineCC,
                keyBoardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterEngineCC : null,
                onChange: (_) => validateFields(),
              ),
              // CommonDropdown for Transmission
              CommonDropdown(
                items: [
                  StringUtils.automatic,
                  StringUtils.manual,
                  StringUtils.semiAutomatic,
                ],
                labelText: StringUtils.transmission,
                selectedValue: selectedTransmission,
                onChanged: (value) {
                  selectedTransmission = value;
                  validateFields();
                },
                validationMessage: StringUtils.selectTransmission,
              ),
              CommonDropdown(
                items: ["1", "2", "3", "4", "5", "6"],
                labelText: StringUtils.seater,
                selectedValue: selectedSeater,
                onChanged: (value) {
                  selectedSeater = value;
                  validateFields();
                },
                validationMessage: StringUtils.selectSeater,
              ),
              CommonDropdown(
                items: [StringUtils.included, StringUtils.excluded],
                labelText: StringUtils.fuel,
                selectedValue: selectedFuelIncluded,
                onChanged: (value) {
                  selectedFuelIncluded = value;
                  validateFields();
                },
                validationMessage: StringUtils.selectFuelOption,
              ),
              CommonTextField(
                textEditController: depositController,
                labelText: "${StringUtils.deposit} (\$)",
                keyBoardType: TextInputType.number,
                onChange: (_) => validateFields(),
                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterDepositAmount : null,
              ),
              CommonTextField(
                textEditController: extraPerKmController,
                labelText: StringUtils.extraPerKm,
                keyBoardType: TextInputType.number,
                onChange: (_) => validateFields(),
                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterExtraKmRate : null,
              ),
              CommonTextField(
                textEditController: kmLimitController,
                labelText: StringUtils.kmLimit,
                keyBoardType: TextInputType.number,
                onChange: (_) => validateFields(),
                validator:
                    (value) => value!.isEmpty ? StringUtils.enterKmLimit : null,
              ),
              CommonTextField(
                textEditController: makeYearController,
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
                                DateTime.tryParse(makeYearController.text) ??
                                DateTime(currentYear),
                            onChanged: (DateTime dateTime) {
                              Navigator.of(context).pop(dateTime.year);
                            },
                          ),
                        ),
                      );
                    },
                  );

                  if (selectedYear != null) {
                    makeYearController.text = selectedYear.toString();
                    validateFields();
                  }
                },

                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterMakeYear : null,
              ),
              CommonTextField(
                textEditController: tripsDoneController,
                labelText: StringUtils.tripsDone,
                keyBoardType: TextInputType.number,
                onChange: (_) => validateFields(),
                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterTripsDone : null,
              ),
              CommonTextField(
                textEditController: descriptionController,
                labelText: StringUtils.bikeDescription,
                keyBoardType: TextInputType.name,
                onChange: (_) => validateFields(),
                validator:
                    (value) =>
                        value!.isEmpty ? StringUtils.enterDescription : null,
                maxLine: 3,
              ),
              SizedBox(height: 20),

              Obx(
                () => CustomBtn(
                  title:
                      bike == null
                          ? StringUtils.addBike
                          : StringUtils.updateBike,
                  onTap:
                      (isProcessing.value || !isValid.value)
                          ? null
                          : () async {
                            if (key.currentState?.validate() ?? false) {
                              try {
                                isProcessing.value = true;
                                var userId =
                                    await SharedPreferenceUtils.getString(
                                      SharedPreferenceUtils.userId,
                                    );
                                logs('User ID ---> $userId');
                                if (!isValid.value) return;

                                BikeModel newBike = BikeModel(
                                  id: bike?.id,
                                  name: nameController.text.trim(),
                                  model: modelController.text.trim(),
                                  numberPlate:
                                      numberPlateController.text.trim(),
                                  rentPerDay: double.parse(
                                    rentController.text.trim(),
                                  ),
                                  location: locationController.text.trim(),
                                  fuelType: fuelTypeController.text.trim(),
                                  mileage: num.parse(
                                    mileageController.text.trim(),
                                  ),
                                  engineCC: num.parse(ccController.text.trim()),
                                  description:
                                      descriptionController.text.trim(),
                                  imageUrl:
                                      bikeController.selectedImagePath.value,
                                  createdAt: DateTime.now(),
                                  userId: int.parse(userId),
                                  deposit: double.parse(
                                    depositController.text.trim(),
                                  ),
                                  extraPerKm: double.parse(
                                    extraPerKmController.text.trim(),
                                  ),
                                  kmLimit: double.parse(
                                    kmLimitController.text.trim(),
                                  ),
                                  makeYear: int.parse(
                                    makeYearController.text.trim(),
                                  ),
                                  tripsDone: int.parse(
                                    tripsDoneController.text.trim(),
                                  ),
                                  transmission: selectedTransmission!,
                                  seater: int.parse(selectedSeater!),
                                  fuelIncluded: selectedFuelIncluded!,
                                );

                                if (bike != null &&
                                    bike.name == newBike.name &&
                                    bike.model == newBike.model &&
                                    bike.numberPlate == newBike.numberPlate &&
                                    bike.rentPerDay == newBike.rentPerDay &&
                                    bike.location == newBike.location &&
                                    bike.fuelType == newBike.fuelType &&
                                    bike.mileage == newBike.mileage &&
                                    bike.engineCC == newBike.engineCC &&
                                    bike.description == newBike.description &&
                                    bike.imageUrl == newBike.imageUrl) {
                                  showCustomSnackBar(
                                    message:
                                        StringUtils
                                            .pleaseChangeTheDataBeforeSaving,
                                  );
                                  isProcessing.value = false;
                                  return;
                                }

                                if (bike == null) {
                                  await bikeController.addBike(newBike);
                                } else {
                                  await bikeController.updateBike(newBike);
                                }
                                await bikeController.fetchBikes();
                                isProcessing.value = false;
                                Get.back();
                                showCustomSnackBar(
                                  message: StringUtils.bikeAddedSuccessfully,
                                );
                              } catch (e) {
                                logs("----e---${e.toString()}");
                              }
                            } else {
                              logs("---NOT VALIDATE");
                            }
                          },
                  bgColor:
                      (isProcessing.value || !isValid.value)
                          ? ColorUtils.primary.withOpacity(0.4)
                          : ColorUtils.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  ).then((value) {
    (bikeController.bikeImage.value = File(''));
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

void confirmDelete(int id, RxBool isProcessing) {
  final BikeController bikeController = Get.find<BikeController>();
  Get.defaultDialog(
    title: StringUtils.deleteBike,
    middleText: StringUtils.deleteConfirmation,
    textConfirm: StringUtils.delete,
    textCancel: StringUtils.cancel,
    cancelTextColor: ColorUtils.black,
    confirmTextColor: ColorUtils.black,
    onConfirm: () async {
      isProcessing.value = true;
      // isProcessing.value = true;
      await Future.delayed(Duration(milliseconds: 300));
      await bikeController.deleteBike(id);
      await bikeController.fetchBikes();
      isProcessing.value = false;
      // isProcessing.value = false;
      Get.back();
    },
  );
}
