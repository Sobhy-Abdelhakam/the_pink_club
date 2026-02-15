import 'package:equatable/equatable.dart';
import '../../data/model/provider_ad_model.dart';

abstract class ProvidersState extends Equatable {
  const ProvidersState();

  @override
  List<Object?> get props => [];
}

class ProvidersInitial extends ProvidersState {}

class ProvidersLoading extends ProvidersState {}

class ProvidersLoaded extends ProvidersState {
  final List<ProviderAdModel> ads;
  const ProvidersLoaded(this.ads);

  @override
  List<Object?> get props => [ads];
}

class ProvidersError extends ProvidersState {
  final String message;
  const ProvidersError(this.message);

  @override
  List<Object?> get props => [message];
}
