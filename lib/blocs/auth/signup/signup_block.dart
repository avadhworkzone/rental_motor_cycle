import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rental_motor_cycle/blocs/auth/signup/signup_event.dart';
import 'package:rental_motor_cycle/blocs/auth/signup/signup_state.dart';
import 'package:rental_motor_cycle/controller/employee_controller.dart';
import 'package:rental_motor_cycle/model/login_user_model.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final EmployeeController employeeController;

  SignupBloc({required this.employeeController}) : super(SignupInitial()) {
    on<SignupSubmitted>((event, emit) async {
      emit(SignupLoading());
      try {
        await employeeController.addLoginUser(
          LoginUserModel(
            username: event.username.trim(),
            password: event.password.trim(),
            fullname: event.fullname.trim(),
          ),
        );
        emit(SignupSuccess());
      } catch (e) {
        emit(SignupFailure(e.toString()));
      }
    });
  }
}