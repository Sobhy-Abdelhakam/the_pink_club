import 'package:equatable/equatable.dart';
import '../../data/models/subscription_package.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionPackage> packages;
  const SubscriptionLoaded(this.packages);

  @override
  List<Object?> get props => [packages];
}

class SubscriptionSubmitting extends SubscriptionState {
  final List<SubscriptionPackage> packages;
  const SubscriptionSubmitting(this.packages);

  @override
  List<Object?> get props => [packages];
}

class SubscriptionSuccess extends SubscriptionState {
  final List<SubscriptionPackage> packages;
  const SubscriptionSuccess(this.packages);

  @override
  List<Object?> get props => [packages];
}

class SubscriptionError extends SubscriptionState {
  final String message;
  final List<SubscriptionPackage>? packages;
  const SubscriptionError(this.message, {this.packages});

  @override
  List<Object?> get props => [message, packages];
}
