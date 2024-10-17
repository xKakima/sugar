import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugar/widgets/background.dart';
import 'package:sugar/widgets/utils.dart';
import 'package:sugar/controller/data_store_controller.dart';
import 'package:sugar/database/budget.dart';
import 'package:sugar/database/user_data.dart';
import 'package:sugar/pages/home_page.dart';
import 'package:sugar/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final dataStore = Get.find<DataStoreController>();
  double _progress = 0.0;
  late Timer _timer;
  late int _loadDuration;

  // Check the login status

  @override
  void initState() {
    super.initState();
    // Randomize the load time between 3-10 seconds
    _loadDuration = Random().nextInt(2) + 3;
    print('Load duration: $_loadDuration seconds');

    // Start loading progress
    _startLoading();
  }

  Future<void> _startLoading() async {
    final prefs = await SharedPreferences.getInstance();
    // Check the login status
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print('Is logged in: $isLoggedIn');

    // 50 ms interval between each tick
    const duration = Duration(milliseconds: 50);

    // Total number of ticks (20 ticks per second)
    final totalTicks = _loadDuration * 1000 / 50;

    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        // Increment progress based on total ticks
        _progress += 1.0 / totalTicks;

        // Ensure we don't overshoot 1.0
        if (_progress >= 1.0) {
          _progress = 1.0;
          _timer.cancel();
          _redirect(
              isLoggedIn); // Navigate to the login page when loading completes
        }
      });
    });
  }

  Future<void> _redirect(isLoggedIn) async {
    if (isLoggedIn) {
      // Double check if user is in user_data table

      final userData = await fetchUserData();
      print(userData);
      if (userData.isEmpty || userData['user_id'] == null) {
        Get.to(() => LoginPage());
        return;
      }

      if (userData['partner_id'] != null) {
        dataStore.setData("partnerId", userData['partner_id']);
      }

      final balance = await fetchBudget(userData['partner_id']);
      dataStore.setData("sweetFundsBalance", balance);
      dataStore.setData("userType", userData['user_type'].toString());
      print("Should go here home page");
      Get.to(() => HomePage());
      return;
    }

    Get.to(() => LoginPage());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        // Use the Background widget here
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or text
              const Text(
                'sugar',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Progress bar
              SizedBox(
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
