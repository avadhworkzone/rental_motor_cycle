const String included = "Included";
const String excluded = "Excluded";
String formatDateTime(DateTime dateTime) {
  // You can customize this format
  return "${_addLeadingZero(dateTime.day)}-${_addLeadingZero(dateTime.month)}-${dateTime.year} "
      "${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}";
}

String _addLeadingZero(int number) {
  return number < 10 ? '0$number' : '$number';
}
