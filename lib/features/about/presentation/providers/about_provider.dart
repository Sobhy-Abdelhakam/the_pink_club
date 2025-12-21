import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_pink_club/core/network/api_client.dart';
import '../../data/about_repository.dart';
import '../../data/models/about_model.dart';

final aboutRepositoryProvider = Provider(
  (ref) => AboutRepository(ApiClient()),
);

final aboutProvider = FutureProvider<AboutModel>((ref) {
  final repo = ref.read(aboutRepositoryProvider);
  return repo.fetchAbout();
});
