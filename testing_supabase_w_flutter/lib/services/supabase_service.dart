import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/who_are_you.dart';

class SupabaseService {

  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();
//fetchWhoAreYous
  Future<List<WhoAreYou>> whoYouReallyAreEbuza() async {
    final response = await Supabase.instance.client
        .from('who_are_you')
        .select('*');
    print('Fetched ${response.length} rows');
    return response.map((json) => WhoAreYou.fromJson(json)).toList();
  }
}