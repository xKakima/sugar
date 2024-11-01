import 'package:sugar/utils/constants.dart';
import 'package:sugar/models/expense_data.dart';
import 'package:sugar/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> upsertExpense(
    Map<String, dynamic> expenseData) async {
  try {
    // add user_id to userData
    expenseData['user_id'] = supabase.auth.currentUser!.id;
    await supabase.from('expense').upsert(expenseData);

    print('Upsert successful');
    return {"success": true, "message": 'Upsert successful'};
  } catch (e) {
    print('Exception during upsert: $e');
    return {"success": false, "message": e.toString()};
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
    print("Inserting expense data: $expenseData");
    await supabase.from('expense').insert(expenseData);

    print('Insert successful');
    return {"success": true, "message": 'Insert successful'};
  } catch (e) {
    print('Exception during insert: $e');
    return {"success": false, "message": e.toString()};
  }
}

Future<bool> deleteExpense(String expenseId) async {
  final response = await supabase.from('expense').delete().eq('id', expenseId);

  final expense = await supabase.from('expense').select().eq('id', expenseId);
  print("deleteExpense: $expense");
  if (expense.isEmpty) return true;
  return false;
}
