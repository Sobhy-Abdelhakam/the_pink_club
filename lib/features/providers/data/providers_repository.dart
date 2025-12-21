import 'package:dio/dio.dart';
import 'package:the_pink_club/features/providers/data/model/provider_ad_model.dart';

class ProvidersRepository {
  final Dio _dio = Dio();

  static const _url =
      'https://thepinkclub.net/admin/api/providers_ads.php';

  Future<List<ProviderAdModel>> fetchProviders() async {
    final response = await _dio.get(_url);

    return (response.data as List)
        .map((e) => ProviderAdModel.fromJson(e))
        .toList();
  }
}
