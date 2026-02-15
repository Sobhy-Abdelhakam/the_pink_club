import 'package:equatable/equatable.dart';
import '../../data/models/service_model.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final Map<String, List<ServiceModel>> servicesMap;
  const ServicesLoaded(this.servicesMap);

  List<ServiceModel> getServices(String action) {
    return servicesMap[action] ?? [];
  }

  @override
  List<Object?> get props => [servicesMap];
}

class ServicesError extends ServicesState {
  final String message;
  const ServicesError(this.message);

  @override
  List<Object?> get props => [message];
}
