import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/features/providers/data/model/provider_ad_model.dart';
import '../../data/providers_repository.dart';

final providersRepositoryProvider = Provider(
  (ref) => ProvidersRepository(),
);

final providersAdsProvider =
    FutureProvider<List<ProviderAdModel>>((ref) {
  final repo = ref.read(providersRepositoryProvider);
  return repo.fetchProviders();
});
