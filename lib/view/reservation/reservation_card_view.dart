import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_btn.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/controller/bike_booking_controller.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/view/book_bike/booking_details_screen.dart';

class ReservationCardView extends StatelessWidget {
  final bool canEditDelete;
  final BikeModel bike;
  final BookingModel booking;
  final bool isFromToday;

  const ReservationCardView({
    super.key,
    required this.booking,
    this.canEditDelete = true,
    this.isFromToday = false,
    required this.bike,
  });

  @override
  Widget build(BuildContext context) {
    // Assuming booking.pickupDate and booking.dropoffDate are DateTime objects
    final today = DateTime.now();
    final isCurrentBooking =
        !today.isBefore(booking.pickupDate) &&
        !today.isAfter(booking.dropoffDate);
    double taxAmount =
        (booking.subtotal - booking.discount) * (booking.tax / 100);
    return InkWell(
      onTap: () {
        Get.to(() => BookingDetailsScreen(booking: booking));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Header with Name and Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      booking.userFullName,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  canEditDelete == false
                      ? SizedBox()
                      : Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: ColorUtils.primary),
                            onPressed: () {
                              Get.toNamed(
                                AppRoutes.selectDateTimeForBookingScreen,
                                arguments: {'bike': bike, 'booking': booking},
                              );
                            },
                            // onPressed:
                            //     () => showBikeBookingDialog(booking: booking),
                          ),
                          if (!isCurrentBooking)
                            IconButton(
                              icon: Icon(Icons.delete, color: ColorUtils.red),
                              onPressed: () async {
                                await _deleteReservation(booking.id!);
                                await Get.find<BikeBookingController>()
                                    .fetchBookings();
                              },
                            ),
                        ],
                      ),
                ],
              ),
              SizedBox(height: 6),

              /// 🔹 Check-in / Check-out and Contact Info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.calendar_today,
                          "${StringUtils.pickUp}: ${DateFormat('dd/MM/yyyy').format(booking.pickupDate)}",
                        ),
                        _buildInfoRow(
                          Icons.calendar_today_outlined,
                          "${StringUtils.drop}: ${DateFormat('dd/MM/yyyy').format(booking.dropoffDate)}",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.phone, booking.userPhone),
                        _buildInfoRow(Icons.email, booking.userEmail),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              /// 🔹 Divider & Pricing
              if (!isFromToday) ...[
                Divider(thickness: 1, height: 20.h),

                /*  _buildPriceRow(StringUtils.rentPerDay, booking.rentPerDay),
                _buildPriceRow(StringUtils.subtotal, booking.totalRent),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(StringUtils.tax, fontWeight: FontWeight.w500),
                      CustomText(
                        "${booking.tax}%",
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ),
                _buildPriceRow(StringUtils.discount, booking.discount),
                _buildPriceRow(
                  StringUtils.grandTotal,
                  booking.finalAmountPayable,
                  isBold: true,
                ),
                _buildPriceRow(StringUtils.prepayment, booking.prepayment),*/

                ///
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              StringUtils.bikeBrand,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              booking.bikes
                                  .map((e) => e.brandName)
                                  .toList()
                                  .join(','),
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ),
                      _buildPaymentRow(
                        "${StringUtils.subtotal}:",
                        "\$${booking.subtotal.toStringAsFixed(2)}",
                      ),
                      _buildPaymentRow(
                        "${StringUtils.discount}:",
                        "-\$${booking.discount.toStringAsFixed(2)}",
                      ),
                      _buildPaymentRow(
                        "${StringUtils.tax} (${booking.tax}%):",
                        "\$${taxAmount.toStringAsFixed(2)}",
                      ),
                      _buildPaymentRow(
                        "${StringUtils.grandTotal}:",
                        "\$${(booking.subtotal + taxAmount - booking.discount).toStringAsFixed(2)}",
                      ),
                      _buildPaymentRow(
                        "${StringUtils.prepaid}:",
                        "-\$${booking.prepayment.toStringAsFixed(2)}",
                      ),
                      _buildPaymentRow(
                        "${StringUtils.balance}:",
                        "\$${booking.balance.toStringAsFixed(2)}",
                      ),
                      _buildPaymentRow(
                        "${StringUtils.securityDepositRefundable}:",
                        "\$${booking.securityDeposit.toStringAsFixed(2)}",
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRow(
    String title,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(title, fontWeight: FontWeight.w500),
          CustomText(
            value,
            color: valueColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: ColorUtils.grey99),
          SizedBox(width: 6.w),
          Expanded(
            child: CustomText(
              text,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double value, {
    bool isBold = false,
    Color color = ColorUtils.black,
    String? strValue,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            label,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
          CustomText(
            strValue ?? "\$${value.toStringAsFixed(2)}",
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ],
      ),
    );
  }

  Future<void> _deleteReservation(int reservationId) async {
    Get.defaultDialog(
      title: "",
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 48.sp, color: Colors.red),
          SizedBox(height: 12.h),
          CustomText(
            StringUtils.deleteReservationTitle,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          SizedBox(height: 12.h),
          CustomText(
            StringUtils.deleteReservationMessage,
            textAlign: TextAlign.center,
            fontSize: 15.sp,
            color: Colors.black87,
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 10.h,
                  ),
                ),
                onPressed: () => Get.back(),
                child: CustomText(
                  StringUtils.no,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 10.h,
                  ),
                ),
                onPressed: () async {
                  await Get.find<BikeBookingController>().deleteBooking(
                    reservationId,
                  );
                  Get.back();
                  await Get.find<BikeBookingController>().fetchBookings();
                  showCustomSnackBar(
                    message: StringUtils.bookingDeletedSuccessfully,
                  );
                },
                child: CustomText(
                  StringUtils.yes,
                  color: ColorUtils.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
