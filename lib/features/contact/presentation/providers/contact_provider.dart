import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:the_pink_club/core/network/api_client.dart';
import '../../data/contact_repository.dart';

final contactRepositoryProvider = Provider(
  (ref) => ContactRepository(ApiClient()),
);

final contactProvider =
    StateNotifierProvider<ContactNotifier, AsyncValue<void>>(
  (ref) => ContactNotifier(
    ref.read(contactRepositoryProvider),
  ),
);

class ContactNotifier extends StateNotifier<AsyncValue<void>> {
  final ContactRepository repo;

  ContactNotifier(this.repo) : super(const AsyncData(null));

  Future<void> send(Map<String, dynamic> body) async {
    state = const AsyncLoading();
    try {
      await repo.sendContact(body);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
