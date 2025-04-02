import 'package:get/get.dart';
import 'package:rental_motor_cycle/controller/reservation_controller.dart';
import 'package:rental_motor_cycle/controller/bike_controller.dart';
import 'package:rental_motor_cycle/controller/user_controller.dart';

class BadgeController extends GetxController {
  final UserController userController = Get.find();
  final BikeController bikeController = Get.find();
  final ReservationController reservationController = Get.find();

  var calendarBadge = 0.obs;
  var roomsBadge = 0.obs;
  var reservationsBadge = 0.obs;
  var usersBadge = 0.obs;
  var settingsBadge = 0.obs;

  @override
  void onInit() {
    super.onInit();
    updateBadgeCounts(); // ✅ Initial update

    // ✅ Update badge counts when list updates (without triggering unnecessary fetches)
    ever(reservationController.reservationList, (_) => updateBadgeCounts());
    ever(userController.userList, (_) => updateBadgeCounts());
    ever(bikeController.bikeList, (_) => updateBadgeCounts());
  }

  /// ✅ **Optimized Badge Count Update**
  void updateBadgeCounts() {
    // 🔥 Do NOT call `fetchReservations()` inside this function, just use cached values
    calendarBadge.value = reservationController.reservationList.length;
    roomsBadge.value = bikeController.bikeList.length;
    reservationsBadge.value = reservationController.reservationList.length;
    usersBadge.value = userController.userList.length;
    settingsBadge.value = 0; // Reserved for future updates
  }
}
