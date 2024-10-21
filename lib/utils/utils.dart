// lib/utils.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sugar/utils/constants.dart';

double getWidthPercentage(BuildContext context, double percentage) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth * (percentage / 100);
}

double getHeightPercentage(BuildContext context, double percentage) {
  final screenHeight = MediaQuery.of(context).size.height;
  return screenHeight * (percentage / 100);
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat numberFormat = NumberFormat.decimalPattern();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any non-digit characters
    String newText = newValue.text.replaceAll(',', '');
    String formattedText = numberFormat.format(int.parse(newText));

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

int convertStringToInt(String value) {
  return int.parse(value.replaceAll(',', ''));
}

String convertAndFormatToString(double value) {
  // Remove any non-numeric characters, except for the decimal point
  String cleanValue = value.toString().replaceAll(RegExp(r'[^\d.]'), '');

  // Parse the value as a double, and handle possible errors
  double parsedValue = double.tryParse(cleanValue) ?? 0.0;

  // If the value has more than two decimal places, limit it to two
  parsedValue = double.parse(parsedValue.toStringAsFixed(2));

  // Limit the value to 9 digits before the decimal point
  if (parsedValue >= 1000000000) {
    parsedValue = 999999999.99; // Cap the value at 999,999,999.99
  }

  // Use intl NumberFormat to format the number with commas and two decimal places
  final NumberFormat formatter = NumberFormat('#,##0.00');
  String formattedValue = formatter.format(parsedValue);

  return formattedValue;
}

double formatNumber(String value) {
  return double.parse(value.replaceAll(',', ''));
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String formattedDate({DateTime? date}) {
  final DateTime now = date ?? DateTime.now();
  return DateFormat('EEE, dd MMMM yyyy').format(now);
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clears all stored user data

  await supabase.auth.signOut();
  await GoogleSignIn().signOut(); // Ensure Google session is cleared
}

String getTypeImageString(type) {
  switch (type) {
    case "SNACKS":
      return "assets/images/snacks.png";
    case "COFFEE":
      return "assets/images/coffee.png";
    case "ICE_CREAM":
      return "assets/images/ice_cream.png";
    case "MEAL":
      return "assets/images/meal.png";
    case "GROCERY":
      return "assets/images/grocery.png";
    case "RAMEN":
      return "assets/images/ramen.png";

    default:
      return "assets/images/snacks.png";
  }
}
