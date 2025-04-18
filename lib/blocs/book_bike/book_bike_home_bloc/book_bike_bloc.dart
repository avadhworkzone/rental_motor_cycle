import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_motor_cycle/database/db_helper.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'package:rental_motor_cycle/model/booking_model.dart';
import 'book_bike_event.dart';
import 'book_bike_state.dart';

class BookBikeBloc extends Bloc<BookBikeEvent, BookBikeState> {
  BookBikeBloc() : super(BookBikeInitial()) {
    on<FetchBikeEvents>(_onFetchBikes);
    on<FetchBookingsEvent>(_onFetchBookings);
    on<AddBookingEvent>(_onAddBooking);
    on<UpdateBookingEvent>(_onUpdateBooking);
    on<DeleteBookingEvent>(_onDeleteBooking);
  }
  List<BookingModel> bookingList = [];

  // Future<void> _onFetchBikes(
  //   FetchBikeEvents event,
  //   Emitter<BookBikeState> emit,
  // ) async {
  //   emit(BookBikeLoading());
  //   try {
  //     final rawList = await DBHelper.getBikes();
  //     final bikes = rawList.map((e) => BikeModel.fromMap(e)).toList();
  //     emit(BookBikeLoaded(bikes));
  //   } catch (e) {
  //     emit(BookBikeError('Failed to load bikes'));
  //   }
  // }
  Future<void> _onFetchBikes(
    FetchBikeEvents event,
    Emitter<BookBikeState> emit,
  ) async {
    emit(BookBikeLoading());
    try {
      // Fetch bikes from DB
      final rawBikeList = await DBHelper.getBikes();
      final bikes = rawBikeList.map((e) => BikeModel.fromMap(e)).toList();

      // Fetch bookings from DB
      final rawBookingList =
          await DBHelper.getBookings(); // <--- this line depends on your DB function name
      final bookings =
          rawBookingList.map((e) => BookingModel.fromMap(e)).toList();
      bookingList = bookings;
      // Emit loaded state
      emit(BookBikeLoaded(bikes: bikes, bookings: bookings));
    } catch (e) {
      emit(BookBikeError('Failed to load bikes and bookings'));
    }
  }

  Future<void> _onFetchBookings(
    FetchBookingsEvent event,
    Emitter<BookBikeState> emit,
  ) async {
    emit(BookBikeLoading());
    try {
      final bookings = await DBHelper.getBookings();

      final bookingModels =
          bookings.map((e) => BookingModel.fromMap(e)).toList();
      bookingList = bookingModels;
      final rawBikeList = await DBHelper.getBikes();
      final bikes = rawBikeList.map((e) => BikeModel.fromMap(e)).toList();
      emit(BookBikeLoaded(bookings: bookingModels, bikes: bikes));
      // emit(BookingsLoaded(bookingModels));
    } catch (e) {
      emit(BookingError("Failed to fetch bookings."));
    }
  }

  Future<void> _onAddBooking(
    AddBookingEvent event,
    Emitter<BookBikeState> emit,
  ) async {
    emit(BookBikeLoading());
    try {
      final booking = event.booking;
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.insert('Bookings', booking.toMap());
        });
      });
      emit(BookingSuccess("Booking added successfully"));
      add(FetchBookingsEvent()); // Refresh bookings
    } catch (e) {
      emit(BookingError("Failed to add booking"));
    }
  }

  Future<void> _onUpdateBooking(
    UpdateBookingEvent event,
    Emitter<BookBikeState> emit,
  ) async {
    emit(BookBikeLoading());
    try {
      final booking = event.booking;
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
      emit(BookingSuccess("Booking updated successfully"));
      add(FetchBookingsEvent()); // Refresh bookings
    } catch (e) {
      emit(BookingError("Failed to update booking"));
    }
  }

  Future<void> _onDeleteBooking(
    DeleteBookingEvent event,
    Emitter<BookBikeState> emit,
  ) async {
    emit(BookBikeLoading());
    try {
      await DBHelper.database.then((db) async {
        await db.transaction((txn) async {
          await txn.delete(
            'Bookings',
            where: 'id = ?',
            whereArgs: [event.bookingId],
          );
        });
      });
      emit(BookingSuccess("Booking deleted successfully"));
      add(FetchBookingsEvent()); // Refresh bookings list
    } catch (e) {
      emit(BookingError("Failed to delete booking"));
    }
  }
}
