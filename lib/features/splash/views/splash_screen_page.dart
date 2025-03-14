import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugar/shared/utils/utils.dart';
import 'package:sugar/shared/widgets/background.dart';
import 'package:sugar/core/services/data_store_controller.dart';
import 'package:sugar/core/database/budget.dart';
import 'package:sugar/core/database/user_data.dart';
import 'package:sugar/features/home/views/home_page.dart';
import 'package:sugar/features/auth/views/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sugar/shared/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final dataStore = Get.find<DataStoreController>();
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late int _loadDuration;

  @override
  void initState() {
    super.initState();

    _loadDuration = Random().nextInt(2) + 1; // 1 to 2 seconds
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _loadDuration),
    );

    _progressAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _startLoading();
  }

  Future<void> _startLoading() async {
    _animationController.forward().whenComplete(() async {
      final prefs = await SharedPreferences.getInstance();
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _redirect(isLoggedIn);
    });
  }

  Future<void> _redirect(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    if (!isLoggedIn) {
      Get.to(() => LoginPage());
      return;
    }
    try {
      final googleUser = await GoogleSignIn().signInSilently();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;
        await prefs.setString("googleIdToken", idToken!);
        await prefs.setString("googleAccessToken", accessToken!);
        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );

        final userData = await fetchUserData();
        if (userData.isEmpty || userData['user_id'] == null) {
          Get.to(() => LoginPage());
          return;
        }

        late String balance;
        if (userData['partner_id'] != null) {
          dataStore.setData("partnerId", userData['partner_id']);
          balance = await fetchMonthlyBalance(userData['partner_id']);
        } else {
          balance = await fetchMonthlyBalance(null);
        }

        dataStore.sugarFundsBalance.value = balance;
        dataStore.setData("userType", userData['user_type'].toString());
        Get.to(() => HomePage());
      } else {
        await logout();
        Get.to(() => LoginPage());
      }
    } catch (e) {
      await logout();
      Get.to(() => LoginPage());
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset(
                  'assets/images/splash_screen_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.15,
                right: MediaQuery.of(context).size.width * 0.08,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Background bar (empty state)
                    Image.asset(
                      'assets/images/loading_bar.png',
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 25,
                      fit: BoxFit.contain,
                    ),

                    // Expanding fill effect (now properly timed)
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) => ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            width:
                                (MediaQuery.of(context).size.width * 0.2 - 8) *
                                    _progressAnimation.value,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.4),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
