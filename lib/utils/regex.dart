import 'package:flutter/services.dart';

class RegularExpression {
  /// capitalCase is used for one capital character is requiter in string
  var capitalCase = RegExp(r'[A-Z]');
  static String passwordValidPattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  /// smallCase is used for one small character is requiter in string
  var smallCase = RegExp(r'[a-z]');
  static String noSpaceAlphaNumPattern = r"^[A-Za-z0-9]+$";

  static String alphabetPattern = r"[a-zA-Z]";

  static String noMultipleSpacePattern = r"^(?! )[A-Za-z]+(?: [A-Za-z]+)*$";

  /// atLeastOneNumber is used for one number is requiter in string
  var atLeastOneNumber = RegExp(r'[0-9]');

  /// specialCharacters is used for one special characters is requiter in string
  var specialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  static var isValidEmail = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static RegExp passwordValidator = RegExp(
    r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W)(?!.* ).{8,12}',
  );

  /// minimum password validation
  static var passwordMinLength = 7;

  var whiteSpace = RegExp("\\s+");

  //Deny Multiple Spaces
  static List<TextInputFormatter> denyMultipleSpaces = [
    FilteringTextInputFormatter.deny(RegExp(r"\s{2,}")),
  ];

  static List<TextInputFormatter> get alphabetWithSingleSpace => [
    FilteringTextInputFormatter.allow(
      RegExp('[a-zA-Z ]'),
    ), // Allow alphabets and spaces
    FilteringTextInputFormatter.deny(RegExp(r'\s{2,}')), // Deny multiple spaces
  ];

  // Allow only alphabets (No spaces)
  // Deny spaces but allow all other characters
  static List<TextInputFormatter> get noSpacesAllowed => [
    FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny all spaces
  ];
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  CustomRangeTextInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    int? value = int.tryParse(newValue.text);
    if (value == null || value < min || value > max) {
      return oldValue; // Revert to previous value if out of range
    }
    return newValue;
  }
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}

class NoConsecutiveSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Check if the new value has consecutive spaces
    if (newValue.text.contains('  ')) {
      // If consecutive spaces are found, return the old value (keeping the old input)
      return oldValue;
    }
    // Otherwise, allow the new value
    return newValue;
  }
}

/// VALIDATION METHOD
// class ValidationMethod {
//   /// EMAIL VALIDATION METHOD
//   static String? validateEmail(value) {
//     bool regex = RegExp(
//             r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
//         .hasMatch(value);
//     if (value == null) {
//       return AppStrings.emailIsRequired;
//     } else if (regex == false) {
//       return AppStrings.pleaseEnterValidEmail;
//     }
//
//     return null;
//   }
//
//   static String? validateName(value) {
//     bool regex = RegExp(r'^[a-zA-Z ]*\$').hasMatch(value);
//     if (value == null) {
//       return AppStrings.emailIsRequired;
//     } else if (regex == false) {
//       return AppStrings.pleaseEnterValidEmail;
//     }
//
//     return null;
//   }
//
//   emptyValidation(value) {
//     if (value.toString().isEmpty) {
//       return AppStrings.required;
//     }
//     return null;
//   }
//
//   /// PHONE VALIDATION METHOD
//   static String? validatePhone(value) {
//     bool regex = RegExp(r"\d{10}").hasMatch(value);
//     if (value == '') {
//       return AppStrings.mobileIsRequired;
//     } else if (regex == false) {
//       return AppStrings.mobileIsRequired;
//     }
//
//     return null;
//   }
//
//   /// PASSWORD VALIDATION METHOD
//   static String? validatePassword(value) {
//     bool regex = RegExp(
//             r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}')
//         .hasMatch(value);
//     if (value == null) {
//       return AppStrings.required;
//     } else if (regex == false) {
//       return AppStrings.passwordMustContain;
//     }
//     return null;
//   }
// }
