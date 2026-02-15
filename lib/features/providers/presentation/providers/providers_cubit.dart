import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/providers_repository.dart';
import 'providers_state.dart';

class ProvidersCubit extends Cubit<ProvidersState> {
  final ProvidersRepository _repository;

  ProvidersCubit(this._repository) : super(ProvidersInitial());

  Future<void> fetchAds() async {
    emit(ProvidersLoading());
    try {
      final ads = await _repository.fetchProviders();
      emit(ProvidersLoaded(ads));
    } catch (e) {
      emit(ProvidersError(e.toString()));
    }
  }
}
