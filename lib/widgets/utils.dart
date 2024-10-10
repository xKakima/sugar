// lib/utils.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

double getWidthPercentage(BuildContext context, double percentage) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth * (percentage / 100);
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

String formatWithCommas(String value) {
  // Remove any non-numeric characters, including commas
  String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');

  // Limit the length to 9 digits
  if (cleanValue.length > 9) {
    cleanValue = '999999999'; // Set to maximum value if exceeded
  }

  // Use intl NumberFormat to format the string
  final NumberFormat formatter = NumberFormat.decimalPattern();
  String formattedValue = formatter.format(int.parse(cleanValue));

  return formattedValue;
}
