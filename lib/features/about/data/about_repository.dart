import '../../../core/network/api_client.dart';
import 'models/about_model.dart';
import '../../../core/network/api_actions.dart';

class AboutRepository {
  final ApiClient api;

  AboutRepository(this.api);

  Future<AboutModel> fetchAbout() async {
    final response = await api.get(ApiActions.about);
    return AboutModel.fromJson(response.data);
  }
}
