import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/service_model.dart';
import '../../data/services_repository.dart';
import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepository _repository;
  final Map<String, List<ServiceModel>> _cachedServices = {};

  ServicesCubit(this._repository) : super(ServicesInitial());

  Future<void> fetchServices(String action) async {
    // If already cached in memory, emit immediately
    if (_cachedServices.containsKey(action)) {
      emit(ServicesLoaded(_cachedServices));
      return;
    }

    emit(ServicesLoading());
    try {
      final services = await _repository.fetchServices(action);
      _cachedServices[action] = services;
      emit(ServicesLoaded(Map.from(_cachedServices)));
    } catch (e) {
      print('Services fetch error for $action: $e');
      emit(ServicesError(e.toString()));
    }
  }

  /// Fetch multiple actions in parallel
  Future<void> fetchMultipleSections(List<String> actions) async {
    emit(ServicesLoading());
    
    try {
      // Fetch all sections in parallel
      final results = await Future.wait(
        actions.map((action) async {
          try {
            final services = await _repository.fetchServices(action);
            return MapEntry(action, services);
          } catch (e) {
            print('Error fetching $action: $e');
            return MapEntry(action, <ServiceModel>[]);
          }
        }),
      );

      // Update cache
      for (final entry in results) {
        _cachedServices[entry.key] = entry.value;
      }

      emit(ServicesLoaded(Map.from(_cachedServices)));
    } catch (e) {
      print('Services fetch error: $e');
      emit(ServicesError(e.toString()));
    }
  }

  List<ServiceModel> getServicesForAction(String action) {
    return _cachedServices[action] ?? [];
  }
}
