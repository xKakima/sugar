import 'package:sugar/utils/constants.dart';

Future<List<dynamic>?> fetchAccounts(String userId) async {
  return await supabase.from('account').select().eq('user_id', userId);
}
