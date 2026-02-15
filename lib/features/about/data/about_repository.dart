import 'package:the_pink_club/core/cache/cache_service.dart';
import '../../../core/network/api_client.dart';
import 'models/about_model.dart';
import '../../../core/network/api_actions.dart';

class AboutRepository {
  final ApiClient api;
  final CacheService cache;

  static const _cacheKey = 'about_content';

  AboutRepository(this.api, this.cache);

  Future<AboutModel> fetchAbout() async {
    // Check cache first
    final cached = await cache.get<Map>(_cacheKey);

    if (cached != null) {
      return AboutModel.fromJson(Map<String, dynamic>.from(cached));
    }

    // Network fallback
    final response = await api.get(ApiActions.about);
    final data = response.data['data'] as Map<String, dynamic>;

    // Cache the response for 24 hours
    await cache.put(_cacheKey, data, ttl: const Duration(hours: 24));

    return AboutModel.fromJson(data);
  }
}
