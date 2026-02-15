import 'package:dio/dio.dart';
import 'package:the_pink_club/core/cache/cache_service.dart';
import 'package:the_pink_club/features/providers/data/model/provider_ad_model.dart';

class ProvidersRepository {
  final CacheService cache;
  final Dio _dio = Dio();

  static const _url =
      'https://thepinkclub.net/admin/api/providers_ads.php';
  static const _cacheKey = 'providers_ads';

  ProvidersRepository(this.cache);

  Future<List<ProviderAdModel>> fetchProviders() async {
    // Check cache first
    final cached = await cache.get<List>(_cacheKey);

    if (cached != null) {
      return cached.map((e) => ProviderAdModel.fromJson(e)).toList();
    }

    // Network fallback
    final response = await _dio.get(_url);
    final data = response.data is Map ? response.data['data'] as List : response.data as List;

    // Cache the response for 30 minutes
    await cache.put(_cacheKey, data, ttl: const Duration(minutes: 30));

    return data.map((e) => ProviderAdModel.fromJson(e)).toList();
  }
}
