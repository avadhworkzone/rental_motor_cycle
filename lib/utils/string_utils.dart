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
  static const String pleaseChangeTheDataBeforeSaving =
      "Please change the data before saving.";
  static const String noBookedBikes = "No Booked Bikes found";
  static const String phone = "Phone";
  static const String email = "Email";
  static const String ratePerDay = "Rate per Day";
  static const String subtotal = "Subtotal";
  static const String tax = "Tax";
  static const String discount = "Discount";
  static const String grandTotal = "Grand Total";
  static const String prepayment = "Prepayment";
  static const String deleteBooking = "Delete Booking";
  static const String deleteConfirmationForBooking =
      "Are you sure you want to delete this booking?";
  static const String yes = "Yes";
  static const String no = "No";
  static const String selectBike = "Select Bike";
  static const String selectABike = "Select a bike";
  static const String fromDate = "From Date";
  static const String toDate = "To Date";
  static const String bookNow = "Book Now";
  static const String updateBooking = "Update Booking";
  static const String enter = "Enter";
  static const String select = "Select";
  static const String editBooking = "Edit Booking";
  static const String trips = "Trips";
  static const String seater = "Seater";
  static const String availableAt = "Available at";
  static const String kmLimit = "Km limit:";
  static const String extra = "Extra:";
  static const String fuel = "Fuel";
  static const String deposit = "Deposit:";
  static const String makeYear = "Make Year";
  static const String included = "Fuel Included";
  static const String excluded = "Fuel Excluded";
  static const String confirmBooking = "Confirm Booking";
  static const String transmission = "Transmission";
  static const String selectTransmission = "Select Transmission";
  static const String automatic = "Automatic";
  static const String manual = "Manual";
  static const String semiAutomatic = "Semi-Automatic";
  static const String selectSeater = "Select Seater";
  static const String selectFuelOption = "Select Fuel Option";
  static const String enterDepositAmount = "Enter deposit amount";
  static const String deposite = "Deposit";
  static const String enterExtraKmRate = "Enter extra km rate";
  static const String extraPerKm = "Extra \$ per km";
  static const String enterKmLimit = "Enter km limit";
  static const String kmLimitWithoutCollen = "Km Limit";
  static const String makeYearWithoutCollen = "Make Year";
  static const String selectYear = "Select Year";
  static const String enterMakeYear = "Enter make year";
  static const String tripsDone = "Trips Done";
  static const String enterTripsDone = "Enter trips done";
  static const String selectTime = "Select Time";
  static const String invalidSelection = "Invalid Selection";
  static const String pleaseSelectBothTheDates = "Please select both dates";
  static const String selectDates = "Select Date";
  static const String discountCantMoreThanTotal =
      "Discount can't be more than total rent.";
  static const String dropOffMustBeOneHour =
      "Drop-off must be at least 1 hour after pickup";
  static const String confirm = "Confirm";
  static const String oneDay = "1 day";
  static const String hours = "hours";
  static const String days = "days";

  static const String bookingSummary = "Booking Summary";
  static const String totalRent = "Total Rent";
  static const String depositPrepayment = "Deposit / Prepayment";
  static const String amountPayable = "Amount Payable";

  static const String bike = "Bike";
  static const String from = "From";
  static const String to = "To";
  static const String duration = "Duration";
  static const String depositAmount = "Deposit Amount";
  static const String totalAmount = "Total Amount";

  static const String bikeBookedSuccessfully = "Bike Booked Successfully!";
}

logs(String title) {
  if (kDebugMode) {
    print(title);
  }
}
