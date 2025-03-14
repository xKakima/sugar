import 'package:sugar/shared/utils/constants.dart';
import 'package:sugar/shared/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> upsertBudget(Map<String, dynamic> budgetData,
    {ownerIsUser = false}) async {
  try {
    // add user_id to userData
    if (ownerIsUser) {
      budgetData['user_id'] = supabase.auth.currentUser!.id;
    } else {
      budgetData['user_id'] = dataStore.getData("partnerId");
    }
    // Validate budget data
    if (!budgetData.containsKey('balance')) {
      return {"success": false, "message": 'Missing required field: balance'};
    }

    final response = await supabase.from('monthly_budget').upsert(budgetData).select('*');
    
    if (response.isEmpty) {
      return {"success": false, "message": 'Failed to upsert budget'};
    }

    dataStore.sugarFundsBalance.value = budgetData['balance'];
    return {"success": true, "message": 'Upsert successful'};
  } catch (e) {
    return {"success": false, "message": 'Failed to upsert budget: ${e.toString()}'};
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
    // Validate budget data
    if (!budgetData.containsKey('balance')) {
      return {"success": false, "message": 'Missing required field: balance'};
    }

    final response = await supabase
        .from('monthly_budget')
        .update(budgetData)
        .eq('user_id', userId)
        .select('*');

    if (response.isEmpty) {
      return {"success": false, "message": 'Failed to update budget'};
    }

    return {"success": true, "message": 'Update successful'};
  } catch (e) {
    return {"success": false, "message": 'Failed to update budget: ${e.toString()}'};
  }
}

Future<String> fetchMonthlyBalance(String? partnerId) async {
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
      dataStore.setData("budgetOwner", 'user');
    } else if (budget[0]['user_id'] == partnerId) {
      dataStore.setData("budgetOwner", 'partner');
    }
  }

  // Check if there are results and return the formatted budget
  if (budget.isNotEmpty) {
    return formatStringWithCommas(budget[0]['balance'].toString());
  } else {
    // If no balance is found, return a default value (like '0')
    return '0';
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
    // Budget fetched successfully
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
