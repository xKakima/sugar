import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

Future<PostgrestList> fetchUserData() async {
  return await supabase
      .from('user_data')
      .select('*')
      .eq('user_id', supabase.auth.currentUser!.id);
}

Future<dynamic> fetchSpecificUserData(dynamic column) async {
  return await supabase
      .from('user_data')
      .select(column)
      .eq('user_id', supabase.auth.currentUser!.id);
}

Future<dynamic> findPartner(String code) async {
  return await supabase.from('user_data').select('*').eq('unique_code', code);
}

Future<Map<String, dynamic>> upsertUserData(
    Map<String, dynamic> userData) async {
  try {
    // add user_id to userData
    userData['user_id'] = supabase.auth.currentUser!.id;
    await supabase.from('user_data').upsert(userData);

    print('Upsert successful');
    return {"success": true, "message": 'Upsert successful'};
  } catch (e) {
    print('Exception during upsert: $e');
    return {"success": false, "message": e.toString()};
  }
}

Future<void> deleteUserData(String userId) async {
  return await supabase.from('user_data').delete().eq('user_id', userId);
}

Future<Map<String, dynamic>> insertUserData(String userId) async {
  print("Insertign user data ${userId}");
  try {
    final response =
        await supabase.from('user_data').insert({'user_id': userId});
    print("Insert response: ${response}");
    return {'success': true, 'message': 'Insert successful'};
  } catch (e) {
    print("Error inserting user data: $e");
    return {'success': false, 'message': e.toString()};
  }
}
