import 'dart:developer';

import 'package:get/get.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import '../database/db_helper.dart';
import '../model/reservation_model.dart';

class BikeBookingController extends GetxController {
  var bookingList = <BookingModel>[].obs;
  var isProcessing = false.obs; // ✅ Prevents multiple simultaneous operations

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  /// ✅ **Fetch Bike Bookings (Optimized)**
  Future<void> fetchBookings() async {
    if (isProcessing.value) return; // ✅ Prevent multiple fetches at once
    isProcessing.value = true;

    try {
      final bookings = await DBHelper.getBookings();
      final bookingModels =
          bookings.map((e) => BookingModel.fromMap(e)).toList();

      bookingList.assignAll(bookingModels);

      // 🔍 Print all bookings
      for (var booking in bookingModels) {
        log(
          "📅 Booking => ${booking.bikeName} (${booking.bikeModel}) | "
          "balance: ${booking.balance} ${booking.finalAmountPayable} ||||||||||----"
          "From: ${booking.pickupDate} ${booking.pickupTime} "
          "To: ${booking.dropoffDate} ${booking.dropoffTime} | ",
        );
      }
    } catch (e) {
      log("❌ Error fetching bookings: $e");
    } finally {
      isProcessing.value = false;
    }
  }

  /// ✅ **Add Bike Booking**
  Future<void> addBooking(BookingModel booking) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    try {
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.insert('Bookings', booking.toMap());
        });
      });
      // 🔍 Print all bookings after insertion
    } catch (e) {
      log("Error adding booking: $e");
      Get.snackbar("Database Error", "Failed to add booking.");
    } finally {
      isProcessing.value = false;
    }
  }

  /// ✅ **Update Bike Booking**
  Future<void> updateBooking(BookingModel booking) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    try {
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.update(
            'Bookings',
            booking.toMap(),
            where: 'id = ?',
            whereArgs: [booking.id],
          );
        });
      });
      await fetchBookings(); // ✅ Refresh list after updating a booking
    } catch (e) {
      log("Error updating booking: $e");
      Get.snackbar("Database Error", "Failed to update booking.");
    } finally {
      isProcessing.value = false;
    }
  }

  /// ✅ **Delete Bike Booking**
  Future<void> deleteBooking(int id) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    try {
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.delete('Bookings', where: 'id = ?', whereArgs: [id]);
        });
      });
      await fetchBookings(); // ✅ Refresh list after deleting a booking
    } catch (e) {
      log("Error deleting booking: $e");
      Get.snackbar("Database Error", "Failed to delete booking.");
    } finally {
      isProcessing.value = false;
    }
  }
}
