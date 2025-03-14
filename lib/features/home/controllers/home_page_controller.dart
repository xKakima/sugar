import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sugar/shared/constants/app_colors.dart';
import 'package:sugar/core/database/account.dart';
import 'package:sugar/core/database/user_data.dart';
import 'package:sugar/features/account/views/account_page.dart';
import 'package:sugar/shared/utils/constants.dart';
import 'package:sugar/shared/utils/utils.dart';
import 'package:sugar/shared/widgets/balance_box.dart';
import 'package:sugar/shared/widgets/notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sugar/core/services/data_store_controller.dart';

class HomePageController extends GetxController {
  RxList<Widget> balanceBoxWidgets = <Widget>[].obs;
  late RxString sugarFundsBalance;
  RxBool isLoading = true.obs;

  late String welcomeText;
  late bool hasPartner;
  late String partnerRole;

  @override
  void onInit() {
    super.onInit();
    final dataStore = Get.find<DataStoreController>();
    sugarFundsBalance = dataStore.sugarFundsBalance;
    welcomeText = dataStore.getData("userType") == "DADDY" ? "Hi, Daddy!" : "Hi, Baby!";
    hasPartner = dataStore.getData("partnerId") != null;
    partnerRole = dataStore.getData("userType") == "DADDY" ? "BABY" : "DADDY";
    _initializeApp();
    refreshBalance();
  }



  String getBalanceBoxTitle(bool isUsersAccount) {
    final dataStore = Get.find<DataStoreController>();
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
    final dataStore = Get.find<DataStoreController>();
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
    try {
      isLoading.value = true;
      // Fetch balance boxes and update UI
      final boxes = await _buildBalanceBoxes();
      balanceBoxWidgets.value = boxes;
    } catch (e) {
      // Handle error gracefully
      balanceBoxWidgets.value = [];
    } finally {
      isLoading.value = false;
    }
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
    );
  }

  void _initializeApp() async {
    // Check if user data exists
    await supabase
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
