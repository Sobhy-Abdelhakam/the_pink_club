import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/subscription_repository.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository _repository;

  SubscriptionCubit(this._repository) : super(SubscriptionInitial());

  Future<void> fetchPackages() async {
    emit(SubscriptionLoading());
    try {
      final packages = await _repository.getPackages();
      emit(SubscriptionLoaded(packages));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> submitSubscription(Map<String, dynamic> body) async {
    final currentPackages = state is SubscriptionLoaded
        ? (state as SubscriptionLoaded).packages
        : (state is SubscriptionSubmitting ? (state as SubscriptionSubmitting).packages : []);
    
    emit(SubscriptionSubmitting(List.from(currentPackages)));
    try {
      await _repository.submitSubscription(body);
      emit(SubscriptionSuccess(List.from(currentPackages)));
    } catch (e) {
      emit(SubscriptionError(e.toString(), packages: List.from(currentPackages)));
    }
  }
}
