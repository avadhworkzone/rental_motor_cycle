import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rental_motor_cycle/commonWidgets/custom_appbar.dart';
import 'package:rental_motor_cycle/utils/Theme/app_text_style.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import 'package:rental_motor_cycle/utils/download_db.dart';
import '../controller/user_controller.dart';
import '../controller/bike_controller.dart';
import '../controller/bike_booking_controller.dart';
import '../database/db_helper.dart';
import '../controller/badge_controller.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  final isDarkMode = false.obs;
  final isLoading =
      false.obs; // ✅ Prevents multiple database operations at once

  final UserController userController = Get.find();
  final BikeController bikeController = Get.find();
  final BikeBookingController bikeBookingController = Get.find();
  final BadgeController badgeController = Get.find();

  /// Reset Specific Table or Entire Database
  void resetDatabase({String? table}) async {
    if (isLoading.value) return; // ✅ Prevent multiple clicks
    isLoading.value = true; // ✅ Start loading

    final db = await DBHelper.database;
    await db.transaction((txn) async {
      try {
        await txn.execute("PRAGMA foreign_keys = OFF;");

        if (table == "Users") {
          await txn.execute("DELETE FROM Users;");
          await userController.fetchUsers();
        } else if (table == "Rooms") {
          await txn.execute("DELETE FROM Rooms;");
          await bikeController.fetchBikes();
        } else if (table == "Reservations") {
          await txn.execute("DELETE FROM Reservations;");
          await bikeBookingController.fetchBookings();
        } else {
          await txn.execute("DELETE FROM Reservations;");
          await txn.execute("DELETE FROM Rooms;");
          await txn.execute("DELETE FROM Users;");
          await userController.fetchUsers();
          await bikeController.fetchBikes();
          await bikeBookingController.fetchBookings();
        }

        await txn.execute("PRAGMA foreign_keys = ON;");
      } catch (e) {
        Get.snackbar("Error", "Database reset failed: ${e.toString()}");
      }
    });

    // ✅ Update badge counts **AFTER** database operations are complete
    Future.delayed(Duration(milliseconds: 500), () {
      if (Get.isRegistered<BadgeController>()) {
        badgeController.updateBadgeCounts();
      }
    });

    isLoading.value = false; // ✅ Stop loading
    Get.snackbar("Success", "${table ?? 'All Data'} reset successfully!");
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
              title: Text("Dark Mode"),
              value: isDarkMode.value,
              onChanged: (value) {
                isDarkMode.value = value;
                Get.changeTheme(value ? ThemeData.dark() : ThemeData.light());

              },
            ),
          ),
          Obx(() {
            if (isLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              ); // ✅ Show loading indicator
            }
            return Column(
              children: [
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: CustomText("Reset Entire Database"),
                  onTap: () => showResetOptions(),
                ),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.blue),
                  title: Text("Reset Users"),
                  onTap: () => resetDatabase(table: "Users"),
                ),
                ListTile(
                  leading: Icon(Icons.meeting_room, color: Colors.green),
                  title: Text("Reset Rooms"),
                  onTap: () => resetDatabase(table: "Rooms"),
                ),
                ListTile(
                  leading: Icon(Icons.event, color: Colors.purple),
                  title: Text("Reset Reservations"),
                  onTap: () => resetDatabase(table: "Reservations"),
                ),
                ListTile(
                  leading: Icon(
                    Icons.insert_drive_file_outlined,
                    color: Colors.blue,
                  ),
                  title: Text("download db"),
                  onTap: () async {
                    await DownloadDBFile.downloadDBFile();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Logout"),
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
  void showResetOptions() {
    Get.defaultDialog(
      title: "Reset Database",
      content: Text("Are you sure you want to delete all data?"),
      textCancel: "Cancel",
      textConfirm: "Yes, Reset",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        resetDatabase();
      },
    );
  }
}
