import 'package:sugar/shared/utils/constants.dart';

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
    // Upsert account data with user ID
    await supabase.from('account').upsert(accountData, onConflict: 'id');
    return {"success": true, "message": 'Account updated successfully'};
  } catch (e) {
    // Log error and return failure response
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
  if (response.isEmpty) return 0.0;

  late double total = 0.0;
  for (var balance in response) {
    total += balance['balance'];
  }

  return total;
}

Future<bool> deleteAccount(String accountId) async {
  await supabase.from('account').delete().eq('id', accountId);
  final account = await supabase.from('account').select().eq('id', accountId);
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

  // Return latest balance from history
  return response['balance'];
}
