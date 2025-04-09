import 'dart:developer';

import 'package:get/get.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import '../database/db_helper.dart';
import '../model/reservation_model.dart';

/*class BookingController extends GetxController {
  var reservationList = <ReservationModel>[].obs;
  var isProcessing = false.obs; // ✅ Prevents multiple simultaneous operations

  @override
  void onInit() {
    super.onInit();
    fetchReservations();
  }

  /// ✅ **Fetch Reservations (Optimized)**
  Future<void> fetchReservations() async {
    if (isProcessing.value) return; // ✅ Prevent multiple fetches at once
    isProcessing.value = true;

    try {
      final reservations = await DBHelper.getReservations();
      reservationList.assignAll(reservations.map((e) => ReservationModel.fromMap(e)).toList());
    } catch (e) {
      log("Error fetching reservations: $e");
    } finally {
      isProcessing.value = false;
    }
  }

  /// ✅ **Check if User Exists Before Creating Reservation**
  // Future<bool> _doesUserExist(int userId) async {
  //   final users = await DBHelper.getUsers();
  //   return users.any((user) => user["id"] == userId);
  // }

  /// ✅ **Add Reservation with Foreign Key Validation**
  Future<void> addReservation(ReservationModel reservation) async {
    if (isProcessing.value) return;
    isProcessing.value = true;
    //
    // if (!(await _doesUserExist(reservation.userId))) {
    //   Get.snackbar("Error", "User ID ${reservation.userId} does not exist. Please create the user first.");
    //   isProcessing.value = false;
    //   return;
    // }

    try {
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.insert('Reservations', reservation.toMap());
        });
      });
      await fetchReservations(); // ✅ Refresh list after adding a reservation
    } catch (e) {
      log("Error adding reservation: $e");
      Get.snackbar("Database Error", "Failed to add reservation.");
    } finally {
      isProcessing.value = false;
    }
  }

  /// ✅ **Update Reservation with Foreign Key Validation**
  Future<void> updateReservation(ReservationModel reservation) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    // if (!(await _doesUserExist(reservation.userId))) {
    //   Get.snackbar("Error", "User ID ${reservation.userId} does not exist. Update failed.");
    //   isProcessing.value = false;
    //   return;
    // }

    try {
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.update('Reservations', reservation.toMap(),
              where: 'id = ?', whereArgs: [reservation.id]);
        });
      });
      await fetchReservations(); // ✅ Refresh list after updating a reservation
    } catch (e) {
      log("Error updating reservation: $e");
      Get.snackbar("Database Error", "Failed to update reservation.");
    } finally {
      isProcessing.value = false;
    }
  }

  /// ✅ **Delete Reservation with Error Handling**
  Future<void> deleteReservation(int id) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    try {
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.delete('Reservations', where: 'id = ?', whereArgs: [id]);
        });
      });
      await fetchReservations(); // ✅ Refresh list after deleting a reservation
    } catch (e) {
      log("Error deleting reservation: $e");
      Get.snackbar("Database Error", "Failed to delete reservation.");
    } finally {
      isProcessing.value = false;
    }
  }
}*/
class BikeBookingController extends GetxController {
  var bookingList = <BookingModel>[].obs;
  var isProcessing = false.obs; // ✅ Prevents multiple simultaneous operations

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  /// ✅ **Fetch Bike Bookings (Optimized)**
  // Future<void> fetchBookings() async {
  //   if (isProcessing.value) return; // ✅ Prevent multiple fetches at once
  //   isProcessing.value = true;
  //
  //   try {
  //     final bookings = await DBHelper.getBookings();
  //     bookingList.assignAll(
  //       bookings.map((e) => BookingModel.fromMap(e)).toList(),
  //     );
  //   } catch (e) {
  //     log("Error fetching bookings: $e");
  //   } finally {
  //     isProcessing.value = false;
  //   }
  // }
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
