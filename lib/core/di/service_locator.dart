import 'package:get_it/get_it.dart';
import 'package:the_pink_club/core/cache/cache_service.dart';
import 'package:the_pink_club/core/network/api_client.dart';
import 'package:the_pink_club/core/providers/locale_cubit.dart';
import 'package:the_pink_club/features/about/data/about_repository.dart';
import 'package:the_pink_club/features/about/presentation/providers/about_cubit.dart';
import 'package:the_pink_club/features/contact/data/contact_repository.dart';
import 'package:the_pink_club/features/contact/presentation/providers/contact_cubit.dart';
import 'package:the_pink_club/features/services/data/services_repository.dart';
import 'package:the_pink_club/features/services/presentation/providers/services_cubit.dart';
import 'package:the_pink_club/features/subscription/data/subscription_repository.dart';
import 'package:the_pink_club/features/subscription/presentation/providers/subscription_cubit.dart';
import 'package:the_pink_club/features/providers/data/providers_repository.dart';
import 'package:the_pink_club/features/providers/presentation/providers/providers_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core - Cache Service
  final cacheService = HiveCacheService();
  await cacheService.init();
  sl.registerLazySingleton<CacheService>(() => cacheService);

  // Core - Other Services
  sl.registerLazySingleton(() => LocaleCubit());
  sl.registerLazySingleton(() => ApiClient());

  // Repositories
  sl.registerLazySingleton(() => AboutRepository(sl.get(), sl.get()));
  sl.registerLazySingleton(() => ContactRepository(sl.get()));
  sl.registerLazySingleton(() => ServicesRepository(sl.get(), sl.get()));
  sl.registerLazySingleton(() => SubscriptionRepository(sl.get(), sl.get()));
  sl.registerLazySingleton(() => ProvidersRepository(sl.get()));

  // Blocs/Cubits
  sl.registerFactory(() => AboutCubit(sl.get()));
  sl.registerFactory(() => ContactCubit(sl.get()));
  sl.registerFactory(() => ServicesCubit(sl.get()));
  sl.registerFactory(() => SubscriptionCubit(sl.get()));
  sl.registerFactory(() => ProvidersCubit(sl.get()));
}
