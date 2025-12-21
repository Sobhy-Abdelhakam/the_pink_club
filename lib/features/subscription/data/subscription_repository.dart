import '../../../core/network/api_client.dart';

class SubscriptionRepository {
  final ApiClient api;

  SubscriptionRepository(this.api);

  Future<void> submitSubscription(Map<String, dynamic> body) async {
    await api.post('subscriptions', body);
  }
}
