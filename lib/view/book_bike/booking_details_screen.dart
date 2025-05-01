import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../../blocs/book_bike/booking_form_bloc/booking_form_bloc.dart';
import '../../blocs/book_bike/booking_form_bloc/booking_form_state.dart';

///GetX
/*
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
    double taxAmount =
        (booking.subtotal - booking.discount) * (booking.tax / 100);
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
              SizedBox(height: 10.h),

              ///Payment details container
              Container(
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.only(top: 24.h),
                decoration: BoxDecoration(
                  color: ColorUtils.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.payment, color: ColorUtils.primary),
                        SizedBox(width: 8.w),
                        CustomText(
                          StringUtils.paymentDetails,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorUtils.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoRowForPayment(
                      "${StringUtils.typeOfPayment}:",
                      "Cash",
                    ),

                    SizedBox(height: 12.h),
                    _sectionHeader(StringUtils.costBreakdown),
                    _buildInfoRowForPayment(
                      "${StringUtils.subtotal}:",
                      "\$${booking.subtotal.toStringAsFixed(2)}",
                    ),

                    _buildInfoRowForPayment(
                      "${StringUtils.discount}:",
                      "-\$${booking.discount.toStringAsFixed(2)}",
                    ),
                    _buildInfoRowForPayment(
                      "${StringUtils.tax} (${booking.tax}%):",
                      "\$${taxAmount.toStringAsFixed(2)}",
                    ),

                    _buildInfoRowForPayment(
                      "${StringUtils.grandTotal}:",
                      "\$${(booking.subtotal + taxAmount - booking.discount).toStringAsFixed(2)}",
                    ),

                    SizedBox(height: 12.h),
                    _sectionHeader(StringUtils.advancePayment),
                    _buildInfoRowForPayment(
                      "${StringUtils.prepaid}:",
                      "-\$${booking.prepayment.toStringAsFixed(2)}",
                    ),

                    SizedBox(height: 12.h),
                    _sectionHeader(StringUtils.finalAmount),
                    _buildInfoRowForPayment(
                      "${StringUtils.balance}:",
                      "\$${booking.balance.toStringAsFixed(2)}",
                    ),
                    _buildInfoRowForPayment(
                      "${StringUtils.securityDepositRefundable}:",
                      "\$${booking.securityDeposit.toStringAsFixed(2)}",
                    ),

                    SizedBox(height: 10.h),
                    Divider(
                      height: 30.h,
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                    CustomText(
                      "${StringUtils.totalToCollectNow}: \$${(booking.balance + booking.securityDeposit).toStringAsFixed(2)}",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),

              // Divider(thickness: 1, height: 24.h),
              // _buildInfoRow(
              //   Icons.access_time,
              //   "${StringUtils.bookedOn}: ${formatSimpleDate(booking.createdAt)}",
              // ),
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: CustomText(
        title,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
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

  Widget _buildInfoRowForPayment(
    String title,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: CustomText(title, fontWeight: FontWeight.w600)),
          Expanded(
            child: CustomText(
              value,
              color: valueColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
*/
///Bloc
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

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<BooingFormBloc, BookingFormState>(
      builder: (context, state) {
        double taxAmount =
            (booking.subtotal - booking.discount) * (booking.tax / 100);

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
                    booking.userFullName,
                    isDarkTheme,
                  ),
                  _buildInfoRow(
                    Icons.phone,
                    "${StringUtils.phone}: ${booking.userPhone}",
                    isDarkTheme,
                  ),
                  _buildInfoRow(
                    Icons.email,
                    "${StringUtils.email}: ${booking.userEmail}",
                    isDarkTheme,
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
                    isDarkTheme,
                  ),
                  _buildInfoRow(
                    Icons.calendar_today,
                    "${StringUtils.pickUp}: ${DateFormat('dd-MM-yyyy').format(booking.pickupDate)}",
                    isDarkTheme,
                  ),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    "${StringUtils.drop}: ${DateFormat('dd-MM-yyyy').format(booking.dropoffDate)}",
                    isDarkTheme,
                  ),
                  SizedBox(height: 10.h),

                  /// Payment details
                  Container(
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.only(top: 24.h),
                    decoration: BoxDecoration(
                      color:
                          isDarkTheme ? ColorUtils.darkCard : ColorUtils.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.payment, color: ColorUtils.primary),
                            SizedBox(width: 8.w),
                            CustomText(
                              StringUtils.paymentDetails,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.primary,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _buildInfoRowForPayment(
                          "${StringUtils.typeOfPayment}:",
                          "Cash",
                        ),
                        SizedBox(height: 12.h),
                        _sectionHeader(StringUtils.costBreakdown, isDarkTheme),
                        _buildInfoRowForPayment(
                          "${StringUtils.subtotal}:",
                          "\$${booking.subtotal.toStringAsFixed(2)}",
                        ),
                        _buildInfoRowForPayment(
                          "${StringUtils.discount}:",
                          "-\$${booking.discount.toStringAsFixed(2)}",
                        ),
                        _buildInfoRowForPayment(
                          "${StringUtils.tax} (${booking.tax}%):",
                          "\$${taxAmount.toStringAsFixed(2)}",
                        ),
                        _buildInfoRowForPayment(
                          "${StringUtils.grandTotal}:",
                          "\$${(booking.subtotal + taxAmount - booking.discount).toStringAsFixed(2)}",
                        ),

                        SizedBox(height: 12.h),
                        _sectionHeader(StringUtils.advancePayment, isDarkTheme),
                        _buildInfoRowForPayment(
                          "${StringUtils.prepaid}:",
                          "-\$${booking.prepayment.toStringAsFixed(2)}",
                        ),

                        SizedBox(height: 12.h),
                        _sectionHeader(StringUtils.finalAmount, isDarkTheme),
                        _buildInfoRowForPayment(
                          "${StringUtils.balance}:",
                          "\$${booking.balance.toStringAsFixed(2)}",
                        ),
                        _buildInfoRowForPayment(
                          "${StringUtils.securityDepositRefundable}:",
                          "\$${booking.securityDeposit}",
                        ),

                        SizedBox(height: 10.h),
                        Divider(
                          height: 30.h,
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        CustomText(
                          "${StringUtils.totalToCollectNow}: \$${(booking.balance + booking.securityDeposit).toStringAsFixed(2)}",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              isDarkTheme
                                  ? ColorUtils.darkText
                                  : Colors.black87,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),
                  Center(
                    child: Container(
                      width: 200.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color:
                              isDarkTheme
                                  ? ColorUtils.darkGrey
                                  : ColorUtils.grey99,
                          width: 1.w,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
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
      },
    );
  }

  Widget _sectionHeader(String title, bool isDarkTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: CustomText(
        title,
        fontWeight: FontWeight.w600,
        color:
            isDarkTheme
                ? ColorUtils.darkText.withValues(alpha: 0.7)
                : Colors.grey.shade600,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDarkTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: isDarkTheme ? ColorUtils.darkText : ColorUtils.grey99,
          ),
          SizedBox(width: 8.w),
          Expanded(child: CustomText(text, fontSize: 16.sp)),
        ],
      ),
    );
  }

  Widget _buildInfoRowForPayment(
    String title,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: CustomText(title, fontWeight: FontWeight.w600)),
          Expanded(
            child: CustomText(
              value,
              color: valueColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
