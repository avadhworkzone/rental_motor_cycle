import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_motor_cycle/database/db_helper.dart';
import 'package:rental_motor_cycle/model/bike_model.dart';
import 'book_bike_event.dart';
import 'book_bike_state.dart';

class BookBikeBloc extends Bloc<BookBikeEvent, BookBikeState> {
  BookBikeBloc() : super(BookBikeInitial()) {
    on<FetchBikesEvent>(_onFetchBikes);
  }

  Future<void> _onFetchBikes(
    FetchBikesEvent event,
    Emitter<BookBikeState> emit,
  ) async {
    emit(BookBikeLoading());
    try {
      final rawList = await DBHelper.getBikes();
      final bikes = rawList.map((e) => BikeModel.fromMap(e)).toList();
      emit(BookBikeLoaded(bikes));
    } catch (e) {
      emit(BookBikeError('Failed to load bikes'));
    }
  }
}
