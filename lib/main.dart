import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:the_pink_club/core/di/service_locator.dart' as di;
import 'package:the_pink_club/core/providers/locale_cubit.dart';
import 'package:the_pink_club/core/theme/app_theme.dart';
import 'package:the_pink_club/features/about/presentation/providers/about_cubit.dart';
import 'package:the_pink_club/features/contact/presentation/providers/contact_cubit.dart';
import 'package:the_pink_club/features/providers/presentation/providers/providers_cubit.dart';
import 'package:the_pink_club/features/services/presentation/screens/splash_screen.dart';
import 'package:the_pink_club/features/subscription/presentation/providers/subscription_cubit.dart';
import 'package:the_pink_club/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<LocaleCubit>()),
        BlocProvider(create: (context) => di.sl<AboutCubit>()..fetchAbout()),
        BlocProvider(create: (context) => di.sl<ContactCubit>()),
        BlocProvider(create: (context) => di.sl<SubscriptionCubit>()),
        BlocProvider(create: (context) => di.sl<ProvidersCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'The Pink Club',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
