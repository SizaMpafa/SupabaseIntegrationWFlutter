import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_supabase_w_flutter/models/who_are_you.dart';
import '../services/supabase_service.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref){
  return SupabaseService();
});

final whoAreYousProvider = FutureProvider<List<WhoAreYou>>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return await service.whoYouReallyAreEbuza();
});

void refreshAbabantu(WidgetRef ref) => ref.invalidate(whoAreYousProvider);

void refreshAllData(WidgetRef ref){
  refreshAbabantu(ref);
}