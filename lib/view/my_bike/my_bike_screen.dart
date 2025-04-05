import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/common_dropdown.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/my_bike/dialogs/my_bike_dialogs.dart';
import '../../controller/bike_controller.dart';
import '../../controller/user_controller.dart';

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

  @override
  Widget build(BuildContext context) {
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
        onPressed:
            () => showAddBikeBottomSheet(
              context,
              _formKey,
              isProcessing: isProcessing,
            ),
        child: Icon(Icons.add),
      ),

      body: Obx(() {
        if (bikeController.bikeList.isEmpty) {
          return Center(
            child: CustomText(
              StringUtils.noBikesFound,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: bikeController.bikeList.length,
          itemBuilder: (context, index) {
            final bike = bikeController.bikeList[index];

            return GestureDetector(
              onTap:
                  () =>
                      Get.toNamed(AppRoutes.bikeDetailsScreen, arguments: bike),

              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bike Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            bike.imageUrl.isNotEmpty
                                ? Image.file(
                                  File(bike.imageUrl),
                                  height: 100.w,
                                  width: 120.w,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  height: 100,
                                  width: 120,
                                  color: ColorUtils.grey55,
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: ColorUtils.grey99,
                                  ),
                                ),
                      ),

                      SizedBox(width: 12),

                      // Bike Info & Actions
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              bike.name,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            CustomText(
                              "📍 ${bike.location}",
                              fontSize: 15.sp,
                              color: ColorUtils.grey99,
                            ),
                            SizedBox(height: 4),
                            CustomText(
                              "💰 ${bike.rentPerDay.toStringAsFixed(2)} ${StringUtils.perDay}",
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: ColorUtils.primary,
                            ),

                            // Action Buttons
                            SizedBox(height: 8),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     ElevatedButton.icon(
                            //       onPressed:
                            //           () => showAddBikeBottomSheet(
                            //             context,
                            //             bike: bike,
                            //           ),
                            //       icon: Icon(Icons.edit, size: 18),
                            //       label: Text("Edit"),
                            //       style: ElevatedButton.styleFrom(
                            //         foregroundColor: Colors.white,
                            //         backgroundColor: Colors.blue,
                            //         padding: EdgeInsets.symmetric(
                            //           vertical: 6,
                            //           horizontal: 12,
                            //         ),
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(8),
                            //         ),
                            //       ),
                            //     ),
                            //     ElevatedButton.icon(
                            //       onPressed: () => confirmDelete(bike.id ?? 0),
                            //       icon: Icon(Icons.delete, size: 18),
                            //       label: Text("Delete"),
                            //       style: ElevatedButton.styleFrom(
                            //         foregroundColor: Colors.white,
                            //         backgroundColor: Colors.red,
                            //         padding: EdgeInsets.symmetric(
                            //           vertical: 6,
                            //           horizontal: 12,
                            //         ),
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(8),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FloatingActionButton.extended(
                                  onPressed:
                                      () => showAddBikeBottomSheet(
                                        context,
                                        _formKey,
                                        bike: bike,
                                        isProcessing: isProcessing,
                                      ),
                                  label: CustomText(
                                    StringUtils.edit,
                                    color: ColorUtils.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  icon: Icon(Icons.edit),
                                  backgroundColor: ColorUtils.primary,
                                  elevation: 2,
                                ),
                                SizedBox(width: 10.w),
                                FloatingActionButton.extended(
                                  onPressed:
                                      () => confirmDelete(
                                        bike.id ?? 0,
                                        isProcessing,
                                      ),
                                  label: CustomText(
                                    StringUtils.delete,
                                    color: ColorUtils.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  icon: Icon(Icons.delete),
                                  backgroundColor: ColorUtils.red,
                                  elevation: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
