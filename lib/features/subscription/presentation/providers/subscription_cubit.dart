import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/subscription_repository.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository _repository;

  // Error codes for localization
  static const String errorNetworkError = 'network_error';
  static const String errorTimeout = 'request_timeout';
  static const String errorInvalidFormat = 'invalid_data_format';
  static const String errorNoPackages = 'no_packages_available';
  static const String errorGeneric = 'failed_load_packages';

  SubscriptionCubit(this._repository) : super(SubscriptionInitial());

  Future<void> fetchPackages() async {
    emit(SubscriptionLoading());
    try {
      final packages = await _repository.getPackages();
      if (packages.isEmpty) {
        emit(
          SubscriptionError(
            'No packages available',
            errorCode: errorNoPackages,
          ),
        );
        return;
      }
      emit(SubscriptionLoaded(packages));
    } on Exception catch (e) {
      final errorCode = _getErrorCode(e);
      final errorMessage = _parseError(e);
      emit(SubscriptionError(errorMessage, errorCode: errorCode));
    }
  }

  String _getErrorCode(Exception error) {
    final message = error.toString();
    if (message.contains('SocketException')) {
      return errorNetworkError;
    } else if (message.contains('TimeoutException')) {
      return errorTimeout;
    } else if (message.contains('FormatException')) {
      return errorInvalidFormat;
    }
    return errorGeneric;
  }

  String _parseError(Exception error) {
    final message = error.toString();
    if (message.contains('SocketException')) {
      return 'Network error: Please check your internet connection';
    } else if (message.contains('TimeoutException')) {
      return 'Request timeout: Please try again';
    } else if (message.contains('FormatException')) {
      return 'Invalid data format from server';
    }
    return 'Failed to load packages: ${error.toString()}';
  }
}
