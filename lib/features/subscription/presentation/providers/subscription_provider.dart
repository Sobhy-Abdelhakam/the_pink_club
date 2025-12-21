import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_pink_club/core/network/api_client.dart';
import '../../data/subscription_repository.dart';

final subscriptionRepositoryProvider = Provider(
  (ref) => SubscriptionRepository(ApiClient()),
);

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, AsyncValue<void>>(
  (ref) => SubscriptionNotifier(
    ref.read(subscriptionRepositoryProvider),
  ),
);

class SubscriptionNotifier extends StateNotifier<AsyncValue<void>> {
  final SubscriptionRepository repo;

  SubscriptionNotifier(this.repo) : super(const AsyncData(null));

  Future<void> submit(Map<String, dynamic> body) async {
    state = const AsyncLoading();
    try {
      await repo.submitSubscription(body);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
