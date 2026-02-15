import 'package:the_pink_club/core/cache/cache_service.dart';
import 'package:the_pink_club/features/services/data/models/service_model.dart';

import '../../../../core/network/api_client.dart';

class ServicesRepository {
  final ApiClient api;
  final CacheService cache;

  ServicesRepository(this.api, this.cache);

  Future<List<ServiceModel>> fetchServices(String action) async {
    // Check cache first
    final cacheKey = 'services_$action';
    final cached = await cache.get<List>(cacheKey);

    if (cached != null) {
      // Explicitly cast from dynamic to Map<String, dynamic>
      return cached
          .map((e) => ServiceModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    // Network fallback
    final response = await api.get(action);
    final data = response.data['data'] as List;

    // Cache the response for 1 hour
    await cache.put(cacheKey, data, ttl: const Duration(hours: 1));

    return data.map((e) => ServiceModel.fromJson(e)).toList();
  }
}
