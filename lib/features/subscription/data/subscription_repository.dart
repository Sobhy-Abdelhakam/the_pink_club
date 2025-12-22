import '../../../core/network/api_actions.dart';
import '../../../core/network/api_client.dart';
import './models/subscription_package.dart';

class SubscriptionRepository {
  final ApiClient api;

  SubscriptionRepository(this.api);

  Future<List<SubscriptionPackage>> getPackages() async {
    final response = await api.get(ApiActions.subscriptions);
    final List data = response.data['data'] ?? [];
    return data.map((json) => SubscriptionPackage.fromJson(json)).toList();
  }

  Future<void> submitSubscription(Map<String, dynamic> body) async {
    await api.post('subscriptions', body);
  }
}
