// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rental_motor_cycle/blocs/users/employee_event.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
// ignore: unused_import
import 'package:rental_motor_cycle/utils/download_db.dart';
import '../../blocs/bikes/bike_crud_bloc/bike_bloc.dart';
import '../../blocs/bikes/bike_crud_bloc/bike_event.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_bloc.dart';
import '../../blocs/book_bike/book_bike_home_bloc/book_bike_event.dart';
import '../../blocs/users/employee_bloc.dart';
import '../../database/db_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool isLoading = false;
  final storage = GetStorage();
  resetDatabase({String? table}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    final db = await DBHelper.database;
    try {
      await db.execute("PRAGMA foreign_keys = OFF;");
      if (table == "Users") {
        await db.delete('Users');
        context.read<EmployeeBloc>().add(FetchUsers());
      } else if (table == "Bikes") {
        await db.execute("DELETE FROM Bikes;");
        context.read<BikeBloc>().add(FetchBikesEvent());
      } else if (table == "Bookings") {
        await db.execute("DELETE FROM Bookings;");
        context.read<BookBikeBloc>().add(FetchBookingsEvent());
      } else if (table == "BikeAndBookings") {
        await db.execute("DELETE FROM Bikes;");
        await db.execute("DELETE FROM Bookings;");
        context.read<BikeBloc>().add(FetchBikesEvent());
        context.read<BookBikeBloc>().add(FetchBookingsEvent());
      } else {
        await db.execute("DELETE FROM Bookings;");
        await db.execute("DELETE FROM Bikes;");
        await db.execute("DELETE FROM Users;");
        context.read<EmployeeBloc>().add(FetchUsers());
        context.read<BikeBloc>().add(FetchBikesEvent());
        context.read<BookBikeBloc>().add(FetchBookingsEvent());
      }

      await db.execute("PRAGMA foreign_keys = ON;");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showCustomSnackBar(
        message: "ERROR___${StringUtils.databaseResetFailed} ${e.toString()}",
        isError: true,
      );
      setState(() {
        isLoading = false;
      });
    }
    // });

    // ✅ Update badge counts **AFTER** database operations are complete
    // Future.delayed(Duration(milliseconds: 500), () {
    //   if (Get.isRegistered<BadgeController>()) {
    //     badgeController.updateBadgeCounts();
    //   }
    // });

    setState(() {
      isLoading = false;
    });
    showCustomSnackBar(
      message:
          "${table ?? StringUtils.allData} ${StringUtils.resetSuccessfully}",
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = storage.read('isDarkMode') ?? false;

    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.settings,
        context: context,
        isLeading: false,
        isCenterTitle: false,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        backgroundColor: ColorUtils.primary,
        fontColor: ColorUtils.white,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  SwitchListTile(
                    title: CustomText(StringUtils.darkMode),
                    value: isDarkMode,
                    onChanged: (value) {
                      isDarkMode = value;
                      storage.write('isDarkMode', value);
                      setState(() {});
                      Get.changeTheme(
                        value ? ThemeData.dark() : ThemeData.light(),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: CustomText(
                      StringUtils.resetEntireDB,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () => showResetOptions(context: context),
                  ),
                  ListTile(
                    leading: Icon(Icons.people, color: Colors.blue),
                    title: CustomText(
                      StringUtils.resetUsers,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap:
                        () =>
                            showResetOptions(context: context, table: "Users"),
                  ),
                  ListTile(
                    leading: Icon(Icons.meeting_room, color: Colors.green),
                    title: CustomText(
                      StringUtils.resetBikes,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap:
                        () => showResetOptions(
                          context: context,
                          table: "BikeAndBookings",
                        ),
                  ),
                  ListTile(
                    leading: Icon(Icons.event, color: Colors.purple),
                    title: CustomText(
                      StringUtils.resetBookings,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap:
                        () => showResetOptions(
                          context: context,
                          table: "Bookings",
                        ),
                  ),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.insert_drive_file_outlined,
                  //     color: Colors.blue,
                  //   ),
                  //   title: CustomText(
                  //     StringUtils.downloadDb,
                  //     fontSize: 15.sp,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  //   onTap: () async {
                  //     await DownloadDBFile.downloadDBFile();
                  //   },
                  // ),
                  ListTile(
                    leading: Icon(Icons.pedal_bike, color: Colors.orange),
                    title: CustomText(
                      StringUtils.myBikes,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () async {
                      Navigator.pushNamed(context, AppRoutes.myBikesScreen);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.brown),
                    title: CustomText(
                      StringUtils.users,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () async {
                      Navigator.pushNamed(context, AppRoutes.employeesScreen);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: Colors.deepPurple),
                    title: CustomText(
                      StringUtils.salesReport,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () async {
                      Navigator.pushNamed(context, AppRoutes.reportScreen);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.payment, color: Colors.teal),
                    title: CustomText(
                      StringUtils.transactionReport,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () async {
                      Navigator.pushNamed(context, AppRoutes.transactionScreen);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: CustomText(
                      StringUtils.logout,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final isDarkMode =
                              Theme.of(context).brightness == Brightness.dark;
                          return AlertDialog(
                            backgroundColor:
                                isDarkMode ? Colors.grey[850] : Colors.white,
                            title: CustomText(
                              StringUtils.confirmLogout,

                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            content: CustomText(
                              StringUtils.areYouSureWantToLogOut,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                            actions: [
                              TextButton(
                                child: CustomText(
                                  StringUtils.cancel,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const CustomText(StringUtils.logout),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await SharedPreferenceUtils.clearPreference();
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.loginScreen,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
    );
  }

  /// ✅ Show Confirmation Dialog Before Reset
  void showResetOptions({required BuildContext context, String? table}) {
    final tableName = table ?? StringUtils.allData;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible:
          false, // This will make the dialog non-dismissable by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, size: 48.sp, color: Colors.red),
              SizedBox(height: 12.h),
              CustomText(
                StringUtils.resetDatabaseTitle,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              SizedBox(height: 12.h),
              CustomText(
                "${StringUtils.resetDatabaseMsg} $tableName?",
                textAlign: TextAlign.center,
                fontSize: 15.sp,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isDarkMode ? Colors.white : Colors.black,
                      backgroundColor:
                          isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                    ),
                    onPressed:
                        () => Navigator.of(context).pop(), // Close the dialog
                    child: CustomText(
                      StringUtils.cancel,
                      color: isDarkMode ? Colors.white : Colors.black,
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
                      Navigator.of(context).pop(); // Close the dialog
                      await resetDatabase(table: table);
                      setState(() {});
                    },
                    child: CustomText(
                      StringUtils.yesReset,
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
      },
    );
  }

  // void showResetOptions({String? table}) {
  //   final tableName = table ?? StringUtils.allData;
  //
  //   Get.defaultDialog(
  //     title: "",
  //     backgroundColor: Colors.white,
  //     contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(Icons.warning_amber_rounded, size: 48.sp, color: Colors.red),
  //         SizedBox(height: 12.h),
  //         CustomText(
  //           StringUtils.resetDatabaseTitle,
  //           fontSize: 18.sp,
  //           fontWeight: FontWeight.w700,
  //           color: Colors.black,
  //         ),
  //         SizedBox(height: 12.h),
  //         CustomText(
  //           "${StringUtils.resetDatabaseMsg} $tableName?",
  //           textAlign: TextAlign.center,
  //           fontSize: 15.sp,
  //           color: Colors.black87,
  //         ),
  //         SizedBox(height: 20.h),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 foregroundColor: Colors.black,
  //                 backgroundColor: Colors.grey[300],
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: 24.w,
  //                   vertical: 10.h,
  //                 ),
  //               ),
  //               onPressed: () => Get.back(),
  //               child: CustomText(
  //                 StringUtils.cancel,
  //                 fontSize: 15.sp,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 foregroundColor: Colors.white,
  //                 backgroundColor: Colors.red,
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: 24.w,
  //                   vertical: 10.h,
  //                 ),
  //               ),
  //               onPressed: () async {
  //                 Get.back();
  //                 await resetDatabase(table: table);
  //               },
  //               child: CustomText(
  //                 StringUtils.yesReset,
  //                 color: ColorUtils.white,
  //                 fontSize: 15.sp,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
