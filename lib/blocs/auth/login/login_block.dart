// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_motor_cycle/blocs/auth/signup/signup_block.dart';
import 'package:rental_motor_cycle/database/db_helper.dart';
import 'package:rental_motor_cycle/model/login_user_model.dart';
import '../signup/signup_event.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:get/get.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final BuildContext context;

  LoginBloc({required this.context}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }
  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    // Load users directly here
    final rawLoginUserList = await DBHelper.getLoginUsers();
    final loginUserList =
        rawLoginUserList.map((e) => LoginUserModel.fromMap(e)).toList();

    for (var user in loginUserList) {
      debugPrint(
        '🟩 Registered User: username=${user.username}, password=${user.password}',
      );
    }

    final user = loginUserList.firstWhereOrNull(
      (user) =>
          user.username == event.username && user.password == event.password,
    );

    if (user != null) {
      await SharedPreferenceUtils.setValue(
        SharedPreferenceUtils.isLoggedIn,
        true,
      );
      await SharedPreferenceUtils.setValue(
        SharedPreferenceUtils.userId,
        user.id.toString(),
      );
      await SharedPreferenceUtils.setValue(
        SharedPreferenceUtils.username,
        user.username,
      );

      emit(LoginSuccess());
    } else {
      emit(LoginFailure('Invalid credentials'));
    }
  }

  // Future<void> _onLoginButtonPressed(
  //   LoginButtonPressed event,
  //   Emitter<LoginState> emit,
  // ) async {
  //   emit(LoginLoading());
  //   // ✅ Log entered credentials
  //   debugPrint(
  //     '🔑 Attempted Login: username=${event.username}, password=${event.password}',
  //   );
  //   context.read<SignupBloc>().add(FetchLoginUsers());
  //
  //   final user = context.read<SignupBloc>().loginUsersList.firstWhereOrNull(
  //     (user) =>
  //         user.username == event.username && user.password == event.password,
  //   );
  //
  //   if (user != null) {
  //     await SharedPreferenceUtils.setValue(
  //       SharedPreferenceUtils.isLoggedIn,
  //       true,
  //     );
  //     await SharedPreferenceUtils.setValue(
  //       SharedPreferenceUtils.userId,
  //       user.id.toString(),
  //     );
  //     await SharedPreferenceUtils.setValue(
  //       SharedPreferenceUtils.username,
  //       user.username ?? '',
  //     );
  //
  //     emit(LoginSuccess());
  //   } else {
  //     emit(LoginFailure('Invalid credentials'));
  //   }
  // }
}
