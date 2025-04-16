import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:rental_motor_cycle/controller/employee_controller.dart';
import 'package:rental_motor_cycle/utils/shared_preference_utils.dart';
import 'package:get/get.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final EmployeeController employeeController;

  LoginBloc({required this.employeeController}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    await employeeController.loginFetchUsers();

    final user = employeeController.loginUserList.firstWhereOrNull((user) =>
    user.username == event.username &&
        user.password == event.password);

    if (user != null) {
      await SharedPreferenceUtils.setValue(SharedPreferenceUtils.isLoggedIn, true);
      await SharedPreferenceUtils.setValue(SharedPreferenceUtils.userId, user.id.toString());
      await SharedPreferenceUtils.setValue(SharedPreferenceUtils.username, user.username ?? '');

      emit(LoginSuccess());
    } else {
      emit(LoginFailure('Invalid credentials'));
    }
  }
}
