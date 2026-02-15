import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services_repository.dart';
import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepository _repository;

  ServicesCubit(this._repository) : super(ServicesInitial());

  Future<void> fetchServices(String action) async {
    emit(ServicesLoading());
    try {
      final services = await _repository.fetchServices(action);
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }
}
