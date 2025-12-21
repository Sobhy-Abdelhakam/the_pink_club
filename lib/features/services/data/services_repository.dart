import 'package:the_pink_club/features/services/data/models/service_model.dart';

import '../../../../core/network/api_client.dart';

class ServicesRepository {
  final ApiClient api;

  ServicesRepository(this.api);

  Future<List<ServiceModel>> fetchServices(String action) async {
    final response = await api.get(action);
    return (response.data as List)
        .map((e) => ServiceModel.fromJson(e))
        .toList();
  }
}
