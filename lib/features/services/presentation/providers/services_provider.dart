import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/services_repository.dart';
import '../../data/models/service_model.dart';

final servicesRepositoryProvider = Provider(
  (ref) => ServicesRepository(ref.watch(apiClientProvider)),
);

final servicesProvider =
    FutureProvider.family<List<ServiceModel>, String>((ref, action) {
  final repo = ref.read(servicesRepositoryProvider);
  return repo.fetchServices(action);
});
