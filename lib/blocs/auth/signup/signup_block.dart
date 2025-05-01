import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rental_motor_cycle/blocs/auth/signup/signup_event.dart';
import 'package:rental_motor_cycle/blocs/auth/signup/signup_state.dart';
import 'package:rental_motor_cycle/database/db_helper.dart';
import 'package:rental_motor_cycle/model/login_user_model.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final BuildContext context;

  SignupBloc({required this.context}) : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
    on<FetchLoginUsers>(_onFetchLoginUsers);
  }

  var loginUsersList = [];
  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());

    try {
      final user = LoginUserModel(
        username: event.username.trim(),
        password: event.password.trim(),
        fullname: event.fullname.trim(),
      );
      await addLoginUser(user);
      final users = await fetchLoginUsers();
      loginUsersList = users;
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

  Future<void> addLoginUser(LoginUserModel user) async {
    final db = await DBHelper.database;
    await db.transaction((txn) async {
      await txn.insert('LoginUsers', user.toMap());
    });
  }

  Future<List<LoginUserModel>> fetchLoginUsers() async {
    final db = await DBHelper.database;
    final result = await db.query('LoginUsers');
    loginUsersList = result.map((e) => LoginUserModel.fromMap(e)).toList();
    return result.map((e) => LoginUserModel.fromMap(e)).toList();
  }

  Future<void> _onFetchLoginUsers(
    FetchLoginUsers event,
    Emitter<SignupState> emit,
  ) async {
    emit(FetchLoginUsersLoading());
    try {
      final rawLoginUserList = await DBHelper.getLoginUsers();
      final loginUserList =
          rawLoginUserList.map((e) => LoginUserModel.fromMap(e)).toList();
      loginUsersList = loginUserList;
      // Emit loaded state
      emit(FetchLoginUsersLoaded(loginUserList: loginUserList));
    } catch (e) {
      emit(FetchLoginUsersError('Failed to load login Users'));
    }
  }
}
