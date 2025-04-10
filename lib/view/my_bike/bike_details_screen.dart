import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../../utils/color_utils.dart';

class BikeDetailsScreen extends StatelessWidget {
  BikeDetailsScreen({super.key});
  final bike = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.white,
      appBar: commonAppBar(
        titleText: bike.name,
        context: context,
        isLeading: true,
        isCenterTitle: true,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            /// Bike Image
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                width: double.infinity,
                height: 280.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      bike.imageUrl.isNotEmpty
                          ? Image.file(File(bike.imageUrl), fit: BoxFit.cover)
                          : Container(
                            color: ColorUtils.grey55,
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 60,
                                color: ColorUtils.grey99,
                              ),
                            ),
                          ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Bike Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailCard(
                    StringUtils.model,
                    bike.model,
                    Icons.directions_bike,
                  ),
                  _detailCard(
                    StringUtils.vehicleNumber,
                    bike.vehicleNumber,
                    Icons.confirmation_number,
                  ),
                  _detailCard(
                    StringUtils.rentPerDay,
                    "\$${bike.rentPerDay.toStringAsFixed(2)}",
                    Icons.attach_money,
                  ),
                  _detailCard(
                    StringUtils.location,
                    bike.location,
                    Icons.location_on,
                  ),
                  _detailCard(
                    StringUtils.fuelType,
                    bike.fuelType,
                    Icons.local_gas_station,
                  ),
                  _detailCard(
                    StringUtils.mileage,
                    "${bike.mileage} km/l",
                    Icons.speed,
                  ),
                  _detailCard(
                    StringUtils.engineCC,
                    "${bike.engineCC} CC",
                    Icons.engineering,
                  ),
                  _detailCard(
                    StringUtils.description,
                    bike.description,
                    Icons.description,
                  ),
                  SizedBox(height: 25.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Detail Card Widget
  Widget _detailCard(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: ColorUtils.primary, size: 22.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.black21,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  value,
                  fontSize: 14.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
