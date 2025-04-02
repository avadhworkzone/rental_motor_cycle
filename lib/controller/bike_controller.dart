// import 'package:get/get.dart';
// import 'package:rental_motor_cycle/model/room_model.dart';
// import '../database/db_helper.dart';
//
// class RoomController extends GetxController {
//   var roomList = <RoomModel>[].obs;
//   var isProcessing = false.obs; // ✅ Prevent multiple operations at once
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchRooms();
//   }
//
//   /// ✅ **Fetch Rooms with Safe Database Handling**
//   Future<void> fetchRooms() async {
//     if (isProcessing.value) return; // ✅ Prevent multiple fetches at once
//     isProcessing.value = true;
//
//     final rooms = await DBHelper.getRooms();
//     roomList.assignAll(rooms.map((e) => RoomModel.fromMap(e)).toList());
//
//     isProcessing.value = false;
//   }
//
//   /// ✅ **Check if User Exists Before Creating Room**
//   // Future<bool> _doesUserExist(int userId) async {
//   //   final users = await DBHelper.getUsers();
//   //   return users.any((user) => user["id"] == userId);
//   // }
//
//   /// ✅ **Add Room with Foreign Key Validation**
//   Future<void> addRoom(RoomModel room) async {
//     if (isProcessing.value) return;
//     isProcessing.value = true;
//
//     // if (!(await _doesUserExist(room.userId))) {
//     //   Get.snackbar("Error", "User ID ${room.userId} does not exist.");
//     //   isProcessing.value = false;
//     //   return;
//     // }
//
//     await DBHelper.database.then((db) async {
//       await db.transaction((txn) async {
//         await txn.insert('Rooms', room.toMap());
//       });
//     });
//
//     await fetchRooms(); // ✅ Refresh list after adding a room
//     isProcessing.value = false;
//   }
//
//   /// ✅ **Update Room with Foreign Key Validation**
//   Future<void> updateRoom(RoomModel room) async {
//     if (isProcessing.value) return;
//     isProcessing.value = true;
//
//     // if (!(await _doesUserExist(room.userId))) {
//     //   Get.snackbar("Error", "User ID ${room.userId} does not exist.");
//     //   isProcessing.value = false;
//     //   return;
//     // }
//
//     await DBHelper.database.then((db) async {
//       await db.transaction((txn) async {
//         await txn.update(
//           'Rooms',
//           room.toMap(),
//           where: 'id = ?',
//           whereArgs: [room.id],
//         );
//       });
//     });
//
//     await fetchRooms(); // ✅ Refresh list after updating a room
//     isProcessing.value = false;
//   }
//
//   /// ✅ **Delete Room Safely**
//   Future<void> deleteRoom(int id) async {
//     if (isProcessing.value) return;
//     isProcessing.value = true;
//
//     await DBHelper.database.then((db) async {
//       await db.transaction((txn) async {
//         await txn.delete('Rooms', where: 'id = ?', whereArgs: [id]);
//       });
//     });
//
//     await fetchRooms(); // ✅ Refresh list after deleting a room
//     isProcessing.value = false;
//   }
// }
import 'package:get/get.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';
import '../database/db_helper.dart';

class BikeController extends GetxController {
  var bikeList = <BikeModel>[].obs;
  var isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    logs('Calling fetchBikes() on init'); // ✅ Debugging log

    fetchBikes();
  }

  /// ✅ **Fetch All Bikes**
  Future<void> fetchBikes() async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    final bikes = await DBHelper.getBikes();

    logs('Fetched Bikes: ${bikes.length}'); // ✅ Debugging log
    for (var bike in bikes) {
      logs('Bike Data: $bike'); // ✅ Print each bike
    }

    bikeList.assignAll(bikes.map((e) => BikeModel.fromMap(e)).toList());

    isProcessing.value = false;
  }

  /// ✅ **Add a Bike**
  Future<void> addBike(BikeModel bike) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    await DBHelper.database.then((db) async {
      await db.transaction((txn) async {
        int result = await txn.insert('Bikes', bike.toMap());
        logs('Insert Result: $result'); // ✅ Debugging log
      });
    });

    await fetchBikes(); // ✅ Refresh list after adding a bike
    isProcessing.value = false;
  }

  /// ✅ **Update an Existing Bike**
  Future<void> updateBike(BikeModel bike) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    await DBHelper.database.then((db) async {
      await db.transaction((txn) async {
        await txn.update(
          'Bikes',
          bike.toMap(),
          where: 'id = ?',
          whereArgs: [bike.id],
        );
      });
    });

    await fetchBikes(); // ✅ Refresh list after updating a bike
    isProcessing.value = false;
  }

  /// ✅ **Delete a Bike Safely**
  Future<void> deleteBike(int id) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    await DBHelper.database.then((db) async {
      await db.transaction((txn) async {
        await txn.delete('Bikes', where: 'id = ?', whereArgs: [id]);
      });
    });

    await fetchBikes(); // ✅ Refresh list after deleting a bike
    isProcessing.value = false;
  }
}
