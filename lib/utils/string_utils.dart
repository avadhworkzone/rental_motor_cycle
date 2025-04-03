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
  static const takePhoto = "Take Photo";
  static const chooseFromGalary = "Choose From Galary";
  static const addBikeImage = "Add bike image";
  static const addNewBike = "Add New Bike";
  static const bikeName = "Bike Name";
  static const enterBikeName = "Enter Bike Name";
  static const bikeModel = "Bike Model";
  static const enterBikeModel = "Enter Bike Model";
  static const numberPlate = "Number Plate";
  static const enterNumberPlate = "Enter Number Plate";
  static const rentPerDay = "Rent Per Day (\$)";
  static const enterRentPrice = "Enter Rent Price";
  static const bikeLocation = "Bike Location";
  static const enterLocation = "Enter Location";
  static const petrol = "Petrol";
  static const diesel = "Diesel";
  static const electric = "Electric";
  static const fuelType = "Fuel Type";
  static const selectFuelType = "Select Fuel Type";
  static const mileage = "Mileage (km/l)";
  static const enterMileage = "Enter Mileage";
  static const engineCC = "Engine CC";
  static const enterEngineCC = "Enter Engine CC";
  static const bikeDescription = "Bike Description";
  static const enterDescription = "Enter Description";
  static const addBike = "Add Bike";
  static const updateBike = "Update Bike";
  static const bikeAddedSuccessfully = "Bike Added Successfully!";
  static const deleteBike = "Delete Bike";
  static const deleteConfirmation =
      "Are you sure you want to delete this bike?";
  static const delete = "Delete";
  static const cancel = "Cancel";
  static const noBikesFound = "No bikes found. Add a new bike!";
  static const perDay = "/ Day";
  static const edit = "Edit";
  static const String model = "Model";
  static const String rentPerDayWithoutDoller = "Rent per Day";
  static const String location = "Location";
  static const String description = "Description";
}

logs(String title) {
  if (kDebugMode) {
    print(title);
  }
}
