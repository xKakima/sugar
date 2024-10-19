import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

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
