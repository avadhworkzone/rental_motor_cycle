import 'package:flutter/foundation.dart';

class StringUtils {
  static const storagePassword = "GafaClient";

  ///BioMatric Confirmation
  static const fingerprintSetup = "Biometric setup";

  ///
  static const onboadingTitle = "Ride Anytime, Anywhere";
  static const onboadingDetails =
      "Rent a motorcycle in just a few taps. Choose your ride, book instantly, and hit the road hassle-free!";
  static const startRiding = "START RIDING";
  static const userName = "Username";
  static const password = "Password";
  static const fullName = "FullName";
  static const enterUserName = "Enter username";
  static const enterFullName = "Enter FullName";
  static const passwordMustBeSixCharaters = "Password must be 6+ chars";
  static const login = "Login";
  static const dontHaveAnAccount = "Don't have an account? ";
  static const alreadyHaveAnAccount = "Already have an account? ";
  static const signUpSuccessful = "Signup Successful!";
  static const signup = "Signup";
  static const loginSuccessful = "Login Successful";
  static const invalidCredentials = "Invalid Credentials!";
  static const rentalMotorCycle = "Rental Motor Cycle";
  static const myBikes = "My Bikes";
  static const calendar = "Calendar";
  static const bookBike = "Book Bike";
  static const users = "Users";
  static const settings = "Settings";
}

logs(String title) {
  if (kDebugMode) {
    print(title);
  }
}
