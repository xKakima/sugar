import 'package:sugar/utils/constants.dart';

Future<List<dynamic>?> fetchAccounts(String userId) async {
  return await supabase.from('account').select().eq('user_id', userId);
}

Future<dynamic> upsertAccount(Map<String, dynamic> accountData) async {
  try {
    // add user_id to userData
    if (accountData['id'] == "") {
      accountData.remove('id');
    }
    accountData['user_id'] = supabase.auth.currentUser!.id;
    print("upserting account data: $accountData");
    await supabase.from('account').upsert(accountData, onConflict: 'id');

    print('upserting successful');
    return {"success": true, "message": 'upserting successful'};
  } catch (e) {
    print('Exception during upserting: $e');
    return {"success": false, "message": e.toString()};
  }
}

Future<double> fetchAccountsTotal(bool forCurrentUser) async {
  late String userId;

  if (forCurrentUser) {
    userId = supabase.auth.currentUser!.id;
  } else {
    userId = dataStore.getData("partnerId");
  }

  final response =
      await supabase.from('account').select('balance').eq('user_id', userId);
  print("fetchAccountsTotal: $response");
  if (response.isEmpty) return 0.0;

  late double total = 0.0;
  response.forEach((balance) {
    total += balance['balance'];
  });

  return total;
}

Future<bool> deleteAccount(String accountId) async {
  final response = await supabase.from('account').delete().eq('id', accountId);

  final account = await supabase.from('account').select().eq('id', accountId);
  print("deleteAccount: $account");
  if (account.isEmpty) return true;
  return false;
}

Future<double> getAccountBalanceHistory(String accountId) async {
  final response = await supabase
      .from('account_balance_history')
      .select("balance")
      .eq('account_id', accountId)
      .order('recorded_at', ascending: false)
      .limit(1)
      .single(); // Ensures only one record is returned
  if (response.isEmpty) return 0;

  print("getLatestAccountBalance: $response");
  return response['balance'];
}
