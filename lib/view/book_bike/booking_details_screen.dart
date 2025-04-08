// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
// import 'package:rental_motor_cycle/model/booking_model.dart';
// import 'package:get/get.dart';
// import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
// import 'package:rental_motor_cycle/utils/color_utils.dart';
// import 'package:rental_motor_cycle/utils/string_utils.dart';
//
// class BookingDetailsScreen extends StatelessWidget {
//   final BookingModel booking;
//
//   const BookingDetailsScreen({super.key, required this.booking});
//   String formatDateTime(DateTime date, String timeString) {
//     final formattedDate = DateFormat('dd MMM yyyy').format(date);
//
//     String formattedTime;
//     try {
//       final parsedTime = DateFormat('hh:mm a').parse(timeString);
//       formattedTime = DateFormat('hh:mm a').format(parsedTime);
//     } catch (e) {
//       formattedTime = timeString;
//     }
//
//     return "$formattedDate at $formattedTime";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: commonAppBar(
//         titleText: StringUtils.bookingDetails,
//         context: context,
//         isLeading: true,
//         isCenterTitle: true,
//         fontSize: 20.sp,
//         fontWeight: FontWeight.w600,
//       ),
//       // appBar: AppBar(title: CustomText(StringUtils.bookingDetails)),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomText(
//               booking.userFullName.capitalizeFirst ?? "",
//               textAlign: TextAlign.center,
//               fontSize: 22.sp,
//               fontWeight: FontWeight.bold,
//             ),
//             SizedBox(height: 10),
//             _buildInfoRow(
//               Icons.phone,
//               "${StringUtils.phone}: ${booking.userPhone}",
//             ),
//             _buildInfoRow(
//               Icons.email,
//               "${StringUtils.email}: ${booking.userEmail}",
//             ),
//             _buildInfoRow(
//               Icons.insert_invitation,
//               "${StringUtils.pickUp}: ${formatDateTime(booking.pickupDate, booking.pickupTime)}",
//             ),
//
//             _buildInfoRow(
//               Icons.insert_invitation,
//               "${StringUtils.drop}: ${formatDateTime(booking.dropoffDate, booking.dropoffTime)}",
//             ),
//
//             SizedBox(height: 16.h),
//             Divider(thickness: 1, height: 24.h),
//             _buildPriceRow(StringUtils.rentPerDay, booking.rentPerDay),
//             _buildPriceRow(StringUtils.discount, booking.discount),
//             _buildPriceRow(StringUtils.deposit, booking.prepayment),
//             _buildPriceRow(
//               StringUtils.grandTotal,
//               booking.finalAmountPayable,
//               isBold: true,
//             ),
//             SizedBox(height: 50.h),
//             Center(
//               child: Container(
//                 width: 200.w,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30.r),
//                   border: Border.all(color: ColorUtils.grey99, width: 1.w),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(20.w),
//                   child: Center(
//                     child: InkWell(
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: CustomText(
//                         StringUtils.back,
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String text) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: Row(
//         children: [
//           Icon(icon, size: 20.sp, color: ColorUtils.grey99),
//           SizedBox(width: 8),
//           Expanded(child: CustomText(text, fontSize: 16.sp)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPriceRow(
//     String label,
//     double amount, {
//     bool isBold = false,
//     Color? color,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 2.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CustomText(
//             label,
//             fontSize: 16.sp,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//           ),
//           CustomText(
//             "\$${amount.toStringAsFixed(2)}",
//             fontSize: 16.sp,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             color: color,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsScreen({super.key, required this.booking});

  String formatDateTime(DateTime date, String timeString) {
    final formattedDate = DateFormat('dd MMM yyyy').format(date);
    String formattedTime;
    try {
      final parsedTime = DateFormat('hh:mm a').parse(timeString);
      formattedTime = DateFormat('hh:mm a').format(parsedTime);
    } catch (e) {
      formattedTime = timeString;
    }
    return "$formattedDate at $formattedTime";
  }

  String formatSimpleDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  String formatCurrency(double value) {
    return NumberFormat.currency(locale: 'en_IN', symbol: '\$').format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.bookingDetails,
        context: context,
        isLeading: true,
        isCenterTitle: true,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                StringUtils.userInfo,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 6.h),
              _buildInfoRow(
                Icons.person,
                booking.userFullName.capitalizeFirst ?? "",
              ),
              _buildInfoRow(
                Icons.phone,
                "${StringUtils.phone}: ${booking.userPhone}",
              ),
              _buildInfoRow(
                Icons.email,
                "${StringUtils.email}: ${booking.userEmail}",
              ),

              SizedBox(height: 30.h),
              CustomText(
                StringUtils.bikeDetails,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 6.h),
              _buildInfoRow(
                Icons.motorcycle,
                "${StringUtils.bike}: ${booking.bikeName} (${booking.bikeModel})",
              ),
              _buildInfoRow(
                Icons.calendar_today,
                "${StringUtils.pickUp}: ${formatDateTime(booking.pickupDate, booking.pickupTime)}",
              ),
              _buildInfoRow(
                Icons.calendar_today_outlined,
                "${StringUtils.drop}: ${formatDateTime(booking.dropoffDate, booking.dropoffTime)}",
              ),

              SizedBox(height: 30.h),
              Divider(thickness: 1),
              SizedBox(height: 10.h),
              CustomText(
                StringUtils.paymentDetails,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 6.h),
              _buildPriceRow(StringUtils.rentPerDay, booking.rentPerDay),
              _buildPriceRow(StringUtils.duration, booking.durationInHours),
              _buildPriceRow(StringUtils.totalRent, booking.totalRent),
              if (booking.discount > 0)
                _buildPriceRow(StringUtils.discount, booking.discount),
              if (booking.prepayment > 0)
                _buildPriceRow(StringUtils.deposit, booking.prepayment),
              SizedBox(height: 6.h),
              _buildPriceRow(
                StringUtils.grandTotal,
                booking.finalAmountPayable,
                isBold: true,
              ),

              Divider(thickness: 1, height: 24.h),

              _buildInfoRow(
                Icons.access_time,
                "${StringUtils.bookedOn}: ${formatSimpleDate(booking.createdAt)}",
              ),

              SizedBox(height: 40.h),
              Center(
                child: Container(
                  width: 200.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: ColorUtils.grey99, width: 1.w),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Center(
                        child: CustomText(
                          StringUtils.back,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: ColorUtils.grey99),
          SizedBox(width: 8.w),
          Expanded(child: CustomText(text, fontSize: 16.sp)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            label,
            fontSize: 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
          CustomText(
            formatCurrency(amount),
            fontSize: 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? ColorUtils.primary : null,
          ),
        ],
      ),
    );
  }
}
