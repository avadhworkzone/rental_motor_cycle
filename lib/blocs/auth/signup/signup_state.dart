import 'package:rental_motor_cycle/model/login_user_model.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String error;

  SignupFailure(this.error);
}

class FetchLoginUsersInitial extends SignupState {}

class FetchLoginUsersLoading extends SignupState {}

class FetchLoginUsersLoaded extends SignupState {
  final List<LoginUserModel> loginUserList;

  FetchLoginUsersLoaded({required this.loginUserList});
}

class FetchLoginUsersError extends SignupState {
  final String message;
  FetchLoginUsersError(this.message);
}
