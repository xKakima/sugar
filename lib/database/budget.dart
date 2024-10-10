import 'package:sugar/widgets/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<Map<String, dynamic>> upsertBudget(
    Map<String, dynamic> budgetData) async {
  try {
    // add user_id to userData
    budgetData['user_id'] = supabase.auth.currentUser!.id;
    final response = await supabase.from('monthly_budget').upsert(budgetData);

    print('Upsert successful');
    return {"success": true, "message": 'Upsert successful'};
  } catch (e) {
    print('Exception during upsert: $e');
    return {"success": false, "message": e.toString()};
  }
}

Future<String> fetchBudget() async {
  late PostgrestList budget;
  budget = await supabase
      .from('monthly_budget')
      .select('*')
      .eq('user_id', {supabase.auth.currentUser?.id});

  if (budget.isEmpty) {
    print("No budget found for user, fetching partner balance");
    budget = await supabase
        .from('monthly_budget')
        .select('*')
        .eq('partner_id', {supabase.auth.currentUser?.id});
  }
  print("fetch balance: $budget");
  return formatWithCommas(budget[0]['budget'].toString());
}
