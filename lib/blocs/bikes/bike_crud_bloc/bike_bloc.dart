import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_event.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_state.dart';
import 'package:rental_motor_cycle/database/db_helper.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';

class BikeBloc extends Bloc<BikeEvent, BikeState> {
  BikeBloc() : super(BikeInitial()) {
    on<FetchBikesEvent>(_onFetch);
    on<AddBikeEvent>(_onAdd);
    on<UpdateBikeEvent>(_onUpdate);
    on<DeleteBikeEvent>(_onDelete);
  }

  int bikeLength = 0;

  // Future<void> _onFetch(FetchBikesEvent event, Emitter<BikeState> emit) async {
  //   print("📥 FetchBikesEvent received");
  //   emit(BikeLoading());
  //   try {
  //     final bikes = await DBHelper.getBikes();
  //     print("✅ Bikes fetched: ${bikes.length}");
  //     bikeLength = bikes.length;
  //     final list = bikes.map((e) => BikeModel.fromMap(e)).toList();
  //     print("---list---${list.length}");
  //     emit(BikeLoaded(list));
  //   } catch (e) {
  //     print("❌ Failed to fetch bikes: $e");
  //     emit(BikeError('Failed to load bikes'));
  //   }
  // }
  Future<void> _onFetch(FetchBikesEvent event, Emitter<BikeState> emit) async {
    print("📥 FetchBikesEvent received");
    emit(BikeLoading());

    try {
      final bikesRaw = await DBHelper.getBikes();
      final bookingsRaw =
          await DBHelper.getBookings(); // assuming you have this
      final bikes = bikesRaw.map((e) => BikeModel.fromMap(e)).toList();
      final bookings = bookingsRaw.map((e) => BookingModel.fromMap(e)).toList();

      bikeLength = bikes.length;
      print("✅ Bikes fetched: ${bikes.length}");
      print("✅ Bookings fetched: ${bookings.length}");

      for (final bike in bikes) {
        final matchedBooking = bookings.firstWhere(
          (booking) => booking.bikeId == bike.id,
          orElse: () => BookingModel.empty(),
        );

        print(
          "🚲 Bike ID: ${bike.id} | Brand: ${bike.brandName} | Model: ${bike.model}",
        );

        if (matchedBooking != null) {
          print(
            "   📦 Booked By: ${matchedBooking.userFullName} | "
            "From: ${matchedBooking.pickupDate} ${matchedBooking.pickupTime} "
            "To: ${matchedBooking.dropoffDate} ${matchedBooking.dropoffTime}",
          );
        } else {
          print("   ✅ Available");
        }
      }

      emit(BikeLoaded(bikes));
    } catch (e) {
      print("❌ Failed to fetch bikes or bookings: $e");
      emit(BikeError('Failed to load bikes'));
    }
  }

  Future<void> _onAdd(AddBikeEvent event, Emitter<BikeState> emit) async {
    try {
      final db = await DBHelper.database;
      await db.insert('Bikes', event.bike.toMap());
      add(FetchBikesEvent());
    } catch (e) {
      emit(BikeError('Failed to add bike'));
    }
  }

  Future<void> _onUpdate(UpdateBikeEvent event, Emitter<BikeState> emit) async {
    try {
      final db = await DBHelper.database;
      await db.update(
        'Bikes',
        event.bike.toMap(),
        where: 'id = ?',
        whereArgs: [event.bike.id],
      );
      add(FetchBikesEvent());
    } catch (e) {
      emit(BikeError('Failed to update bike'));
    }
  }

  Future<void> _onDelete(DeleteBikeEvent event, Emitter<BikeState> emit) async {
    try {
      final db = await DBHelper.database;
      await db.delete('Bikes', where: 'id = ?', whereArgs: [event.id]);
      add(FetchBikesEvent());
    } catch (e) {
      emit(BikeError('Failed to delete bike'));
    }
  }
}
