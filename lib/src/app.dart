import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerdope_services/services.dart';

import 'auth/cubit/auth_cubit.dart';
import 'cart/cubit/cart_cubit.dart';
import 'shared/common.dart';
import 'splash/views/splash_view.dart';
import 'theme.dart';

class PowerDopeApp extends StatelessWidget {
  const PowerDopeApp({
    required this.authRepository,
    required this.gymRepository,
    required this.gymPackageRepository,
    required this.trainerRepository,
    required this.trainerReviewRepository,
    required this.trainerPackageRepository,
    required this.dietPlanRepository,
    required this.exerciseRepository,
    required this.productRepository,
    required this.subscriptionRepository,
    required this.subscriberRepository,
    required this.carouselRepository,
    required this.subscribedUserRepository,
    Key? key,
  }) : super(key: key);

  final AuthRepository authRepository;
  final GymRepository gymRepository;
  final GymPackageRepository gymPackageRepository;
  final TrainerRepository trainerRepository;
  final TrainerReviewRepository trainerReviewRepository;
  final TrainerPackageRepository trainerPackageRepository;
  final DietPlanRepository dietPlanRepository;
  final ExerciseRepository exerciseRepository;
  final ProductRepository productRepository;
  final SubscriptionRepository subscriptionRepository;
  final SubscriberRepository subscriberRepository;
  final CarouselRepository carouselRepository;

  final SubscribedUserRepository subscribedUserRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: gymRepository),
        RepositoryProvider.value(value: gymPackageRepository),
        RepositoryProvider.value(value: trainerRepository),
        RepositoryProvider.value(value: trainerReviewRepository),
        RepositoryProvider.value(value: trainerPackageRepository),
        RepositoryProvider.value(value: dietPlanRepository),
        RepositoryProvider.value(value: exerciseRepository),
        RepositoryProvider.value(value: productRepository),
        RepositoryProvider.value(value: subscriptionRepository),
        RepositoryProvider.value(value: subscriberRepository),
        RepositoryProvider.value(value: carouselRepository),
        RepositoryProvider.value(value: subscribedUserRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(
              repository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CartCubit(),
          ),
        ],
        child: const AdaptiveApp(),
      ),
    );
  }
}

class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomApp();
  }
}

class CustomApp extends StatelessWidget {
  const CustomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      theme: AppThemeData.theme(context),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashView.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case SplashView.routeName:
            return SplashView.route();
          default:
        }
      },
    );
  }
}
