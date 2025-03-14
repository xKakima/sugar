import 'package:sugar/shared/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<PostgrestMap> fetchUserData() async {
  try {
    final userData = await supabase
        .from('user_data')
        .select('*')
        .eq('user_id', supabase.auth.currentUser!.id)
        .single();

    return userData;
  } catch (e) {
    // Return empty map on error
    return PostgrestMap();
  }
}

Future<dynamic> fetchSpecificUserData(dynamic column) async {
  return await supabase
      .from('user_data')
      .select(column)
      .eq('user_id', supabase.auth.currentUser!.id);
}

Future<String> addPartner(String code) async {
  try {
    return await supabase.rpc('add_partner', params: {
      '_unique_code': code,
      '_user_id': supabase.auth.currentUser!.id
    });
  } catch (e) {
    return '';
  }
}

Future<Map<String, dynamic>> upsertUserData(
    Map<String, dynamic> userData) async {
  try {
    // add user_id to userData
    if (userData['user_id'] == null) {
      userData['user_id'] = supabase.auth.currentUser!.id;
    }
    // Upsert user data with user ID
    await supabase.from('user_data').upsert(userData);
    return {"success": true, "message": 'User data updated successfully'};
  } catch (e) {
    // Log error and return failure response
    return {"success": false, "message": e.toString()};
  }
}

Future<void> deleteUserData(String userId) async {
  return await supabase.from('user_data').delete().eq('user_id', userId);
}

Future<Map<String, dynamic>> insertUserData(String userId) async {
  try {
    // Insert new user data
    await supabase.from('user_data').insert({'user_id': userId});
    return {'success': true, 'message': 'User data created successfully'};
  } catch (e) {
    // Log error and return failure response
    return {'success': false, 'message': e.toString()};
  }
}
