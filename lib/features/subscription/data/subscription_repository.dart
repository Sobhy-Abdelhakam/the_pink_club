import 'package:the_pink_club/core/cache/cache_service.dart';
import '../../../core/network/api_actions.dart';
import '../../../core/network/api_client.dart';
import './models/subscription_package.dart';

class SubscriptionRepository {
  final ApiClient api;
  final CacheService cache;

  static const _cacheKey = 'subscription_packages';

  SubscriptionRepository(this.api, this.cache);

  Future<List<SubscriptionPackage>> getPackages() async {
    try {
      // Always try to get fresh data first
      final response = await api.get(ApiActions.subscriptions);
      final List data = response.data['data'] ?? [];

      // Cache the response for 2 hours
      await cache.put(_cacheKey, data, ttl: const Duration(hours: 2));

      return data
          .map(
            (json) =>
                SubscriptionPackage.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      // On any network / parsing error, fall back to cached data if available
      final cached = await cache.get<List>(_cacheKey);
      if (cached != null) {
        return cached
            .map(
              (json) => SubscriptionPackage.fromJson(
                Map<String, dynamic>.from(json as Map),
              ),
            )
            .toList();
      }

      // No cache available, rethrow to let upper layers handle the error
      rethrow;
    }
  }

  Future<void> submitSubscription(Map<String, dynamic> body) async {
    await api.post('subscriptions', body);
  }
}
