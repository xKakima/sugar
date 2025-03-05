import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/constants/app_colors.dart';
import 'package:sugar/database/account.dart';
import 'package:sugar/database/user_data.dart';
import 'package:sugar/pages/account_page.dart';
import 'package:sugar/utils/constants.dart';
import 'package:sugar/utils/utils.dart';
import 'package:sugar/widgets/balance_box.dart';
import 'package:sugar/widgets/notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageController extends GetxController {
  RxList<Widget> balanceBoxWidgets = <Widget>[].obs;
  RxString sugarFundsBalance = dataStore.sugarFundsBalance;

  late String welcomeText =
      dataStore.getData("userType") == "DADDY" ? "Hi, Daddy!" : "Hi, Baby!";

  late bool hasPartner = dataStore.getData("partnerId") != null;

  late String partnerRole =
      dataStore.getData("userType") == "DADDY" ? "BABY" : "DADDY";

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
    refreshBalance();
  }

  String getBalanceBoxTitle(bool isUsersAccount) {
    if (isUsersAccount) {
      return dataStore.getData("userType") == "DADDY"
          ? "sugar daddy balance"
          : "sugar baby balance";
    }
    return dataStore.getData("userType") == "DADDY"
        ? "sugar baby balance"
        : "sugar daddy balance";
  }

  String getBalanceBoxColor(bool isUsersAccount) {
    if (isUsersAccount) {
      return dataStore.getData("userType") == "DADDY"
          ? AppColors.sugarDaddyBalance.name
          : AppColors.sugarBabyBalance.name;
    }
    return dataStore.getData("userType") == "DADDY"
        ? AppColors.sugarBabyBalance.name
        : AppColors.sugarDaddyBalance.name;
  }

  Future<double> getAccountBalanceTotal(bool isUserAccount) async {
    final response = await fetchAccountsTotal(isUserAccount);
    return response;
  }

  Future<List<Widget>> _buildBalanceBoxes() async {
    if (!hasPartner) {
      return [
        BalanceBox(
          title: getBalanceBoxTitle(true),
          amount: convertAndFormatToString(await getAccountBalanceTotal(true)),
          onTap: () async {
            await _navigateToAccountPage(true);
            await refreshBalance();
          },
          color: getBalanceBoxColor(true),
        ),
        const SizedBox(height: 8),
        BalanceBox(
          title: '',
          amount: '0',
          onTap: () => {},
          color: getBalanceBoxColor(false),
          hasNoLink: true,
        ),
        const SizedBox(height: 16),
      ];
    }

    return [
      BalanceBox(
        title: getBalanceBoxTitle(true),
        amount: convertAndFormatToString(await getAccountBalanceTotal(true)),
        onTap: () async {
          await _navigateToAccountPage(true);
          await refreshBalance();
        },
        color: getBalanceBoxColor(true),
      ),
      const SizedBox(height: 8),
      BalanceBox(
        title: getBalanceBoxTitle(false),
        amount: convertAndFormatToString(await getAccountBalanceTotal(false)),
        onTap: () async {
          await _navigateToAccountPage(false);
          await refreshBalance();
        },
        color: getBalanceBoxColor(false),
      ),
      const SizedBox(height: 16),
    ];
  }

  Future<void> refreshBalance() async {
    final boxes = await _buildBalanceBoxes();
    balanceBoxWidgets.value = boxes;
  }

  Future<void> _navigateToAccountPage(bool isUserAccount) async {
    await Get.to(
      () => AccountPage(
        title: getBalanceBoxTitle(isUserAccount),
        headerColor: getBalanceBoxColor(isUserAccount),
        userId: isUserAccount
            ? supabase.auth.currentUser!.id
            : dataStore.getData("partnerId"),
        isUserAccount: isUserAccount,
      ),
      transition: Transition.upToDown,
    );
  }

  void _initializeApp() async {
    final data = await supabase
        .from("user_data")
        .select("fcm_token")
        .eq("user_id", supabase.auth.currentUser!.id)
        .single();

    // Listen to the auth state changes
    supabase.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        await FirebaseMessaging.instance.requestPermission();
        await FirebaseMessaging.instance.getAPNSToken();

        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await upsertUserData({"fcm_token": fcmToken});
        }
      }
    });

    // Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      await upsertUserData({"fcm_token": fcmToken});
    });

    FirebaseMessaging.onMessage.listen((payload) {
      final notification = payload.notification;
      if (notification == null) return;

      Notifier.show(notification.body ?? '', 3,
          title: notification.title ?? '');
    });
  }
}
