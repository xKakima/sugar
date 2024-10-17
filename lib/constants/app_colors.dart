import 'package:flutter/material.dart';

enum AppColors {
  sugarBabyBalance(Color.fromARGB(255, 200, 158, 158)),
  sugarDaddyBalance(Color.fromARGB(255, 158, 190, 200)),
  defaultBalance(Color.fromARGB(255, 88, 163, 164)),
  roundedContainer(Color.fromARGB(255, 30, 30, 30)),
  background(Color(0xFF1F1F1F));

  final Color color;

  const AppColors(this.color);
}
