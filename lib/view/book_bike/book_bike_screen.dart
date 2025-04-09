// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:rental_motor_cycle/commonWidgets/common_dropdown.dart';
// import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
// import 'package:rental_motor_cycle/commonWidgets/custom_text_field.dart';
// import 'package:rental_motor_cycle/controller/bike_controller.dart';
// import 'package:rental_motor_cycle/model/bike_model.dart';
// import 'package:rental_motor_cycle/model/booking_model.dart';
// import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
// import 'package:rental_motor_cycle/utils/color_utils.dart';
// import 'package:rental_motor_cycle/utils/string_utils.dart';
// import '../../controller/bike_booking_controller.dart';
// import 'package:intl/intl.dart';
//
// // ✅ Helper Function for Date Comparison
// extension DateCompare on DateTime {
//   bool isSameDate(DateTime other) {
//     return year == other.year && month == other.month && day == other.day;
//   }
// }
//
// class BookBikeScreen extends StatefulWidget {
//   const BookBikeScreen({super.key});
//
//   @override
//   State<BookBikeScreen> createState() => _BookBikeScreenState();
// }
//
// class _BookBikeScreenState extends State<BookBikeScreen> {
//   final BikeBookingController bookingController =
//       Get.find<BikeBookingController>();
//
//   @override
//   void initState() {
//     initMethod();
//     super.initState();
//   }
//
//   initMethod() async {
//     await bookingController.fetchBookings();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: commonAppBar(
//         titleText: StringUtils.bookBike,
//         context: context,
//         isLeading: false,
//         isCenterTitle: false,
//         fontSize: 20.sp,
//         fontWeight: FontWeight.w600,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await showBikeBookingDialog();
//           await bookingController.fetchBookings();
//         },
//         child: Icon(Icons.add),
//       ),
//       body: Obx(
//         () =>
//             bookingController.bookingList.isEmpty
//                 ? Center(child: CustomText(StringUtils.noBookedBikes))
//                 : ListView.builder(
//                   itemCount: bookingController.bookingList.length,
//                   itemBuilder: (context, index) {
//                     final reservation = bookingController.bookingList[index];
//                     log("---reservation----${reservation.userFullName}");
//                     return _buildReservationCard(reservation);
//                   },
//                 ),
//       ),
//     );
//   }
//
//   /// ✅ **Reservation Card View**
//   Widget _buildReservationCard(BookingModel reservation) {
//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
//       child: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomText(
//                   reservation.bikeName,
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit, color: ColorUtils.primary),
//                       onPressed:
//                           () => showBikeBookingDialog(booking: reservation),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete, color: ColorUtils.red),
//                       onPressed: () async {
//                         await _deleteReservation(reservation.id ?? 0);
//                         await bookingController.fetchBookings();
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 8.h),
//
//             /// 🔹 **User Contact Details**
//             _buildInfoRow(
//               Icons.phone,
//               "${StringUtils.phone}: ${reservation.userPhone}",
//             ),
//             _buildInfoRow(
//               Icons.email,
//               "${StringUtils.email}: ${reservation.userEmail}",
//             ),
//             SizedBox(height: 8.h),
//             Divider(thickness: 1, height: 16.h),
//
//             /// 🔹 **Pricing Details**
//             _buildPriceRow(StringUtils.ratePerDay, reservation.rentPerDay),
//             _buildPriceRow(StringUtils.subtotal, reservation.totalRent),
//             _buildPriceRow("${StringUtils.tax} (5%)", reservation.tax),
//             _buildPriceRow(StringUtils.discount, reservation.discount),
//             _buildPriceRow(
//               StringUtils.grandTotal,
//               reservation.finalAmountPayable,
//               isBold: true,
//             ),
//             _buildPriceRow(StringUtils.prepayment, reservation.prepayment),
//             _buildPriceRow(
//               StringUtils.prepayment,
//               reservation.prepayment,
//               isBold: true,
//               color: ColorUtils.red,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// ✅ **Builds Row for Info (Check-in, Contact, Email)**
//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 20.sp, color: ColorUtils.grey99),
//         SizedBox(width: 8.w),
//         Expanded(
//           child: CustomText(
//             text,
//             fontSize: 16.sp,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// ✅ **Builds Price Row (Rate, Subtotal, Tax, Grand Total, etc.)**
//   Widget _buildPriceRow(
//     String label,
//     double value, {
//     bool isBold = false,
//     Color color = Colors.black,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CustomText(
//             label,
//
//             fontSize: 16.sp,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//           ),
//           CustomText(
//             "\$${value.toStringAsFixed(2)}",
//
//             fontSize: 16.sp,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             color: color,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// ✅ **Delete Reservation with Confirmation**
//   Future<void> _deleteReservation(int reservationId) async {
//     Get.defaultDialog(
//       title: StringUtils.deleteBooking,
//       middleText: StringUtils.deleteConfirmationForBooking,
//       textConfirm: StringUtils.yes,
//       textCancel: StringUtils.no,
//       confirmTextColor: ColorUtils.white,
//       onConfirm: () async {
//         await bookingController.deleteBooking(reservationId);
//         Get.back();
//         await bookingController.fetchBookings();
//       },
//     );
//   }
//
//   // Assuming you have a list of bikes loaded somewhere in your controller or view
//   // final bikes = bikeController.bikeList;
// }
//
// Future<void> showBikeBookingDialog({BookingModel? booking}) async {
//   final formKey = GlobalKey<FormState>();
//   final fullNameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final emailController = TextEditingController();
//   final discountController = TextEditingController();
//   final taxController = TextEditingController();
//   final prepaymentController = TextEditingController();
//   final fromDate = Rxn<DateTime>();
//   final toDate = Rxn<DateTime>();
//
//   final fromDateController = TextEditingController();
//   final toDateController = TextEditingController();
//   final subtotal = 0.0.obs;
//   final grandTotal = 0.0.obs;
//   final balance = 0.0.obs;
//   final tax = 0.0.obs;
//
//   Rx<BikeModel?> selectedBike = Rx<BikeModel?>(null);
//
//   void calculateTotal() {
//     final rent = selectedBike.value?.rentPerDay ?? 0;
//     final days =
//         fromDate != null && toDate != null
//             ? toDate.value!.difference(fromDate.value!).inDays + 1
//             : 0;
//     final discount = double.tryParse(discountController.text) ?? 0.0;
//     final prepayment = double.tryParse(prepaymentController.text) ?? 0.0;
//
//     subtotal.value = rent * days;
//     tax.value = subtotal.value * 0.05;
//     grandTotal.value = subtotal.value + tax.value - discount;
//     balance.value = grandTotal.value - prepayment;
//   }
//
//   // Future<void> pickDate(bool isFrom) async {
//   //   final initial =
//   //       isFrom
//   //           ? fromDate ?? DateTime.now()
//   //           : toDate ?? (fromDate ?? DateTime.now()).add(Duration(days: 1));
//   //
//   //   final picked = await showDatePicker(
//   //     context: Get.context!,
//   //     initialDate: initial,
//   //     firstDate: isFrom ? DateTime.now() : (fromDate ?? DateTime.now()),
//   //     lastDate: DateTime(2100),
//   //     initialEntryMode: DatePickerEntryMode.calendarOnly,
//   //     builder: (context, child) {
//   //       return Theme(
//   //         data: Theme.of(context).copyWith(
//   //           colorScheme: ColorScheme.light(
//   //             primary: ColorUtils.primary,
//   //             onPrimary: Colors.white,
//   //             onSurface: Colors.black,
//   //           ),
//   //           textButtonTheme: TextButtonThemeData(
//   //             style: TextButton.styleFrom(
//   //               foregroundColor: ColorUtils.primary,
//   //             ),
//   //           ),
//   //         ),
//   //         child: child!,
//   //       );
//   //     },
//   //   );
//   //
//   //   if (picked != null) {
//   //     if (isFrom) {
//   //       fromDate = picked;
//   //       fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);
//   //
//   //       // Ensure toDate is NOT before fromDate
//   //       if (toDate != null && toDate!.isBefore(fromDate!)) {
//   //         toDate = fromDate!.add(Duration(days: 1));
//   //         toDateController.text = DateFormat('yyyy-MM-dd').format(toDate!);
//   //       }
//   //     } else {
//   //       if (fromDate != null && picked.isBefore(fromDate!)) {
//   //         Get.snackbar(
//   //           "Invalid Date",
//   //           "Drop-off date cannot be before pickup date",
//   //           backgroundColor: Colors.redAccent,
//   //           colorText: Colors.white,
//   //         );
//   //         return;
//   //       }
//   //
//   //       toDate = picked;
//   //       toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
//   //     }
//   //
//   //     calculateTotal();
//   //   }
//   // }
//   Future<void> pickDateTime(bool isFrom) async {
//     DateTime now = DateTime.now();
//
//     // 🗓 Date Picker
//     final pickedDate = await showDatePicker(
//       context: Get.context!,
//       initialDate:
//           isFrom
//               ? fromDate.value ?? now
//               : toDate.value ?? (fromDate.value ?? now).add(Duration(days: 1)),
//       firstDate: isFrom ? now : (fromDate.value ?? now),
//       lastDate: DateTime(2100),
//       initialEntryMode: DatePickerEntryMode.calendarOnly,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: ColorUtils.primary,
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(foregroundColor: ColorUtils.primary),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedDate != null) {
//       // 🕒 Generate Hourly Time Slots
//       List<TimeOfDay> allTimes = List.generate(
//         24,
//         (index) => TimeOfDay(hour: index, minute: 0),
//       );
//       int minHour;
//
//       if (isFrom) {
//         minHour = (pickedDate.isSameDate(now)) ? now.hour + 1 : 0;
//       } else {
//         final from = fromDate.value;
//         minHour =
//             (pickedDate.isSameDate(from ?? now)) ? ((from ?? now).hour + 1) : 0;
//       }
//
//       final currentDate = isFrom ? fromDate.value : toDate.value;
//       final selectedHour =
//           (currentDate != null && pickedDate.isSameDate(currentDate))
//               ? currentDate.hour
//               : null;
//
//       // 🕒 Time Picker Dialog with Styled Slots
//       final pickedTime = await showDialog<TimeOfDay>(
//         context: Get.context!,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Select Time"),
//             content: SizedBox(
//               width: double.maxFinite,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: allTimes.length,
//                 itemBuilder: (context, index) {
//                   TimeOfDay time = allTimes[index];
//                   bool isDisabled = time.hour < minHour;
//                   bool isSelected = selectedHour == time.hour;
//
//                   return IgnorePointer(
//                     ignoring: isDisabled,
//                     child: ListTile(
//                       title: Text(
//                         time.format(context),
//                         style: TextStyle(
//                           color:
//                               isSelected
//                                   ? ColorUtils.primary
//                                   : isDisabled
//                                   ? Colors.grey
//                                   : Colors.black,
//                           fontWeight:
//                               isSelected
//                                   ? FontWeight.w700
//                                   : isDisabled
//                                   ? FontWeight.normal
//                                   : FontWeight.w500,
//                           fontSize: isSelected ? 18 : 16,
//                         ),
//                       ),
//                       onTap:
//                           isDisabled
//                               ? null
//                               : () => Navigator.pop(context, time),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       );
//
//       if (pickedTime != null) {
//         DateTime finalDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//
//         if (isFrom) {
//           fromDate.value = finalDateTime;
//           fromDateController.text = DateFormat(
//             'MMMM d, yyyy hh:mm a',
//           ).format(finalDateTime);
//
//           if (toDate.value != null &&
//               toDate.value!.isBefore(fromDate.value!.add(Duration(hours: 1)))) {
//             toDate.value = fromDate.value!.add(Duration(hours: 1));
//             toDateController.text = DateFormat(
//               'MMMM d, yyyy hh:mm a',
//             ).format(toDate.value!);
//           }
//         } else {
//           if (fromDate.value != null &&
//               finalDateTime.isBefore(fromDate.value!.add(Duration(hours: 1)))) {
//             Get.snackbar(
//               "Invalid Selection",
//               "Drop-off must be at least 1 hour after pickup",
//               backgroundColor: Colors.redAccent,
//               colorText: Colors.white,
//             );
//             return;
//           }
//
//           toDate.value = finalDateTime;
//           toDateController.text = DateFormat(
//             'MMMM d, yyyy hh:mm a',
//           ).format(finalDateTime);
//         }
//
//         calculateTotal();
//       }
//     }
//   }
//
//   // Init
//   if (booking != null) {
//     fullNameController.text = booking.bikeName;
//     phoneController.text = booking.userPhone;
//     emailController.text = booking.userEmail;
//     fromDateController.text = booking.pickupTime;
//     toDateController.text = booking.dropoffTime;
//     discountController.text = booking.discount.toString();
//     taxController.text = booking.tax.toString();
//     prepaymentController.text = booking.prepayment.toString();
//     fromDate.value = booking.pickupDate;
//     toDate.value = booking.dropoffDate;
//   }
//
//   discountController.addListener(calculateTotal);
//   prepaymentController.addListener(calculateTotal);
//   final BikeBookingController bookingController =
//       Get.find<BikeBookingController>();
//
//   Get.bottomSheet(
//     Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorUtils.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
//       ),
//       child: SingleChildScrollView(
//         child: Obx(() {
//           final from = fromDate.value;
//           final to = toDate.value;
//           return Form(
//             key: formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomText(
//                   booking == null
//                       ? StringUtils.bookBike
//                       : StringUtils.editBooking,
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 SizedBox(height: 20.h),
//
//                 /// Bike Dropdown
//                 Obx(() {
//                   final selectedName =
//                       selectedBike.value == null
//                           ? null
//                           : '${selectedBike.value!.name} (${selectedBike.value!.model})';
//                   final bikeItems =
//                       Get.find<BikeController>().bikeList
//                           .map((bike) => '${bike.name} (${bike.model})')
//                           .toList();
//
//                   final Map<String, BikeModel> bikeMap = {
//                     for (var bike in Get.find<BikeController>().bikeList)
//                       '${bike.name} (${bike.model})': bike,
//                   };
//                   return CommonDropdown(
//                     selectedValue: selectedName,
//                     items: bikeItems,
//                     labelText: StringUtils.selectABike,
//                     validationMessage: StringUtils.selectABike,
//                     onChanged: (selected) {
//                       selectedBike.value = bikeMap[selected];
//                       calculateTotal();
//                     },
//                   );
//                 }),
//                 SizedBox(height: 2.h),
//                 _buildTextField(fullNameController, StringUtils.fullName),
//                 _buildTextField(phoneController, StringUtils.phone),
//                 _buildTextField(emailController, StringUtils.email),
//
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildDateField(
//                         StringUtils.fromDate,
//                         fromDateController,
//                         () => pickDateTime(true),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: _buildDateField(
//                         StringUtils.toDate,
//                         toDateController,
//                         () => pickDateTime(false),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (from != null && to != null) SizedBox(height: 10.h),
//                 if (from != null && to != null)
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: CustomText(
//                       "Duration: ${to.difference(from).inHours} hours",
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w500,
//                       color: ColorUtils.black21,
//                     ),
//                   ),
//                 if (from != null && to != null) SizedBox(height: 10.h),
//
//                 _buildTextField(discountController, StringUtils.discount),
//                 _buildTextField(prepaymentController, StringUtils.prepayment),
//
//                 Obx(
//                   () => Column(
//                     children: [
//                       _buildSummaryRow(StringUtils.subtotal, subtotal.value),
//                       _buildSummaryRow('${StringUtils.tax} (5%)', tax.value),
//                       _buildSummaryRow(
//                         StringUtils.subtotal,
//                         grandTotal.value,
//                         isBold: true,
//                       ),
//                       _buildSummaryRow(
//                         StringUtils.prepayment,
//                         balance.value,
//                         color: Colors.red,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (formKey.currentState!.validate()) {
//                       final newBooking = BookingModel(
//                         userId: 1,
//                         bikeId: selectedBike.value?.id ?? 0,
//                         bikeName: selectedBike.value?.name ?? "",
//                         bikeModel: selectedBike.value?.model ?? "",
//                         discount: double.tryParse(discountController.text) ?? 0,
//                         tax: tax.value,
//                         // subtotal: subtotal.value,
//                         // grandTotal: grandTotal.value,
//                         prepayment:
//                             double.tryParse(prepaymentController.text) ?? 0,
//                         // balance: balance.value,
//                         createdAt: DateTime.now(),
//                         userFullName: fullNameController.text,
//                         userPhone: phoneController.text,
//                         pickupDate:
//                             DateTime.tryParse(fromDateController.text ?? "") ??
//                             DateTime.now(),
//                         userEmail: emailController.text,
//                         dropoffDate:
//                             DateTime.tryParse(toDateController.text ?? "") ??
//                             DateTime.now(),
//                         pickupTime: '',
//                         dropoffTime: '',
//                         pickupLocation: '',
//                         dropoffLocation: '',
//                         rentPerDay: selectedBike.value?.rentPerDay ?? 0.0,
//                         durationInHours: 5.0,
//                         totalRent: 500.00,
//                         finalAmountPayable: 1000.00,
//                         bikes: [],
//                       );
//
//                       if (booking == null) {
//                         await bookingController.addBooking(newBooking);
//                         await bookingController.fetchBookings();
//                         for (var b in bookingController.bookingList) {
//                           log(
//                             "✅ Booking: ${b.bikeName} | ${b.bikeModel} | From: ${b.pickupDate} To: ${b.dropoffDate}",
//                           );
//                         }
//                       } else {
//                         newBooking.id = booking.id;
//                         await bookingController.updateBooking(newBooking);
//                       }
//                       Get.back();
//                     }
//                   },
//                   child: CustomText(
//                     booking == null
//                         ? StringUtils.bookBike
//                         : StringUtils.updateBooking,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     ),
//     isScrollControlled: true,
//   );
// }
//
// Widget _buildTextField(
//   TextEditingController controller,
//   String label, {
//   TextInputType keyboardType = TextInputType.text,
// }) {
//   return Padding(
//     padding: EdgeInsets.symmetric(vertical: 2.h),
//     child: CommonTextField(
//       textEditController: controller,
//       labelText: label,
//       keyBoardType: keyboardType,
//       validator:
//           (value) => value!.isEmpty ? '${StringUtils.enter} $label' : null,
//     ),
//   );
// }
//
// Widget _buildDateField(
//   String label,
//   TextEditingController controller,
//   VoidCallback onTap,
// ) {
//   return CommonTextField(
//     textEditController: controller,
//     readOnly: true,
//     labelText: label,
//     onTap: onTap,
//     validator:
//         (value) => value!.isEmpty ? '${StringUtils.select} $label' : null,
//   );
// }
//
// Widget _buildSummaryRow(
//   String label,
//   double value, {
//   bool isBold = false,
//   Color? color,
// }) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         CustomText(label, fontWeight: isBold ? FontWeight.bold : null),
//         CustomText(
//           '\$ ${value.toStringAsFixed(2)}',
//
//           fontWeight: isBold ? FontWeight.bold : null,
//           color: color,
//         ),
//       ],
//     ),
//   );
// }
