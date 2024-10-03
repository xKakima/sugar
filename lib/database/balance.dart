import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<PostgrestList> fetchBalance() async {
  final balance = await supabase
      .from('balance')
      .select('*')
      .eq('user_id', {supabase.auth.currentUser?.id});
  print("fetch balance: $balance");
  return balance;
}
