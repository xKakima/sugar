import 'package:flutter/material.dart';

enum AppColors {
  sugarBabyBalance(Color.fromARGB(255, 200, 158, 158)),
  sugarDaddyBalance(Color.fromARGB(255, 158, 190, 200)),
  sugarFundsBalance(Color.fromARGB(255, 55, 55, 55)),
  sugarFundsFullBalance(Color.fromARGB(255, 88, 163, 164)),
  sugarFundsHalfBalance(Color.fromARGB(255, 163, 156, 88)),
  sugarFundsEmptyBalance(Color.fromARGB(255, 163, 88, 88)),
  roundedContainer(Color.fromARGB(255, 30, 30, 30)),
  background(Color(0xFF1F1F1F)),
  accountBoxDefault(Color.fromARGB(255, 61, 61, 61)),
  accountBox2(Color.fromARGB(255, 200, 158, 158)),
  accountBox3(Color.fromARGB(255, 158, 186, 200)),
  accountBox4(Color.fromARGB(255, 169, 158, 200)),
  accountBox5(Color.fromARGB(255, 165, 200, 158)),
  accountBox6(Color.fromARGB(255, 200, 194, 158));

  final Color color;

  const AppColors(this.color);
}

extension AppColorExtension on AppColors {
  String get name {
    switch (this) {
      case AppColors.sugarBabyBalance:
        return 'sugarBabyBalance';
      case AppColors.sugarDaddyBalance:
        return 'sugarDaddyBalance';
      case AppColors.sugarFundsBalance:
        return 'sugarFundsBalance';
      case AppColors.sugarFundsFullBalance:
        return 'sugarFundsFullBalance';
      case AppColors.sugarFundsHalfBalance:
        return 'sugarFundsHalfBalance';
      case AppColors.sugarFundsEmptyBalance:
        return 'sugarFundsEmptyBalance';
      case AppColors.roundedContainer:
        return 'roundedContainer';
      case AppColors.background:
        return 'background';
      case AppColors.accountBoxDefault:
        return 'accountBoxDefault';
      case AppColors.accountBox2:
        return 'accountBox2';
      case AppColors.accountBox3:
        return 'accountBox3';
      case AppColors.accountBox4:
        return 'accountBox4';
      case AppColors.accountBox5:
        return 'accountBox5';
      case AppColors.accountBox6:
        return 'accountBox6';
    }
  }

  static Color fromName(String name) {
    return AppColors.values
        .firstWhere(
          (color) => color.name == name,
          orElse: () => AppColors
              .background, // Provide a default color if no match is found
        )
        .color;
  }
}
