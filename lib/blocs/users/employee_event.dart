import '../../model/user_model.dart';

abstract class EmployeeEvent {}

class FetchUsers extends EmployeeEvent {}

class AddUser extends EmployeeEvent {
  final UserModel user;
  AddUser(this.user);
}

class UpdateUser extends EmployeeEvent {
  final UserModel user;
  UpdateUser(this.user);
}

class DeleteUser extends EmployeeEvent {
  final int id;
  DeleteUser(this.id);
}
