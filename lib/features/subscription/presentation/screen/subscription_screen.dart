import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_pink_club/features/subscription/presentation/providers/subscription_cubit.dart';
import 'package:the_pink_club/features/subscription/presentation/providers/subscription_state.dart';
import 'package:the_pink_club/features/subscription/presentation/widgets/subscription_card.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch packages when screen loads
    context.read<SubscriptionCubit>().fetchPackages();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chooseYourPlan), centerTitle: true),
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubscriptionError) {
            final errorMessage = _getLocalizedErrorMessage(l10n, state);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SubscriptionCubit>().fetchPackages();
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state is SubscriptionLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.packages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return SubscriptionCard(package: state.packages[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _getLocalizedErrorMessage(
    AppLocalizations l10n,
    SubscriptionError state,
  ) {
    switch (state.errorCode) {
      case SubscriptionCubit.errorNetworkError:
        return l10n.networkError;
      case SubscriptionCubit.errorTimeout:
        return l10n.requestTimeout;
      case SubscriptionCubit.errorInvalidFormat:
        return l10n.invalidDataFormat;
      case SubscriptionCubit.errorNoPackages:
        return l10n.noPackagesAvailable;
      case SubscriptionCubit.errorGeneric:
        return l10n.failedLoadPackages;
      default:
        return state.message;
    }
  }
}
