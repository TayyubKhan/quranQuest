// lib/providers/zakat_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_service.dart';

final localApiProvider = Provider<ApiService>((ref) {
  return ApiService(
      'http://127.0.0.1:8000'); // Update this if your API is hosted elsewhere
});

final apiProvider = FutureProvider.family<String, String>((ref, query) async {
  final apiService = ref.read(localApiProvider);
  return await apiService.quranQuest(query);
});
