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

void showAddBikeBottomSheet(BuildContext context, {BikeModel? bike}) {
  final formKey = GlobalKey<FormState>();
  var isProcessing = false;
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
      child: FractionallySizedBox(
        heightFactor: 0.75.w,
        child: Form(
          key: formKey,
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
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
                                Obx(() {
                                  return Center(
                                    child:
                                        (bikeController
                                                    .bikeImage
                                                    .value
                                                    ?.path
                                                    .isEmpty ??
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
                                                    bikeController
                                                            .bikeImage
                                                            .value ??
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
                                          await bikeController
                                              .selectImageCamera(context);
                                          validateFields();
                                        },
                                        onTap2: () async {
                                          await bikeController.selectImage(
                                            context,
                                          );
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

                      ///bikeBrand
                      Obx(
                        () => CommonDropdown(
                          items: [
                            StringUtils.bikeBrandHonda,
                            StringUtils.bikeBrandYamaha,
                            StringUtils.bikeBrandSuzuki,
                          ],
                          labelText: StringUtils.bikeBrand,
                          selectedValue: selectedBrand.value,
                          onChanged: onBrandChanged,
                          validationMessage: StringUtils.selectBikeBrand,
                        ),
                      ),

                      ///bikeModel
                      Obx(
                        () => CommonDropdown(
                          items:
                              selectedModel.value.isNotEmpty
                                  ? [selectedModel.value]
                                  : [],
                          labelText: StringUtils.bikeModel,
                          selectedValue: selectedModel.value,
                          onChanged: null,
                          validationMessage: StringUtils.selectBikeModel,
                        ),
                      ),

                      ///vehicleNumber
                      CommonTextField(
                        textEditController: numberPlateController,
                        labelText: StringUtils.vehicleNumber,
                        keyBoardType: TextInputType.name,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? StringUtils.enterVehicleNumber
                                    : null,
                        onChange: (_) => validateFields(),
                      ),

                      ///bikeLocation
                      CommonTextField(
                        textEditController: locationController,
                        labelText: StringUtils.bikeLocation,
                        keyBoardType: TextInputType.name,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? StringUtils.enterLocation
                                    : null,
                        onChange: (_) => validateFields(),
                      ),

                      ///fuelType
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

                      ///engineCC
                      CommonTextField(
                        textEditController: ccController,
                        labelText: StringUtils.engineCC,
                        keyBoardType: TextInputType.number,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? StringUtils.enterEngineCC
                                    : null,
                        onChange: (_) => validateFields(),
                      ),

                      ///transmission
                      Obx(
                        () => CommonDropdown(
                          items:
                              selectedTransmission.value.isNotEmpty
                                  ? [selectedTransmission.value]
                                  : [],
                          labelText: StringUtils.transmission,
                          selectedValue: selectedTransmission.value,
                          onChanged: null,
                          validationMessage: StringUtils.selectTransmission,
                        ),
                      ),

                      ///seater
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

                      ///fuel
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

                      ///kmLimit
                      CommonTextField(
                        textEditController: kmLimitController,
                        labelText: StringUtils.kmLimit,
                        keyBoardType: TextInputType.number,
                        onChange: (_) => validateFields(),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? StringUtils.enterKmLimit
                                    : null,
                      ),

                      ///makeYear
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
                                        DateTime.tryParse(
                                          makeYearController.text,
                                        ) ??
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
                                value!.isEmpty
                                    ? StringUtils.enterMakeYear
                                    : null,
                      ),

                      ///bikeDescription
                      CommonTextField(
                        textEditController: descriptionController,
                        labelText: StringUtils.bikeDescription,
                        keyBoardType: TextInputType.name,
                        onChange: (_) => validateFields(),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? StringUtils.enterDescription
                                    : null,
                        maxLine: 3,
                      ),
                      SizedBox(height: 20),

                      ///Add Update btn
                      Obx(
                        () => CustomBtn(
                          title:
                              bike == null
                                  ? StringUtils.addBike
                                  : StringUtils.updateBike,
                          onTap:
                              (isProcessing || !isValid.value)
                                  ? null
                                  : () async {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      try {
                                        isProcessing = true;
                                        var userId =
                                            await SharedPreferenceUtils.getString(
                                              SharedPreferenceUtils.userId,
                                            );
                                        logs('User ID ---> $userId');
                                        if (!isValid.value) return;

                                        BikeModel newBike = BikeModel(
                                          id: bike?.id,
                                          brandName: selectedBrand.value,
                                          model: selectedModel.value,
                                          numberPlate:
                                              numberPlateController.text.trim(),
                                          location:
                                              locationController.text.trim(),
                                          fuelType:
                                              fuelTypeController.text.trim(),
                                          engineCC: num.parse(
                                            ccController.text.trim(),
                                          ),
                                          description:
                                              descriptionController.text.trim(),
                                          imageUrl:
                                              bikeController
                                                  .selectedImagePath
                                                  .value,
                                          createdAt: DateTime.now(),
                                          userId: int.parse(userId),
                                          kmLimit: double.parse(
                                            kmLimitController.text.trim(),
                                          ),
                                          makeYear: int.parse(
                                            makeYearController.text.trim(),
                                          ),
                                          transmission:
                                              selectedTransmission.value,
                                          seater: int.parse(selectedSeater!),
                                          fuelIncluded: selectedFuelIncluded!,
                                        );

                                        if (bike != null &&
                                            bike.brandName ==
                                                newBike.brandName &&
                                            bike.model == newBike.model &&
                                            bike.numberPlate ==
                                                newBike.numberPlate &&
                                            bike.fuelIncluded ==
                                                newBike.fuelIncluded &&
                                            bike.location == newBike.location &&
                                            bike.fuelType == newBike.fuelType &&
                                            bike.kmLimit == newBike.kmLimit &&
                                            bike.engineCC == newBike.engineCC &&
                                            bike.description ==
                                                newBike.description &&
                                            bike.seater == newBike.seater &&
                                            bike.transmission ==
                                                newBike.transmission &&
                                            bike.makeYear == newBike.makeYear &&
                                            bike.imageUrl == newBike.imageUrl) {
                                          showCustomSnackBar(
                                            message:
                                                StringUtils
                                                    .pleaseChangeTheDataBeforeSaving,
                                          );
                                          isProcessing = false;
                                          return;
                                        }

                                        if (bike == null) {
                                          await bikeController.addBike(newBike);
                                        } else {
                                          await bikeController.updateBike(
                                            newBike,
                                          );
                                        }
                                        await bikeController.fetchBikes();
                                        isProcessing = false;
                                        Get.back();
                                        showCustomSnackBar(
                                          message:
                                              StringUtils.bikeAddedSuccessfully,
                                        );
                                      } catch (e) {
                                        logs("----e---${e.toString()}");
                                      }
                                    } else {
                                      logs("---NOT VALIDATE");
                                    }
                                  },
                          bgColor:
                              (isProcessing || !isValid.value)
                                  ? ColorUtils.primary.withValues(alpha: 0.4)
                                  : ColorUtils.primary,
                        ),
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

void confirmDelete(int id) {
  final BikeController bikeController = Get.find<BikeController>();
  var isProcessing = false;
  Get.defaultDialog(
    title: StringUtils.deleteBike,
    middleText: StringUtils.deleteConfirmation,
    textConfirm: StringUtils.delete,
    textCancel: StringUtils.cancel,
    cancelTextColor: ColorUtils.black,
    confirmTextColor: ColorUtils.black,
    onConfirm: () async {
      isProcessing = true;
      // isProcessing.value = true;
      await Future.delayed(Duration(milliseconds: 300));
      await bikeController.deleteBike(id);
      await bikeController.fetchBikes();
      isProcessing = false;
      // isProcessing.value = false;
      Get.back();
    },
  );
}
