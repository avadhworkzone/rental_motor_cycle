import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../controller/bike_controller.dart';
import '../controller/user_controller.dart';

class MyBikesScreen extends StatefulWidget {
  const MyBikesScreen({super.key});
  @override
  State<MyBikesScreen> createState() => _MyBikesScreenState();
}

class _MyBikesScreenState extends State<MyBikesScreen> {
  final BikeController bikeController = Get.find<BikeController>();
  final UserController userController = Get.find<UserController>();
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController roomDescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isProcessing = false.obs;

  void showAddBikeBottomSheet(BuildContext context, {BikeModel? bike}) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController modelController = TextEditingController();
    final TextEditingController numberPlateController = TextEditingController();
    final TextEditingController rentController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController fuelTypeController = TextEditingController();
    final TextEditingController mileageController = TextEditingController();
    final TextEditingController ccController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    var isValid = false.obs;
    void validateFields() {
      isValid.value =
          nameController.text.isNotEmpty &&
          modelController.text.isNotEmpty &&
          numberPlateController.text.isNotEmpty &&
          rentController.text.isNotEmpty &&
          locationController.text.isNotEmpty &&
          fuelTypeController.text.isNotEmpty &&
          mileageController.text.isNotEmpty &&
          ccController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty;
    }

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        height: 600.h, // Adjust height as needed
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add New Bike",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),

                // Bike Name
                CommonTextField(
                  textEditController: nameController,
                  labelText: "Bike Name",
                  validator:
                      (value) => value!.isEmpty ? "Enter Bike Name" : null,
                  onChange: (_) => validateFields(),
                ),
                SizedBox(height: 10.h),

                // Bike Model
                CommonTextField(
                  textEditController: modelController,
                  labelText: "Bike Model",
                  validator:
                      (value) => value!.isEmpty ? "Enter Bike Model" : null,
                  onChange: (_) => validateFields(),
                ),
                SizedBox(height: 10.h),

                // Bike Number Plate
                CommonTextField(
                  textEditController: numberPlateController,
                  labelText: "Number Plate",
                  validator:
                      (value) => value!.isEmpty ? "Enter Number Plate" : null,
                  onChange: (_) => validateFields(),
                ),
                SizedBox(height: 10.h),

                // Rent Per Day
                CommonTextField(
                  textEditController: rentController,
                  labelText: "Rent Per Day (₹)",
                  keyBoardType: TextInputType.number,
                  validator:
                      (value) => value!.isEmpty ? "Enter Rent Price" : null,
                  onChange: (_) => validateFields(),
                ),
                SizedBox(height: 10.h),

                // Location
                CommonTextField(
                  textEditController: locationController,
                  labelText: "Bike Location",
                  validator:
                      (value) => value!.isEmpty ? "Enter Location" : null,
                  onChange: (_) => validateFields(),
                ),
                SizedBox(height: 10.h),

                // Fuel Type
                CommonTextField(
                  textEditController: fuelTypeController,
                  labelText: "Fuel Type (Petrol/Diesel/Electric)",
                  validator:
                      (value) => value!.isEmpty ? "Enter Fuel Type" : null,
                  onChange: (_) => validateFields(),
                ),
                SizedBox(height: 10.h),

                // Mileage
                CommonTextField(
                  textEditController: mileageController,
                  labelText: "Mileage (km/l)",
                  keyBoardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter Mileage" : null,
                  onChange: (_) => validateFields(),
                ),
                SizedBox(height: 10.h),

                // Engine CC
                CommonTextField(
                  textEditController: ccController,
                  labelText: "Engine CC",
                  keyBoardType: TextInputType.number,
                  validator:
                      (value) => value!.isEmpty ? "Enter Engine CC" : null,
                  onChange: (_) => validateFields(),
                ),
                SizedBox(height: 10.h),

                // Description
                CommonTextField(
                  textEditController: descriptionController,
                  labelText: "Bike Description",
                  maxLine: 3,
                  validator:
                      (value) => value!.isEmpty ? "Enter Description" : null,
                  onChange: (_) => validateFields(),
                ),
                SizedBox(height: 20.h),

                // Add Bike Button
                Obx(
                  () => CustomBtn(
                    title: bike == null ? "Add Bike" : "Update Bike",
                    onTap:
                        (isProcessing.value || !isValid.value)
                            ? null
                            : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                isProcessing.value = true;
                                var userId =
                                    await SharedPreferenceUtils.getString(
                                      SharedPreferenceUtils.userId,
                                    );
                                log('User ID ---> $userId');
                                BikeModel newBike = BikeModel(
                                  userId: int.parse(userId),
                                  name: nameController.text.trim(),
                                  model: modelController.text.trim(),
                                  numberPlate:
                                      numberPlateController.text.trim(),
                                  rentPerDay:
                                      double.tryParse(
                                        rentController.text.trim(),
                                      ) ??
                                      0.0,

                                  location: locationController.text.trim(),
                                  fuelType: fuelTypeController.text.trim(),
                                  mileage:
                                      double.tryParse(
                                        mileageController.text.trim(),
                                      ) ??
                                      0.0,
                                  engineCC:
                                      int.tryParse(ccController.text.trim()) ??
                                      0,
                                  description:
                                      descriptionController.text.trim(),
                                  createdAt: DateTime.now(),
                                );
                                if (bike == null) {
                                  await bikeController.addBike(newBike);
                                } else {
                                  await bikeController.updateBike(newBike);
                                }
                                await bikeController.fetchBikes();
                                isProcessing.value = false;
                                Get.back();
                                showCustomSnackBar(
                                  message: "Bike Added Successfully!",
                                );
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
    );
  }

  void confirmDelete(int id) {
    Get.defaultDialog(
      title: "Delete Room",
      middleText: "Are you sure you want to delete this room?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        isProcessing.value = true;
        await Future.delayed(Duration(milliseconds: 300));
        await bikeController.deleteBike(id);
        await bikeController.fetchBikes();
        isProcessing.value = false;
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log("--bikeList----${bikeController.bikeList.length}");
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.myBikes,
        context: context,
        isLeading: false,
        isCenterTitle: false,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddBikeBottomSheet(context),
        child: Icon(Icons.add),
      ),
      body: Obx(
        () =>
            bikeController.bikeList.isEmpty
                ? Center(child: Text("No bikes found. Add a new bike!"))
                : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: bikeController.bikeList.length,
                        itemBuilder: (context, index) {
                          final bike = bikeController.bikeList[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 10,
                            ),
                            child: ListTile(
                              title: Text(
                                bike.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Room ID: ${room.id}\n${room.roomDesc}"),
                              subtitle: Text(bike.numberPlate),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    // onPressed: () {},
                                    onPressed:
                                        () => showAddBikeBottomSheet(
                                          context,
                                          bike: bike,
                                        ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed:
                                        () => confirmDelete(bike.id ?? 0),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(20),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       // exportRoomsAsPDF(roomController.roomList);
                    //       // Get.snackbar("Export Successful",
                    //       //     "PDF saved in documents folder!");
                    //     },
                    //     child: Text("Export Rooms as PDF"),
                    //   ),
                    // ),
                  ],
                ),
      ),
    );
  }
}
