import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/my_bike/dialogs/my_bike_dialogs.dart';
import '../../controller/bike_controller.dart';
import '../../controller/employee_controller.dart';

class MyBikesScreen extends StatefulWidget {
  const MyBikesScreen({super.key});
  @override
  State<MyBikesScreen> createState() => _MyBikesScreenState();
}

class _MyBikesScreenState extends State<MyBikesScreen> {
  final BikeController bikeController = Get.find<BikeController>();
  final EmployeeController employeeController = Get.find<EmployeeController>();
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController roomDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.myBikes,
        context: context,
        isLeading: true,
        isCenterTitle: true,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        backgroundColor: ColorUtils.primary,
        fontColor: ColorUtils.white,
        iconColor: ColorUtils.white,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddBikeBottomSheet(context),
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (bikeController.bikeList.isEmpty) {
          return Center(
            child: CustomText(
              StringUtils.noBikesFound,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: bikeController.bikeList.length,
          shrinkWrap: true,
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
                margin: EdgeInsets.only(bottom: 12.w),
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bike Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            bike.imageUrl?.isNotEmpty ?? false
                                ? Image.file(
                                  File(bike.imageUrl ?? ""),
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

                      SizedBox(width: 12.w),

                      // Bike Info & Actions
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              bike.brandName ?? "",
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
                            // CustomText(
                            //   "💰 ${bike.rentPerDay?.toStringAsFixed(2)} ${StringUtils.perDay}",
                            //   fontWeight: FontWeight.bold,
                            //   fontSize: 15.sp,
                            //   color: ColorUtils.primary,
                            // ),

                            // Action Buttons
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FloatingActionButton.extended(
                                  onPressed:
                                      () => showAddBikeBottomSheet(
                                        context,
                                        bike: bike,
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
                                  onPressed: () => confirmDelete(bike.id ?? 0),
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
