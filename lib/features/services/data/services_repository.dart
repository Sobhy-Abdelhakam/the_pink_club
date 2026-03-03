import 'package:the_pink_club/core/cache/cache_service.dart';
import 'package:the_pink_club/features/services/data/models/service_model.dart';

import '../../../../core/network/api_client.dart';

class ServicesRepository {
  final ApiClient api;
  final CacheService cache;

  ServicesRepository(this.api, this.cache);

  Future<List<ServiceModel>> fetchServices(String action) async {
    final cacheKey = 'services_$action';

    try {
      // Always try to get fresh data first
      final response = await api.get(action);
      final data = response.data['data'] as List;

      // Cache the response for 1 hour
      await cache.put(cacheKey, data, ttl: const Duration(hours: 1));

      return data.map((e) => ServiceModel.fromJson(e)).toList();
    } catch (e) {
      // On any network / parsing error, fall back to cached data if available
      final cached = await cache.get<List>(cacheKey);
      if (cached != null) {
        return cached
            .map(
              (entry) => ServiceModel.fromJson(
                Map<String, dynamic>.from(entry as Map),
              ),
            )
            .toList();
      }

      // No cache available, rethrow to let upper layers handle the error
      rethrow;
    }
  }
}
