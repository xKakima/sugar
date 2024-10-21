import 'package:sugar/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sugar/utils/constants.dart';

Future<Map<String, dynamic>> upsertBudget(Map<String, dynamic> budgetData,
    {ownerIsUser = false}) async {
  try {
    // add user_id to userData
    if (ownerIsUser) {
      budgetData['user_id'] = supabase.auth.currentUser!.id;
    } else {
      budgetData['user_id'] = dataStore.getData("partnerId");
    }
    print("Upserting budget data: $budgetData");
    final response =
        await supabase.from('monthly_budget').upsert(budgetData).select('*');
    print("Response: $response");

    print('Upsert successful');
    dataStore.sugarFundsBalance.value = budgetData['balance'];
    return {"success": true, "message": 'Upsert successful'};
  } catch (e) {
    print('Exception during upsert: $e');
    return {"success": false, "message": e.toString()};
  }
}

Future<Map<String, dynamic>> updateBudget(Map<String, dynamic> budgetData,
    {ownerIsUser = false}) async {
  try {
    late String userId;
    if (ownerIsUser) {
      userId = supabase.auth.currentUser!.id;
    } else {
      userId = dataStore.getData("partnerId");
    }
    print("Updating budget data: $budgetData");
    final response = await supabase
        .from('monthly_budget')
        .update(budgetData)
        .eq('user_id', userId)
        .select('*');
    print("Response: $response");

    print('Update successful');
    return {"success": true, "message": 'Upsert successful'};
  } catch (e) {
    print('Exception during update: $e');
    return {"success": false, "message": e.toString()};
  }
}

Future<double> fetchBudget(String? partnerId) async {
  late PostgrestList budget;

  // If partnerId is null, only filter by the current user's ID
  if (partnerId == null) {
    budget = await supabase
        .from('monthly_budget')
        .select('*')
        .eq('user_id', supabase.auth.currentUser!.id);
    dataStore.setData("budgetOwner", 'user');
  } else {
    // If partnerId is not null, filter by both user_id and partner_id
    budget = await supabase.from('monthly_budget').select('*').or(
        'user_id.eq.${supabase.auth.currentUser!.id},user_id.eq.$partnerId');

    if (budget[0]['user_id'] == supabase.auth.currentUser!.id) {
      print("budget owner is user");
      dataStore.setData("budgetOwner", 'user');
    } else if (budget[0]['user_id'] == partnerId) {
      print("budget owner is partner");
      dataStore.setData("budgetOwner", 'partner');
    }
  }

  // Check if there are results and return the formatted budget
  if (budget.isNotEmpty) {
    return budget[0]['balance'];
  } else {
    // If no balance is found, return a default value (like '0')
    return 0;
  }
}

Future<PostgrestMap?> fetchBudgetData(String? partnerId) async {
  late PostgrestMap budget;

  // If partnerId is null, only filter by the current user's ID
  if (partnerId == null) {
    budget = await supabase
        .from('monthly_budget')
        .select('*')
        .eq('user_id', supabase.auth.currentUser!.id)
        .single();
  } else {
    // If partnerId is not null, filter by both user_id and partner_id
    budget = await supabase
        .from('monthly_budget')
        .select('*')
        .or('user_id.eq.${supabase.auth.currentUser!.id},user_id.eq.$partnerId')
        .single();
  }

  // Check if there are results and return the formatted budget
  if (budget.isNotEmpty) {
    return budget;
  } else {
    return null;
  }
}
