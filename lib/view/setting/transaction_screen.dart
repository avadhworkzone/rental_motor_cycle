/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/controller/bike_booking_controller.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TextEditingController filterController = TextEditingController();
  final List<String> filterList = [
    StringUtils.daily,
    StringUtils.monthly,
    StringUtils.yearly,
  ];
  String selectedFilter = StringUtils.daily;

  @override
  void initState() {
    super.initState();
    filterController.text = selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.transactionReport,
        context: context,
        isLeading: true,
        isCenterTitle: true,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        backgroundColor: ColorUtils.primary,
        fontColor: ColorUtils.white,
        iconColor: ColorUtils.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => showFilterDialog(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      filterController.text,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                final reservationList =
                    Get.find<BikeBookingController>().bookingList;
                final groupedTransactions = groupTransactions(reservationList);

                // Flatten all transactions into a single list
                // final allTransactions = groupedTransactions.values.expand((e) => e).toList();
                // final totalAmount = allTransactions.fold<double>(
                //   0,
                //       (sum, item) => sum + (item['amount'] as double),
                // );

                if (groupedTransactions.isEmpty) {
                  return const Center(
                    child: CustomText(
                      StringUtils.noTransactionsFound,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }

                return ListView(
                  children: [
                    ...groupedTransactions.entries.map((entry) {
                      final groupTotal = entry.value.fold<double>(
                        0,
                        (sum, item) => sum + (item['amount'] as double),
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (selectedFilter != StringUtils.daily) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    entry.key,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.primary,
                                  ),
                                  CustomText(
                                    "\$ ${groupTotal.toStringAsFixed(2)}",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                            ...entry.value.map((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          item['guest'],
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CustomText(
                                          "\$ ${item['amount'].toStringAsFixed(2)}",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          color: Colors.green[700],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      item['date'],
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void showFilterDialog() {
    String tempFilter = selectedFilter;
    Get.dialog(
      AlertDialog(
        title: CustomText(StringUtils.selectFilter),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              filterList.map((filter) {
                return RadioListTile(
                  title: Text(filter),
                  value: filter,
                  groupValue: tempFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                      filterController.text = value;
                      Get.back();
                    });
                  },
                );
              }).toList(),
        ),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> groupTransactions(
    List reservationList,
  ) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in reservationList) {
      final checkoutDate = item.dropoffDate;
      String groupKey = "";

      if (selectedFilter == StringUtils.daily) {
        groupKey = DateFormat("dd MMM yyyy").format(checkoutDate);
      } else if (selectedFilter == StringUtils.monthly) {
        groupKey = DateFormat("MMMM yyyy").format(checkoutDate);
      } else if (selectedFilter == StringUtils.yearly) {
        groupKey = DateFormat("yyyy").format(checkoutDate);
      }

      if (!grouped.containsKey(groupKey)) {
        grouped[groupKey] = [];
      }

      grouped[groupKey]!.add({
        "date": DateFormat("dd MMM yyyy").format(checkoutDate),
        "amount": (item.balance as num).toDouble(),
        "guest": item.userFullName ?? "Unknown",
      });
    }

    return grouped;
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_motor_cycle/blocs/report/report_bloc.dart';
import 'package:rental_motor_cycle/blocs/report/report_event.dart';
import 'package:rental_motor_cycle/blocs/report/report_state.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_bloc.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TextEditingController filterController = TextEditingController();
  final List<String> filterList = [
    StringUtils.daily,
    StringUtils.monthly,
    StringUtils.yearly,
  ];
  String selectedFilter = StringUtils.daily;

  @override
  void initState() {
    super.initState();
    filterController.text = selectedFilter;

    final bookings = context.read<BookBikeBloc>().bookingList;
    context.read<ReportBloc>().add(
      LoadReportData(bookings: bookings, selectedFilter: selectedFilter),
    );
  }

  void showFilterDialog() {
    String tempFilter = selectedFilter;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: CustomText(StringUtils.selectFilter),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  filterList
                      .map(
                        (filter) => RadioListTile(
                          title: Text(filter),
                          value: filter,
                          groupValue: tempFilter,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedFilter = value;
                                filterController.text = value;
                              });
                              context.read<ReportBloc>().add(
                                ChangeFilter(value),
                              );
                              Navigator.pop(context);
                            }
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.transactionReport,
        context: context,
        isLeading: true,
        isCenterTitle: true,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        backgroundColor: ColorUtils.primary,
        fontColor: ColorUtils.white,
        iconColor: ColorUtils.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            GestureDetector(
              onTap: showFilterDialog,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      filterController.text,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  if (state is ReportLoaded) {
                    final groupedTransactions = state.groupedTransactions;

                    if (groupedTransactions.isEmpty) {
                      return const Center(
                        child: CustomText(
                          StringUtils.noTransactionsFound,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }

                    return ListView(
                      children:
                          groupedTransactions.entries.map((entry) {
                            final groupTotal = entry.value.fold<double>(
                              0,
                              (sum, item) => sum + (item['amount'] as double),
                            );

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (selectedFilter != StringUtils.daily) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          entry.key,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ColorUtils.primary,
                                        ),
                                        CustomText(
                                          "\$ ${groupTotal.toStringAsFixed(2)}",
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ColorUtils.primary,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                  ...entry.value.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                item['guest'],
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              CustomText(
                                                "\$ ${item['amount'].toStringAsFixed(2)}",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                                color: Colors.green[700],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4.h),
                                          CustomText(
                                            item['date'],
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }).toList(),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
