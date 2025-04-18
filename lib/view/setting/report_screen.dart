import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rental_motor_cycle/blocs/report/report_bloc.dart';
import 'package:rental_motor_cycle/blocs/report/report_event.dart';
import 'package:rental_motor_cycle/blocs/report/report_state.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_bloc.dart';

/*class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
        titleText: StringUtils.salesReport,
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
                    Icon(Icons.arrow_drop_down, color: ColorUtils.grey99),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                final bookingList =
                    Get.find<BikeBookingController>().bookingList.value;
                final groupedTransactions = groupTransactions(bookingList);

                if (groupedTransactions.isEmpty) {
                  return const Center(
                    child: CustomText(
                      StringUtils.noTransactionsFound,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: groupedTransactions.length,
                  itemBuilder: (context, index) {
                    final entry = groupedTransactions.entries.elementAt(index);

                    // Calculate total per group
                    final groupTotal = entry.value.fold<double>(
                      0,
                      (sum, item) => sum + (item['amount'] as double),
                    );

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorUtils.white,
                        borderRadius: BorderRadius.circular(16.r),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            SizedBox(height: 10.h),
                          ],
                          ...entry.value.map((item) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(item['date'], fontSize: 16.sp),
                                  CustomText(
                                    "\$ ${item['amount'].toStringAsFixed(2)}",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: Colors.green[700],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
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
        title: const CustomText(StringUtils.selectFilter),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              filterList.map((filter) {
                return RadioListTile(
                  title: CustomText(filter),
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

  Map<String, List<Map<String, dynamic>>> groupTransactions(List bookingList) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in bookingList) {
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
      });
    }

    return grouped;
  }
}*/
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
            title: const CustomText(StringUtils.selectFilter),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  filterList
                      .map(
                        (filter) => RadioListTile(
                          title: CustomText(filter),
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
        titleText: StringUtils.salesReport,
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
                    Icon(Icons.arrow_drop_down, color: ColorUtils.grey99),
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

                    return ListView.builder(
                      itemCount: groupedTransactions.length,
                      itemBuilder: (context, index) {
                        final entry = groupedTransactions.entries.elementAt(
                          index,
                        );
                        final groupTotal = entry.value.fold<double>(
                          0,
                          (sum, item) => sum + (item['amount'] as double),
                        );

                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: ColorUtils.white,
                            borderRadius: BorderRadius.circular(16.r),
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
                                SizedBox(height: 10.h),
                              ],
                              ...entry.value.map((item) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(item['date'], fontSize: 16.sp),
                                      CustomText(
                                        "\$ ${item['amount'].toStringAsFixed(2)}",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        color: Colors.green[700],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      },
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
