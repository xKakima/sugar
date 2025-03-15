import 'package:sugar/shared/utils/constants.dart';

Future<Map<String, dynamic>> upsertExpense(
    Map<String, dynamic> expenseData) async {
  try {
    // add user_id to userData
    expenseData['user_id'] = supabase.auth.currentUser!.id;
    await supabase.from('expense').upsert(expenseData);

    final response =
        await supabase.from('expense').select().eq('id', expenseData['id']);
    if (response.isEmpty) {
      return {"success": false, "message": 'Failed to verify upsert'};
    }
    return {"success": true, "message": 'Upsert successful'};
  } catch (e) {
    return {
      "success": false,
      "message": 'Failed to upsert expense: ${e.toString()}'
    };
  }
}

Future<List<dynamic>?> getExpenses() async {
  try {
    return await supabase.rpc('get_expenses',
        params: {'_user_id': supabase.auth.currentUser!.id});
  } catch (e) {
    return null;
  }
}

Future<dynamic> addExpense(Map<String, dynamic> expenseData) async {
  try {
    // add user_id to userData
    expenseData['user_id'] = supabase.auth.currentUser!.id;
    // Validate expense data
    if (!expenseData.containsKey('amount') ||
        !expenseData.containsKey('expense_type')) {
      return {
        "success": false,
        "message": 'Missing required fields: amount or expense_type'
      };
    }

    await supabase.from('expense').insert(expenseData);
    return {"success": true, "message": 'Insert successful'};
  } catch (e) {
    return {
      "success": false,
      "message": 'Failed to insert expense: ${e.toString()}'
    };
  }
}

Future<bool> deleteExpense(String expenseId) async {
  await supabase.from('expense').delete().eq('id', expenseId);

  // Verify deletion
  final expense = await supabase.from('expense').select().eq('id', expenseId);
  return expense.isEmpty;
}
