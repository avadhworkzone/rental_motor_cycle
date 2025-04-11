import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_snackbar.dart';
import 'package:rental_motor_cycle/routs/app_page.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/utils/download_db.dart';
import '../controller/employee_controller.dart';
import '../controller/bike_controller.dart';
import '../controller/bike_booking_controller.dart';
import '../database/db_helper.dart';
import '../controller/badge_controller.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  final isDarkMode = false.obs;
  final isLoading = false.obs;

  final EmployeeController employeeController = Get.find();
  final BikeController bikeController = Get.find();
  final BikeBookingController bikeBookingController = Get.find();
  final BadgeController badgeController = Get.find();

  /// Reset Specific Table or Entire Database
  void resetDatabase({String? table}) async {
    // if (isLoading.value) return; // ✅ Prevent multiple clicks
    // isLoading.value = true; // ✅ Start loading
    log('----users table =-=-=-=-> ${table}');
    final db = await DBHelper.database;
    await db.transaction((txn) async {
      log('----txn=-=-=-=-> ${txn}');
      try {
        await txn.execute("PRAGMA foreign_keys = OFF;");
      log('users table =-=-=-=-=-=-=->>> ${table}');

        if (table == "Users") {
          log('delete users');
          await db.delete('Users');
          // await txn.execute("DELETE FROM Users;");
          await db.rawDelete('DELETE FROM Users');

          await employeeController.fetchUsers();
        } else if (table == "Bikes") {
          await txn.execute("DELETE FROM Bikes;");
          await bikeController.fetchBikes();
        } else if (table == "Bookings") {
          await txn.execute("DELETE FROM Bookings;");
          await bikeBookingController.fetchBookings();
        } else {
          print('========delete data=======');
          await txn.execute("DELETE FROM Bookings;");
          await txn.execute("DELETE FROM Bikes;");
          await txn.execute("DELETE FROM Users;");
          await employeeController.fetchUsers();
          await bikeController.fetchBikes();
          await bikeBookingController.fetchBookings();
        }

        await txn.execute("PRAGMA foreign_keys = ON;");
        isLoading.value =false;
        Get.back();
      } catch (e) {
        showCustomSnackBar(
          message: "ERROR___${StringUtils.databaseResetFailed} ${e.toString()}",
          isError: true,
        );
        isLoading.value =false;
      }
    });

    // ✅ Update badge counts **AFTER** database operations are complete
    Future.delayed(Duration(milliseconds: 500), () {
      if (Get.isRegistered<BadgeController>()) {
        badgeController.updateBadgeCounts();
      }
    });

    isLoading.value = false; // ✅ Stop loading
    showCustomSnackBar(
      message:
          "${table ?? StringUtils.allData} ${StringUtils.resetSuccessfully}",
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        titleText: StringUtils.settings,
        context: context,
        isLeading: false,
        isCenterTitle: false,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      body: Column(
        children: [
          Obx(
            () => SwitchListTile(
              title: CustomText(StringUtils.darkMode),
              value: isDarkMode.value,
              onChanged: (value) {
                isDarkMode.value = value;
                Get.changeTheme(value ? ThemeData.dark() : ThemeData.light());
              },
            ),
          ),
          Obx(() {
            if (isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: CustomText(
                    StringUtils.resetEntireDB,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () => showResetOptions(),
                ),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.blue),
                  title: CustomText(
                    StringUtils.resetUsers,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () => showResetOptions(table: "Users"),
                ),
                ListTile(
                  leading: Icon(Icons.meeting_room, color: Colors.green),
                  title: CustomText(
                    StringUtils.resetBikes,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () => resetDatabase(table: "Bikes"),
                ),
                ListTile(
                  leading: Icon(Icons.event, color: Colors.purple),
                  title: CustomText(
                    StringUtils.resetBookings,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () => resetDatabase(table: "Bookings"),
                ),
                ListTile(
                  leading: Icon(
                    Icons.insert_drive_file_outlined,
                    color: Colors.blue,
                  ),
                  title: CustomText(
                    StringUtils.downloadDb,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () async {
                    await DownloadDBFile.downloadDBFile();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.pedal_bike, color: Colors.orange),
                  title: CustomText(
                    StringUtils.myBikes,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () async {
                    Get.toNamed(AppRoutes.myBikesScreen);
                    // await DownloadDBFile.downloadDBFile();
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
                    Get.toNamed(AppRoutes.employeesScreen);
                    // await DownloadDBFile.downloadDBFile();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: CustomText(
                    StringUtils.logout,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () async {
                    await SharedPreferenceUtils.clearPreference();
                    Get.off(() => LoginScreen());
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// ✅ Show Confirmation Dialog Before Reset
  void showResetOptions({String? table}) {
    print('table==>> ${table}');
    final tableName = table ?? StringUtils.allData;

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
            StringUtils.resetDatabaseTitle,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          SizedBox(height: 12.h),
          CustomText(
            "${StringUtils.resetDatabaseMsg} $tableName?",
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
                  StringUtils.cancel,
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


                  resetDatabase(table: table);
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
  }

  /*void showResetOptions() {
    Get.defaultDialog(
      title: StringUtils.resetDatabaseTitle,
      content: CustomText(StringUtils.resetDatabaseMsg),
      textCancel: StringUtils.cancel,
      textConfirm: StringUtils.yesReset,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        resetDatabase();
      },
    );
  }*/
}
