import '../../data/models/subscription_package.dart';

sealed class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionPackage> packages;
  SubscriptionLoaded(this.packages);
}

class SubscriptionError extends SubscriptionState {
  final String message;
  final String? errorCode;

  SubscriptionError(this.message, {this.errorCode});
}
