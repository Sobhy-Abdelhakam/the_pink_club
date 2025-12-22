import 'package:dio/dio.dart';
import 'package:the_pink_club/features/providers/data/model/provider_ad_model.dart';

class ProvidersRepository {
  final Dio _dio = Dio();

  static const _url =
      'https://thepinkclub.net/admin/api/providers_ads.php';

  Future<List<ProviderAdModel>> fetchProviders() async {
    final response = await _dio.get(_url);
    final data = response.data is Map ? response.data['data'] as List : response.data as List;

    return data
        .map((e) => ProviderAdModel.fromJson(e))
        .toList();
  }
}
