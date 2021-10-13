import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powerdope_services/services.dart';

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var key = sha256.convert(utf8.encode('Rj!LK#')).bytes;
  HydratedBloc.storage = await HydratedStorage.build(
    encryptionCipher: HydratedAesCipher(key),
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  await FlutterDownloader.initialize(debug: kDebugMode);

  runApp(
    PowerDopeApp(
      authRepository: AuthRestRepository(),
      gymRepository: GymRestRepository(),
      gymPackageRepository: GymPackageRestRepository(),
      trainerRepository: TrainerRestRepository(),
      trainerReviewRepository: TrainerReviewRestRepository(),
      trainerPackageRepository: TrainerPackageRestRepository(),
      dietPlanRepository: DietPlanRestRepository(),
      exerciseRepository: ExerciseRestRepository(),
      productRepository: ProductRestRepository(),
      subscriptionRepository: SubscriptionRestRepository(),
      subscriberRepository: SubscriberSampleRepository(), // Replace with REST
      carouselRepository: CarouselRestRepository(),
      subscribedUserRepository: SubscribedUserRestRepository(),
    ),
  );
}
