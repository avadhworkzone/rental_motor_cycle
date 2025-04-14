import 'package:rental_motor_cycle/model/login_user_model.dart';
import 'package:rental_motor_cycle/model/user_model.dart';

abstract class EmployeeEvent {}

class FetchUsersEvent extends EmployeeEvent {}

class AddUserEvent extends EmployeeEvent {
  final UserModel user;
  AddUserEvent(this.user);
}

class AddLoginUserEvent extends EmployeeEvent {
  final LoginUserModel user;
  AddLoginUserEvent(this.user);
}

class UpdateUserEvent extends EmployeeEvent {
  final UserModel user;
  UpdateUserEvent(this.user);
}

class DeleteUserEvent extends EmployeeEvent {
  final int id;
  DeleteUserEvent(this.id);
}

class FetchLoginUsersEvent extends EmployeeEvent {}
