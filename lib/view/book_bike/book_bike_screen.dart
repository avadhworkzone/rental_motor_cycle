import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../../controller/bike_controller.dart';

class BookBikeScreen extends StatefulWidget {
  const BookBikeScreen({super.key});

  @override
  State<BookBikeScreen> createState() => _BookBikeScreenState();
}

class _BookBikeScreenState extends State<BookBikeScreen> {
  final BikeController bikeController = Get.find<BikeController>();

  @override
  void initState() {
    initMethod();
    super.initState();
  }

  initMethod() async {
    await bikeController.fetchBikes();
  }

  final fromDate = Rxn<DateTime>();
  final toDate = Rxn<DateTime>();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.bookBike,
        context: context,
        isLeading: false,
        isCenterTitle: false,
        fontSize: 20.sp,
        fontColor: ColorUtils.white,
        backgroundColor: ColorUtils.primary,
        fontWeight: FontWeight.w600,
      ),
      body: Obx(
        () =>
            bikeController.bikeList.isEmpty
                ? Center(child: CustomText(StringUtils.noBookedBikes))
                : ListView.builder(
                  itemCount: bikeController.bikeList.length,
                  itemBuilder: (context, index) {
                    final bike = bikeController.bikeList[index];
                    return _buildBikeDetailsView(bike);
                  },
                ),
      ),
    );
  }

  Widget _buildBikeDetailsView(BikeModel bike) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    "${bike.brandName} ${bike.model}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.file(
                File(bike.imageUrl ?? ""),
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(Icons.settings, bike.transmission ?? ""),
                _iconText(
                  Icons.event_seat,
                  "${bike.seater} ${StringUtils.seater}",
                ),
                _iconText(Icons.local_gas_station, bike.fuelType ?? ""),
              ],
            ),
            Divider(height: 12.h, color: Colors.grey.shade300),
            SizedBox(height: 8.h),

            CustomText(
              "${StringUtils.availableAt} ${bike.location}",
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),

            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textRow(
                      "${StringUtils.kmLimit}: ",
                      "${bike.kmLimit} ${StringUtils.km}",
                    ),
                    _textRow("", bike.fuelIncluded ?? ""),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.selectDateTimeForBookingScreen,
                      arguments: {'bike': bike, 'booking': null},
                      // arguments: bike,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: CustomText(
                    StringUtils.bookNow,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Divider(height: 16.h, color: Colors.grey.shade300),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _textRow("${StringUtils.makeYear}: ", bike.makeYear.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: Colors.black54),
        SizedBox(width: 4.w),
        CustomText(text, fontSize: 12.sp, fontWeight: FontWeight.w500),
      ],
    );
  }

  Widget _textRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          CustomText(
            label,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
          CustomText(
            value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}
