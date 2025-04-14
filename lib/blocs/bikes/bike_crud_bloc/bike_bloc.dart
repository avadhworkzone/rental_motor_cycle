import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_event.dart';
import 'package:rental_motor_cycle/blocs/bikes/bike_crud_bloc/bike_state.dart';
import 'package:rental_motor_cycle/database/db_helper.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/utils/string_utils.dart';

class BikeBloc extends Bloc<BikeEvent, BikeState> {
  BikeBloc() : super(BikeInitial()) {
    on<FetchBikesEvent>(_onFetch);
    on<AddBikeEvent>(_onAdd);
    on<UpdateBikeEvent>(_onUpdate);
    on<DeleteBikeEvent>(_onDelete);
  }

  Future<void> _onFetch(FetchBikesEvent event, Emitter<BikeState> emit) async {
    emit(BikeLoading());
    try {
      final bikes = await DBHelper.getBikes();
      final list = bikes.map((e) => BikeModel.fromMap(e)).toList();
      emit(BikeLoaded(list));
    } catch (e) {
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
